//
//  MenuViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/9.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var menuTitle_Label = UILabel()
    var menuContent_TableView = UITableView()
    let menuContent_Array = ["User Profile","Change PIN","Touch ID","Manage Devices","About"]
    let menuContent_ImageArray = [UIImage(named: "userProfile"), UIImage(named: "changePIN"),UIImage(named: "fingerprint"), UIImage(named: "manageDevices"), UIImage(named: "about")]
    // show_View: The area which will show on the screen as a menu
    var show_View = UIView()
    var logOut_Button = UIButton()
    
    let menuTableRowHeight = CGFloat(60)
    
    var touchID_Switch = UISwitch()
    var request_JsonObject = NSMutableDictionary()
    
    var error_Label = UILabel()
    var loading_AIView = YLActivityIndicatorView(frame: CGRect(x: 0,y:0,width: CGFloat(0),height:CGFloat(0)))
    
    var companyLogo_View = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** menu page ****")

        setShow_View()
        view.backgroundColor = AppDelegate.companyGrey_Color
        setMenuTitle_Label()
        setMenuContent_TableView()
        setLogOut_Button()
        setCompanyLogo_ImageView()
        initError_Label()
        initAIView()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("changedTheme"), object: nil, queue: nil) { notification in
            self.reload()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShow_View(){
        show_View = UIView()
        let show_ViewWidth = view.frame.size.width*4/5
        let show_ViewHeight = view.frame.size.height
        let show_ViewRect = CGRect(x:0 ,y:0, width:show_ViewWidth, height:show_ViewHeight)
        show_View.frame = show_ViewRect
        view.addSubview(show_View)
    }
    func setMenuTitle_Label(){
        menuTitle_Label.textColor = UIColor.white
        menuTitle_Label.font = AppDelegate.fontContent
        menuTitle_Label.textAlignment = .left
        
        let menuTitle_LabelWidth = show_View.frame.size.width
        let menuTitle_LabelHeight = CGFloat(30)
        
        let menuTitle_LabelRect = CGRect(x: CGFloat(20) , y: CGFloat(25), width: menuTitle_LabelWidth, height:menuTitle_LabelHeight)
        menuTitle_Label.frame = menuTitle_LabelRect
        menuTitle_Label.text = ""
        show_View.addSubview(menuTitle_Label)
    }
    
    func setMenuContent_TableView(){
        menuContent_TableView = UITableView()
        let menuContent_TableViewWidth =  show_View.frame.size.width
        let menuContent_TableViewHeight = menuTableRowHeight * CGFloat(menuContent_Array.count)
        let menuContent_TableViewRect = CGRect(x:0, y: menuTitle_Label.frame.origin.y+menuTitle_Label.frame.size.height+AppDelegate.margin * 2, width: menuContent_TableViewWidth, height: menuContent_TableViewHeight)
        menuContent_TableView.frame = menuContent_TableViewRect
        //设置数据源和代理
        menuContent_TableView.dataSource = self
        menuContent_TableView.delegate = self
        //设置重用ID
        //menuContent_TableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        menuContent_TableView.rowHeight = self.menuTableRowHeight
        menuContent_TableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        menuContent_TableView.isScrollEnabled = false
        menuContent_TableView.backgroundColor = AppDelegate.companyGrey_Color
        show_View.addSubview(menuContent_TableView)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(menuTableRowHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuContent_TableView{
            return self.menuContent_Array.count
        }else {
            return 0
        }
    }
    
    //代理设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableView == menuContent_TableView {
            cell.textLabel!.text = String(self.menuContent_Array[indexPath.row])
            cell.imageView?.image = menuContent_ImageArray[indexPath.row]
            cell.textLabel!.font = AppDelegate.fontContent
            cell.textLabel!.textColor = UIColor.white
            cell.backgroundColor = AppDelegate.companyGrey_Color
            var sb = UIView(frame: cell.bounds)
            sb.backgroundColor = AppDelegate.companyRed_Color
            cell.selectedBackgroundView = sb
            
            if indexPath.row == 2{
                // touch id switch
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                setTouchID_Switch()
                cell.accessoryView = touchID_Switch
                if AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") == nil || AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") == ""  {
                    touchID_Switch.isOn = false
                } else {
                    touchID_Switch.isOn = true
                }
                touchID_Switch.addTarget(self, action: #selector(touchID_SwitchAction), for: .valueChanged)
            } else {
                cell.accessoryView = UIImageView(image: UIImage(named: "forward"))
            }
            tableView.addSubview(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // index 2 if for touch id
        if indexPath.row != 2 {
            for i in 0...menuContent_Array.count-1 {
                if i == indexPath.row {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selected_\(i)"), object: self)
                }
                
            }
        }
    }
    
    
    func setLogOut_Button(){
        let y = menuContent_TableView.frame.origin.y+menuContent_TableView.frame.size.height + CGFloat(menuTableRowHeight)
        logOut_Button = YLRectButton(y: y, title: "Log Out", backgroundColor: UIColor.white, titleColor: AppDelegate.companyRed_Color)
        logOut_Button.frame.size.width = show_View.frame.size.width - AppDelegate.margin*2
        
        logOut_Button.addTarget(self, action: #selector(MenuViewController.logOut_ButtonAction), for: .touchDown)
        show_View.addSubview(logOut_Button)

    }
    
    @objc func logOut_ButtonAction(_ sender: AnyObject){

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContainerToPinAuth"), object: self)
    }
    @objc func touchID_SwitchAction(_ sender: Any){
        if touchID_Switch.isOn {
            print("@ touch id auth start @")
            registerTouchId()
            
        } else {
            print("@ touch id cancel @")
            AppDelegate.userStandardUserDefaults.set("", forKey: "touchIdTokenDefault")
        }
    }

    func registerTouchId (){
        makeJsonForRegisterTouchId()
        let connect_Object = YLServerConnection()
        connect_Object.connectWithPostMethod(AppDelegate.touchIDRegister_Api, addRequestValue: addRequestValueForRegisterTouchId(request:), requestJson: request_JsonObject, successHandler: parseJsonForRegisterTouchId(json: ),unsuccessHandler: unsuccessHandler, title: "for register touch ID", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
    }
    
    func addRequestValueForRegisterTouchId(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "ssoTokenDefault")!, forHTTPHeaderField: "ssoToken")
    }
    
    func makeJsonForRegisterTouchId(){
        print("= make json for Register Touch Id =")
        request_JsonObject.setValue(AppDelegate.userStandardUserDefaults.string(forKey: "deviceTokenDefault"), forKey: "deviceToken")
        print(":request_JsonObject: ",request_JsonObject)
        
    }
    
    func parseJsonForRegisterTouchId (json: NSMutableDictionary){
        print("= parse json for Register Touch Id =")
        var jsonError: NSError?
        
        if let result = json["result"] as? NSMutableDictionary {
            if let touchIdToken = result["touchIdToken"] as? String {
                AppDelegate.userStandardUserDefaults.set(touchIdToken, forKey: "touchIdTokenDefault")
                print("@ get touch ID Token successfully @")

            } else {
                print( "@ there is no touch id token @")
            }
        } else {
            print("@ get touch ID Token unsuccessfully @")

            if let jsonError = jsonError {
                print("json error: \(jsonError)")
            }
        }
    }
    
    func unsuccessHandler(){
        print("@ get touch ID Token unsuccessfully @")
        touchID_Switch.isOn = false
        AppDelegate.userStandardUserDefaults.set("", forKey: "touchIdTokenDefault")
    }

    func initError_Label(){
        let y = logOut_Button.frame.origin.y + logOut_Button.frame.size.height + AppDelegate.itemHeight
        error_Label = YLErrorLabel(y: y)
        error_Label.frame.size.width = show_View.frame.size.width - AppDelegate.margin*2
        error_Label.frame.size.height = AppDelegate.itemHeight*2
        error_Label.textColor = AppDelegate.companyRed_Color
        show_View.addSubview(self.error_Label)
    }
    
    func initAIView(){
        let loading_AIViewHeight = menuTableRowHeight*1.3
        let loading_AIViewWidth = loading_AIViewHeight
//        let loading_AIViewWidth = AppDelegate.itemHeight*2.5
//        let loading_AIViewHeight = loading_AIViewWidth
        let x = (show_View.frame.size.width-loading_AIViewWidth)/3*2
        let y = menuContent_TableView.frame.origin.y + menuTableRowHeight*2.5 - loading_AIViewHeight/2
        
        let loading_AIViewframe = CGRect(x: x, y: y, width: loading_AIViewWidth, height:loading_AIViewHeight)
        
        loading_AIView = YLActivityIndicatorView(frame: loading_AIViewframe, type:.ballPulse, color: AppDelegate.companyRed_Color, padding: 20)
        show_View.addSubview(loading_AIView)
    }
    
    func setTouchID_Switch(){
        touchID_Switch.backgroundColor = UIColor.white
        touchID_Switch.layer.cornerRadius = 16.0;
        touchID_Switch.onTintColor = AppDelegate.companyRed_Color
    }
    
    func setCompanyLogo_ImageView(){
        let image = UIImage(named:"companyLogo")
        companyLogo_View = UIImageView(image:image)
        let width = AppDelegate.itemHeight*2.5
        let height = width
        let x = (show_View.frame.size.width - width)/2
        let y = show_View.frame.size.height - AppDelegate.margin*2 - height
        let frame = CGRect(x:x, y:y, width:width, height:height)
        companyLogo_View.frame = frame
        show_View.addSubview(companyLogo_View)
    }
    func reload(){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        setShow_View()
        view.backgroundColor = AppDelegate.companyGrey_Color
        setMenuTitle_Label()
        setMenuContent_TableView()
        setLogOut_Button()
        setCompanyLogo_ImageView()
        initError_Label()
        initAIView()
        
        for i in 0 ... menuContent_Array.count-1 {
            menuContent_TableView.cellForRow(at: IndexPath(row: i, section: 0))?.backgroundColor = AppDelegate.companyGrey_Color
        }
    }
}
