//
//  UserProfileViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/18.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class UserProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var pageTitle_View = UIView()
    
    let rowHeight = AppDelegate.itemHeight
    let headerHeight = AppDelegate.itemHeight
    
    var name_Array:[String] = ["\(AppDelegate.userStandardUserDefaults.string(forKey: "firstNameDefault")!) \(AppDelegate.userStandardUserDefaults.string(forKey: "lastNameDefault")!)"]
    var currentDevice_Array : [String] = [UIDevice.current.name]
    var mail_Array : [String] = []
    var pinStatus_Array : [String] = []
    
    var name_TableView = UITableView()
    var currentDevice_TableView = UITableView()
    var mail_TableView = UITableView()
    var pinStatus_TableView = UITableView()
    
    var goHome_Button = UIButton()
    var request_JsonObject:NSMutableDictionary = NSMutableDictionary()
    var queryParameters_String = String()
    var error_Label = UILabel()
    var loading_AIView = YLActivityIndicatorView(frame: CGRect(x: 0,y:0,width: CGFloat(0),height:CGFloat(0)))

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** User Profile page ****")
        
        name_TableView = UITableView()
        currentDevice_TableView = UITableView()
        mail_TableView = UITableView()
        pinStatus_TableView = UITableView()
        
        setBackground()
        setPageTitle_View()
        initAIView()
        setGoHome_Button()
        initError_Label()
        
        makeQueryParametersForUserProfile()
        connectServer()

        NotificationCenter.default.addObserver(forName: Notification.Name("changedTheme"), object: nil, queue: nil) { notification in
            self.reload()
        }
    }
    
    func setBackground(){
        view.backgroundColor = AppDelegate.companyGrey_Color
        YLViewShadow.setViewControllerShadow(viewController: self)

    }
    
    func setPageTitle_View (){
        pageTitle_View = YLPageTitleView(title: "User Profile")
        view.addSubview(pageTitle_View)
    }
    
    func setName_TableView(){
        //name_TableView = UITableView()
        let height = getTableHeight(tableView: name_TableView, array: name_Array)
        let y = pageTitle_View.frame.origin.y + pageTitle_View.frame.size.height + AppDelegate.margin
        name_TableView = YLTableViewForUserProfile(y: y, height: height)
        
        //设置数据源和代理
        name_TableView.dataSource = self
        name_TableView.delegate = self
        view.addSubview(name_TableView)
        name_TableView.alpha = 0
    }
    
    func setCurrentDevice_TableView(){
        //currentDevice_TableView = UITableView()
        let height = getTableHeight(tableView: currentDevice_TableView, array: currentDevice_Array)
        let y = name_TableView.frame.origin.y + name_TableView.frame.size.height + AppDelegate.margin
        currentDevice_TableView = YLTableViewForUserProfile(y: y, height: height)

        //设置数据源和代理
        currentDevice_TableView.dataSource = self
        currentDevice_TableView.delegate = self
        currentDevice_TableView.alpha = 0
        view.addSubview(currentDevice_TableView)
    }
    
    func setMail_TableView(){
        //mail_TableView = UITableView()
        let height = getTableHeight(tableView: mail_TableView, array: mail_Array)
        let y = currentDevice_TableView.frame.origin.y + currentDevice_TableView.frame.size.height + AppDelegate.margin
        mail_TableView = YLTableViewForUserProfile(y: y, height: height)
        //设置数据源和代理
        mail_TableView.dataSource = self
        mail_TableView.delegate = self
        mail_TableView.alpha = 0
        view.addSubview(mail_TableView)

    }
    
    func setPinStatus_TableView(){
        //pinStatus_TableView = UITableView()
        let height = getTableHeight(tableView: pinStatus_TableView, array: pinStatus_Array)
        let y = mail_TableView.frame.origin.y + mail_TableView.frame.size.height + AppDelegate.margin
        pinStatus_TableView = YLTableViewForUserProfile(y: y, height: height)
        
        pinStatus_TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        pinStatus_TableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerCell")

        //设置数据源和代理
        pinStatus_TableView.dataSource = self
        pinStatus_TableView.delegate = self
        pinStatus_TableView.alpha = 0
        view.addSubview(pinStatus_TableView)
    }
    
    func setGoHome_Button (){
        let y = view.frame.size.height - AppDelegate.margin*2 - AppDelegate.itemHeight
        goHome_Button = YLRectButton (y: y, title: "Go Home", backgroundColor: UIColor.white, titleColor: AppDelegate.companyRed_Color)
        goHome_Button.addTarget(self, action: #selector(goHome_ButtonAction), for: .touchDown)
        
        view.addSubview(goHome_Button)
    }
    
    @objc func goHome_ButtonAction(_ sender: AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goHome"), object: self)
    }
    
    func makeQueryParametersForUserProfile(){
        print("@ make query parameters for user profile @")
        let id : String = AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!
        queryParameters_String = "?id=\(id)"
        print(": queryParameters_String : ", queryParameters_String)

    }
    
    func connectServer(){
        let connectServer_Object = YLServerConnection()
        connectServer_Object.connectWithGetMethod(AppDelegate.userProfile_Api, addRequestValue: addRequestValueForUserProfile, queryParameters: queryParameters_String , successHandler: parseJsonForUserProfile(json: ), unsuccessHandler: unccessHandler, title: "for get user profile", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
    }
    func addRequestValueForUserProfile(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "ssoTokenDefault")!, forHTTPHeaderField: "ssoToken")
    }
    
    func parseJsonForUserProfile(json: NSMutableDictionary ) {
        print("= parse json for user profile =")
        //let status = json["status"] as? String

        var jsonError: NSError?
        
        if let givenName_Array = json["givenName"] as? [String],
            let sn_Array = json["sn"] as? [String],
            let mail_Array = json["mail"] as? [String],
            let pinStatus_Array = json["pinStatus"] as? [String],
            let devicePrintProfiles_Array = json["devicePrintProfiles"] as? [String]
            {
                self.mail_Array = mail_Array
                self.pinStatus_Array = pinStatus_Array
                print("@ get user profile successfully @")
                showTableViews()
        } else {
            print("@ get user profile unsuccessfully @")
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
            }
            showTableViews()
        }

    }
    
    func unccessHandler(){
        print("@ get user profile unsuccessfully @")
    }
    
    func initError_Label(){
        error_Label = YLErrorLabel(y: goHome_Button.frame.origin.y-AppDelegate.itemHeight)
        view.addSubview(self.error_Label)
    }
    
    func initAIView(){
        let loading_AIViewWidth = view.frame.size.width
        let loading_AIViewHeight = loading_AIViewWidth
        
        let loading_AIViewframe = CGRect(x: 0, y: (view.frame.size.height-loading_AIViewHeight)/2, width:loading_AIViewWidth, height:loading_AIViewHeight)
        
        let color_UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        loading_AIView = YLActivityIndicatorView(frame: loading_AIViewframe, type:.ballScaleMultiple, color: color_UIColor, padding: 20)
        self.view.addSubview(loading_AIView)
    }
    
    func getTableHeight(tableView : UITableView, array: Array<Any>) -> CGFloat{
        var height: CGFloat = 0.0
        if array.count == 0{
            height = rowHeight + headerHeight
        } else {
            height = rowHeight * CGFloat(array.count) + headerHeight
        }
        return height
    }
    //代理设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell") as UITableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableView == name_TableView {
            if name_Array.count != 0 {
                cell.textLabel?.text = name_Array[indexPath.row]
            } else {
                cell.textLabel?.text = ""
            }
        }
        else if tableView == currentDevice_TableView{
            if currentDevice_Array.count != 0 {
                cell.textLabel?.text = currentDevice_Array[indexPath.row]
            } else {
                cell.textLabel?.text = ""
            }
        } else if tableView == mail_TableView{
            if mail_Array.count != 0 {
                cell.textLabel?.text = mail_Array[indexPath.row]
            } else {
                cell.textLabel?.text = ""
            }
        } else if tableView == pinStatus_TableView{
            if pinStatus_Array.count != 0 {
                cell.textLabel?.text = pinStatus_Array[indexPath.row]
            } else {
                cell.textLabel?.text = ""
            }
        }
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = AppDelegate.companyGrey_Color
        cell.textLabel?.font = AppDelegate.fontContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == name_TableView{
            if name_Array.count != 0{
                return name_Array.count
            } else {
                return 1
            }
        } else if tableView == currentDevice_TableView{
            if currentDevice_Array.count != 0{
                return currentDevice_Array.count
            } else {
                return 1
            }
        } else if tableView == mail_TableView{
            if mail_Array.count != 0{
                return mail_Array.count
            } else {
                return 1
            }
        } else if tableView == pinStatus_TableView{
            if pinStatus_Array.count != 0{
                return pinStatus_Array.count
            } else {
                return 1
            }
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerCell")
        //let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
        let imageView = UIImageView()
        let image_X = AppDelegate.margin
        let image_Y = CGFloat(0)
        let image_Width = AppDelegate.itemHeight
        let image_Height = AppDelegate.itemHeight
        let image_Frame = CGRect(x:image_X,y:image_Y,width:image_Width,height:image_Height)
        imageView.frame=image_Frame
        headerCell?.addSubview(imageView)
        
        let label = UILabel()
        let label_X = imageView.frame.origin.x+imageView.frame.size.width
        let label_Y = CGFloat(0)
        let label_Width = currentDevice_TableView.frame.size.width - image_Width - AppDelegate.margin*2
        let label_Height = AppDelegate.itemHeight
        let label_Frame = CGRect(x:label_X,y:label_Y,width:label_Width,height:label_Height)
        label.frame = label_Frame
        label.textColor = AppDelegate.companyGrey_Color
        label.font = AppDelegate.fontTitle
        headerCell?.addSubview(label)

        
        if tableView == name_TableView{
            label.text = "Name"
            imageView.image = UIImage(named: "name")
        } else if tableView == currentDevice_TableView{
            label.text="Current Device Name"
            imageView.image = UIImage(named: "currentDevice")
        } else if tableView == mail_TableView{
            label.text="E-mail"
            imageView.image = UIImage(named: "emailForUserProfile")
        } else if tableView == pinStatus_TableView {
            label.text="Pin Status"
            imageView.image = UIImage(named: "pinStatus")
        } else {
            print("no header")
            return UIView()
        }
        return headerCell
    }
    
    func showTableViews(){
        setName_TableView()
        setCurrentDevice_TableView()
        setMail_TableView()
        setPinStatus_TableView()
        YLShowViewWithAnimation.show(view: name_TableView)
        YLShowViewWithAnimation.show(view: currentDevice_TableView)
        YLShowViewWithAnimation.show(view: mail_TableView)
        YLShowViewWithAnimation.show(view: pinStatus_TableView)


    }
    
    func reload(){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        setBackground()
        setPageTitle_View()
        initAIView()
        setGoHome_Button()
        initError_Label()
        
        makeQueryParametersForUserProfile()
        connectServer()
        
    }

}
