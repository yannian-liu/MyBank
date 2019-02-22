//
//  ManageDevicesViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/19.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class ManageDevicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var pageTitle_View = UIView()
    var goHome_Button = UIButton()
    var devices_TableView = UITableView()
    
    var queryParameters_String = String()
    //var devices_Array = [["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone5,3","Last used: 29 Mar, 2017","Registered: 03 Aug 2013","Touch ID: Not Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"],["iPhone7,2","This Device","Registered: 22 Oct 2016","Touch ID: Enabled"]]
    
    var devices_Array : [[String]] = []

    
    var error_Label = UILabel()
    var loading_AIView = YLActivityIndicatorView(frame: CGRect(x: 0,y:0,width: CGFloat(0),height:CGFloat(0)))
    
    var request_JsonObject = NSMutableDictionary()
    
    var prepareToDelete_Cell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** Manage Devices Page ****")
        setBackground()
        setPageTitle_View()
        initAIView()
        setGoHome_Button()
        //setDevices_TableView()
        initError_Label()
        makeQueryParametersForGetDevices()
        connectServerForGetDevices()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("changedTheme"), object: nil, queue: nil) { notification in
            self.reload()
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        //resetDevices_TableViewFrame();
        
    }
    
    func setBackground(){
        view.backgroundColor = AppDelegate.companyGrey_Color
        YLViewShadow.setViewControllerShadow(viewController: self)

    }
    
    func setPageTitle_View (){
        pageTitle_View = YLPageTitleView(title: "Manage Devices")
        view.addSubview(pageTitle_View)
    }
    
    func setGoHome_Button (){
        let y = view.frame.size.height - AppDelegate.itemHeight - AppDelegate.margin*2
        goHome_Button = YLRectButton(y: y, title: "Go home", backgroundColor: UIColor.white, titleColor: AppDelegate.companyRed_Color)
        
        goHome_Button.addTarget(self, action: #selector(goHome_ButtonAction), for: .touchDown)
        
        view.addSubview(goHome_Button)
    }

    @objc func goHome_ButtonAction(_ sender: AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goHome"), object: self)
    }
    
    func setDevices_TableView(){
        //设置重用ID
        devices_TableView = UITableView()
        devices_TableView.estimatedRowHeight = CGFloat(120)
        devices_TableView.rowHeight = CGFloat(120)

        let width = view.frame.size.width
        let height = setDevicesTableViewHeight()
        let x = CGFloat(0)
        let y = pageTitle_View.frame.origin.y + pageTitle_View.frame.size.height
        let frame = CGRect(x:x,y:y,width:width,height:height)
        devices_TableView.frame = frame
        //devices_TableView.sectionHeaderHeight = AppDelegate.itemHeight
        devices_TableView.allowsSelection = false

        //设置数据源和代理
        devices_TableView.dataSource = self
        devices_TableView.delegate = self
        devices_TableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        devices_TableView.alpha = 0
        view.addSubview(devices_TableView)
        YLShowViewWithAnimation.show(view: devices_TableView)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices_Array.count
    }
    
    //代理设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell") as UITableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let cellContent_Array = self.devices_Array[indexPath.row]
        let deviceName_String: String = String(cellContent_Array[0])
        let deviceLastUse_String:String = String(cellContent_Array[1])
        let deviceRegistered_String:String = String(cellContent_Array[2])
        let deviceTouchID_String : String = String(cellContent_Array[3])
        
        let deviceDetail_String = deviceLastUse_String+"\n"+deviceRegistered_String+"\n"+deviceTouchID_String
        cell.textLabel?.attributedText = makeAttributedString(title: deviceName_String, subtitle: deviceDetail_String)

        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        //tableView.addSubview(cell)
        
        let delete_Button = UIButton(type: .system)
        delete_Button.backgroundColor = AppDelegate.companyRed_Color
        delete_Button.setTitleColor(UIColor.white, for: .normal)
        delete_Button.titleLabel?.font = AppDelegate.fontContent
        delete_Button.setTitle("Deregister", for: UIControl.State.normal)
        delete_Button.layer.cornerRadius = 5

        let delete_ButtonWidth = CGFloat(80)
        let delete_ButtonHeight = CGFloat(30)
        let delete_ButtonRect = CGRect(x:devices_TableView.frame.size.width - delete_ButtonWidth - 20,y: (devices_TableView.rowHeight - delete_ButtonHeight)/2, width:delete_ButtonWidth,height: delete_ButtonHeight)
        delete_Button.frame = delete_ButtonRect
        delete_Button.addTarget(self, action: #selector(delete_ButtonAction), for: UIControl.Event.touchUpInside)
        delete_Button.tag = indexPath.row
        cell.contentView.addSubview(delete_Button)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func resetDevices_TableViewFrame()
    {

        if(self.devices_TableView.contentSize.height < self.devices_TableView.frame.height){
            var frame: CGRect = self.devices_TableView.frame;
            frame.size.height = self.devices_TableView.contentSize.height;
            self.devices_TableView.frame = frame;
        }
        devices_TableView.isHidden = false

    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): AppDelegate.fontTitle, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): AppDelegate.companyGrey_Color] as [String : Any]
        let subtitleAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):  AppDelegate.fontContent,convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): AppDelegate.companyGrey_Color] as [String : Any]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n\n", attributes: convertToOptionalNSAttributedStringKeyDictionary(titleAttributes) )
        let subtitleString = NSAttributedString(string: subtitle, attributes: convertToOptionalNSAttributedStringKeyDictionary(subtitleAttributes))
        
        titleString.append(subtitleString)
        
        return titleString
    }
    
    func initError_Label(){
        let y = (view.frame.size.height - AppDelegate.itemHeight)/2
        error_Label = YLErrorLabel(y: y)
        self.view.addSubview(self.error_Label)
    }
    
    
    func initError_LabelForOneRow(row: Int){
        let y = devices_TableView.frame.origin.y + devices_TableView.rowHeight*(CGFloat(row)+0.5) - AppDelegate.itemHeight/2
        error_Label = YLErrorLabel(y: y)
        self.view.addSubview(self.error_Label)
    }
    
    func initAIView(){
        let loading_AIViewWidth = view.frame.size.width
        let loading_AIViewHeight = loading_AIViewWidth
        
        let loading_AIViewframe = CGRect(x: 0, y: (view.frame.size.height-loading_AIViewHeight)/2, width:loading_AIViewWidth, height:loading_AIViewHeight)
        
        let color_UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        loading_AIView = YLActivityIndicatorView(frame: loading_AIViewframe, type:.ballScaleMultiple, color: color_UIColor, padding: 20)
        self.view.addSubview(loading_AIView)
    }
    
    
    func initAIViewForOneRow(row: Int){
        let loading_AIViewHeight = devices_TableView.rowHeight
        let loading_AIViewWidth = loading_AIViewHeight
        let x = (devices_TableView.frame.size.width-loading_AIViewWidth)/2
        let y = devices_TableView.frame.origin.y + devices_TableView.rowHeight*(CGFloat(row)+0.5) - loading_AIViewHeight/2
        let loading_AIViewframe = CGRect(x: x, y: y, width: loading_AIViewWidth, height:loading_AIViewHeight)
        loading_AIView = YLActivityIndicatorView(frame: loading_AIViewframe, type:.ballPulse, color: AppDelegate.companyRed_Color, padding: 20)
        self.view.addSubview(loading_AIView)
    }
    
    @objc func delete_ButtonAction (_ sender: UIButton){
        prepareToDelete_Cell = sender.superview?.superview as! UITableViewCell

        let delete_AlertController = UIAlertController(title:"Are you sure you want to deregister this device", message:"",preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title:"Cancel", style:.cancel, handler:nil)
        let continueAction = UIAlertAction(title:"Continue", style:.default, handler: { delete_AlertController in
//            self.makeJsonForDeregisterDevice()
//            self.connectServerForDeregisterDevice()
            YLLogOutClearance.clearAll()
            self.performSegue(withIdentifier: "manageDevicesToLogin_Segue", sender: sender)
            
        })
        
        delete_AlertController.addAction(cancelAction)
        delete_AlertController.addAction(continueAction)
        self.present(delete_AlertController, animated: true, completion: nil)
        
    }

    func setDevicesTableViewHeight()->CGFloat{
        let devices_TableViewHeightLimitation = goHome_Button.frame.origin.y - AppDelegate.margin - (pageTitle_View.frame.origin.y + pageTitle_View.frame.size.height)
        var devices_TableViewHeight = CGFloat(0)
        if (devices_TableView.rowHeight * CGFloat(devices_Array.count)) < devices_TableViewHeightLimitation {
            devices_TableViewHeight = devices_TableView.rowHeight * CGFloat(devices_Array.count)
            devices_TableView.isScrollEnabled = false
            
        } else {
            devices_TableViewHeight = devices_TableViewHeightLimitation
            devices_TableView.isScrollEnabled = true
            
        }
        return devices_TableViewHeight
    }
    
    func makeQueryParametersForGetDevices(){
        print("= make query parameters for get devices =")
        //let id : String = AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!
        queryParameters_String = "?devicePrintProfiles=devicePrintProfiles"
        print(": queryParameters_String : ", queryParameters_String)
        
    }
    
    func makeJsonForDeregisterDevice(){
        print("= make json for deregister device =")
        
        let deviceToken = AppDelegate.userStandardUserDefaults.string(forKey: "deviceTokenDefault")
        request_JsonObject.setValue(deviceToken, forKey: "deviceToken")
        
        print(":request_JsonObject: ",request_JsonObject)
    }
    
    func addRequestValueForGetDevices(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "ssoTokenDefault")!, forHTTPHeaderField: "ssoToken")
    }
    
    func addRequestValueForDeregisterDevice(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "ssoTokenDefault")!, forHTTPHeaderField: "ssoToken")
    }
    
    func connectServerForGetDevices(){
        let connectServer_Object = YLServerConnection()
        connectServer_Object.connectWithGetMethod(AppDelegate.getDevices_Api, addRequestValue: addRequestValueForGetDevices, queryParameters: queryParameters_String , successHandler: parseJsonForGetDevices(json: ), unsuccessHandler: unsuccessHandler, title: "for get device profile", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
    }
    
    func connectServerForDeregisterDevice(){
        if let deletionIndexPath = self.devices_TableView.indexPath(for: prepareToDelete_Cell ){
            print("@ prepared to delete cell @ ",deletionIndexPath)
            initAIViewForOneRow(row: (deletionIndexPath.row))
            initError_LabelForOneRow(row: (deletionIndexPath.row))
        } else {
            print("@ error : something wrong with the row you selected @")
        }
        
        let connectServer_Object = YLServerConnection()
        connectServer_Object.connectWithPostMethod(AppDelegate.deregisterDevice_Api, addRequestValue: addRequestValueForDeregisterDevice(request:), requestJson: request_JsonObject, successHandler: parseJsonForDeregisterDevice, unsuccessHandler: unsuccessHandler, title: "for deregister device", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
    }
    
    func parseJsonForGetDevices(json: NSMutableDictionary ) {
        print("= parse json for get devices =")
        //let status = json["status"] as? String
        
        var jsonError: NSError?
        print("here")


        if let devicePrintProfiles_Array = json["devicePrintProfiles"] as? [String]
        {
            //Convert jsonString to jsonArray
            if devicePrintProfiles_Array.count == 0{
                // no devices
                
            } else {
                var jsonString = "["
                for i in 0...devicePrintProfiles_Array.count-1{
                    jsonString = jsonString+devicePrintProfiles_Array[i]
                    if i != devicePrintProfiles_Array.count - 1 {
                        jsonString = jsonString+","
                    }
                }
                jsonString = jsonString+"]"
                let allJson: [NSDictionary] = jsonString.parseJSONString as! [NSDictionary]
                print(": parsed JSON : \(allJson)")
                print("\n\n")
                
                
                // get information to string
                for i in 0...devicePrintProfiles_Array.count-1{
                    
                    var oneDeviceArray : [String] = []
                    let oneDeviceJson:NSDictionary = allJson[i]
                    print(": oneDeviceJson No. \(i) :\n",oneDeviceJson)
                    
                    let uuid: String = oneDeviceJson["uuid"] as! String
                    
                    let lastSelectedDate: NSNumber = oneDeviceJson["lastSelectedDate"] as! NSNumber
                    let lastSelectedDateLocal_String = convertNSNumberToLocalNSDate(number: lastSelectedDate)
                    
                    let devicePrint = oneDeviceJson ["devicePrint"] as! NSDictionary
                    let hardwareId:String = devicePrint["hardwareId"] as! String
                    let ostype:String = devicePrint["ostype"] as! String
                    let osversion:String = devicePrint["osversion"] as!String
                    
                    let system: String = "\(ostype) \(osversion)"

                    oneDeviceArray.append("Hardware Id: \(hardwareId)")
                    oneDeviceArray.append("System: \(system)")
                    oneDeviceArray.append("Uuid: \(uuid)")
                    oneDeviceArray.append("Last Login Time: \(lastSelectedDateLocal_String)")
                    
                    devices_Array.append(oneDeviceArray)
                 
                }
                setDevices_TableView()

            }
        } else {
            print("@ get user profile unsuccessfully @")
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
            }
        }
    
        //
    }
    
    
    func parseJsonForDeregisterDevice(json: NSMutableDictionary ) {
        if let status = json["status"] as? String {
            if status == "success" {
                if let deletionIndexPath = self.devices_TableView.indexPath(for: prepareToDelete_Cell ) {
                    self.devices_Array.remove(at: deletionIndexPath.row)
                    self.devices_TableView.deleteRows(at: [deletionIndexPath], with: .fade)
                    print(": deletionIndexPath : ", deletionIndexPath)
                    
                    self.devices_TableView.frame.size.height = self.setDevicesTableViewHeight()
                }
            } else {
                unsuccessHandler()
            }
        } else {
            unsuccessHandler()
        }
    }



    func unsuccessHandler(){
        print("@ get user profile unsuccessfully @")
    }
    
    func convertNSNumberToLocalNSDate (number: NSNumber) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(number)/1000)
        
        // "Jul 23, 2014, 11:01 AM" <-- looks local without seconds. But:

        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "H:mm:ss"
        dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        
//        let dt = dateFormator.date(from: date)
        let dt = date
        dateFormator.timeZone = TimeZone.current
        dateFormator.dateFormat = "MM-dd-yyyy HH:mm ZZZ"
        
        return dateFormator.string(from: dt as Date)
    }

    func reload(){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        setBackground()
        setPageTitle_View()
        initAIView()
        setGoHome_Button()
        //setDevices_TableView()
        initError_Label()
        makeQueryParametersForGetDevices()
        connectServerForGetDevices()

        if devices_Array.count > 0 {
            for i in 0 ... devices_Array.count-1 {
                devices_TableView.cellForRow(at: IndexPath(row: i, section: 0))?.textLabel?.textColor = AppDelegate.companyGrey_Color
            }
        }
    }
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
