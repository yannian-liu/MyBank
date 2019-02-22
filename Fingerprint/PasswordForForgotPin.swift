//
//  PasswordForForgotPin.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/5.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class PasswordForForgotPin: UIViewController {
    var pageTitle_View : YLPageTitleView!
    var goBackToPinAuth_Button = UIButton()
    var notification_Label = UILabel()
    var password_TextField : YLTextField!
    var next_Button = UIButton()
    var forgotPassword_Button = UIButton()
    var request_JsonObject:NSMutableDictionary = NSMutableDictionary()
    var response_JsonObject:NSMutableDictionary = NSMutableDictionary()
    var error_Label = UILabel()
    var loading_AIView = YLActivityIndicatorView(frame: CGRect(x: 0,y:0,width: CGFloat(0),height:CGFloat(0)))

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** password for forgot pin ****")
        setBackground()
        setPageTitle_View()
        setGoBackToPinAuth_Button()
        setNotification_Label()
        setLayoutOfPassword_TextField()
        setNext_Button()
        setForgotPassword_Button()
        initError_Label()
        initAIView()
        initTapToHideKeyboard_GR()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground(){
        view.backgroundColor = AppDelegate.companyGrey_Color
        YLViewShadow.setViewControllerShadow(viewController: self)

        
    }
    
    func setPageTitle_View(){
        pageTitle_View = YLPageTitleView(title: "Verify Password")
        view.addSubview(pageTitle_View)
    }
    
    func setGoBackToPinAuth_Button(){
        goBackToPinAuth_Button = YLTopLeftCornerButton(title: "Go Back")
        
        goBackToPinAuth_Button.addTarget(self, action: #selector(self.goBackToPinAuth_ButtonAction), for: .touchDown)
        
        view.addSubview(goBackToPinAuth_Button)
    }
    
    @objc func goBackToPinAuth_ButtonAction (_ sender: AnyObject){
        performSegue(withIdentifier: "passwordAuthToPinAuth_Segue", sender: sender)
        
    }
    
    func setNotification_Label(){
        notification_Label.text  = "Please enter your password."
        notification_Label.font = AppDelegate.fontContent
        notification_Label.textColor = UIColor.white
        notification_Label.textAlignment = .center
        
        let notification_LabelWidth = view.frame.size.width-AppDelegate.margin*2
        let notification_LabelHeight = AppDelegate.itemHeight
        let notification_x = AppDelegate.margin
        let notification_y = view.frame.size.height/3
        let notification_LabelRect = CGRect(x: notification_x , y:notification_y, width: notification_LabelWidth, height:notification_LabelHeight)
        notification_Label.frame = notification_LabelRect
        view.addSubview(notification_Label)
    }
    
    // ---------- Function of Set Layout of Password_TextField ---------- //
    func setLayoutOfPassword_TextField(){
        let y = notification_Label.frame.origin.y + notification_Label.frame.size.height + AppDelegate.margin * 2
        password_TextField = YLTextField(y: y, placeholder: "Password", imageName: "passwordImage", keyboardType: .alphabet)
        password_TextField.setRightViewModeWithSecureButton()
        view.addSubview(password_TextField)
        
    }

    
    func setNext_Button(){
        let y = password_TextField.frame.origin.y + password_TextField.frame.size.height + AppDelegate.margin*2
        next_Button = YLRoundButton(y: y, title: "Next", backgroundColor: UIColor.white, borderColor: UIColor.white.cgColor, titleColor: AppDelegate.companyRed_Color)
        next_Button.addTarget(self, action: #selector(next_ButtonAction), for: .touchDown)
        
        view.addSubview(next_Button)
    }
    
    @objc func next_ButtonAction (_ sender: AnyObject){
        makeJsonForPasswordAuth()
        connectServerForPasswordAuth()
    }
    
    func setForgotPassword_Button(){
        let y = next_Button.frame.origin.y + next_Button.frame.size.height + AppDelegate.margin
        forgotPassword_Button = YLRectButton(y: y, title: "Forgot password?", backgroundColor: AppDelegate.companyGrey_Color, titleColor: UIColor.white)
        forgotPassword_Button.addTarget(self, action: #selector(forgotPassword_ButtonAction), for: .touchDown)
        
        view.addSubview(forgotPassword_Button)
    }
    
    @objc func forgotPassword_ButtonAction(_ sender:AnyObject){
        dismissKeyboard()
        // open a link
        if let url = NSURL(string: "http://openam.aps-iam.com:5000/#password_recovery"){
            print("@ open link for forgot password @")
            UIApplication.shared.openURL(url as URL)
        } else {
            print("@ link is wrong @")
        }
    }
    
    func connectServerForPasswordAuth(){
        let serverConnection_Object = YLServerConnection()
        serverConnection_Object.connectWithPostMethod(AppDelegate.login_Api, addRequestValue: addRequestValueForPasswordAuth(request:), requestJson: request_JsonObject, successHandler: parseJsonForPasswordAuth(json:), unsuccessHandler: unsuccessHandler, title: "for log in", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)

    }
    
    func makeJsonForPasswordAuth(){
        print("= make json for password auth =")
        
        let credentials_JsonObject: NSMutableDictionary = NSMutableDictionary()
        credentials_JsonObject.setValue(password_TextField.text, forKey: "password")
        credentials_JsonObject.setValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault"), forKey: "userId")
        
        let deviceProfile_JsonObject: NSMutableDictionary = YLMakeJson.makeJsonWithDeviceProfileAll()
        
        request_JsonObject.setValue(credentials_JsonObject, forKey: "credentials")
        request_JsonObject.setValue(deviceProfile_JsonObject, forKey: "deviceProfile")
        
        print(":request_JsonObject: ",request_JsonObject)
        
    }

    func addRequestValueForPasswordAuth(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
    }
    
    func parseJsonForPasswordAuth (json: NSMutableDictionary){
        print("= parse json for password auth =")
        var jsonError: NSError?

        if let status = json["status"] as? String {
            print(": password auth response status: ", status )
            
            if status == "success"{
                print("@ password for forgot pin Successfully @")
                self.performSegue(withIdentifier: "passwordAuthToPinRegister_Segue", sender: self)
            } else {
                print("@ password for forgot pin UNSuccessfully @")
            }

        } else {
            print("@ password for forgot pin UNSuccessfully @")
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
            }
        }
        
    }

    func unsuccessHandler(){
        print("@ password auth unsuccessfully @")
        
        password_TextField.textColor = AppDelegate.companyRed_Color
        notification_Label.text = "Password is Wrong. Please try again."
        // shake
        func completionBock(){
            self.password_TextField.textColor = UIColor.white
        }
        let shake_Object = YLShake()
        shake_Object.shake(object: password_TextField, completionBock: completionBock)
    }
    
    func initTapToHideKeyboard_GR(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func initError_Label(){
        let y = forgotPassword_Button.frame.origin.y + forgotPassword_Button.frame.size.height + AppDelegate.margin
        error_Label = YLErrorLabel(y: y)
        view.addSubview(error_Label)
    }
    
    func initAIView(){
        let width = view.frame.size.width
        let height = width
        let x = CGFloat(0)
        let y = next_Button.frame.origin.y + next_Button.frame.size.height/2 - height/2
        let frame = CGRect(x:x,y:y,width:width,height:height)
        let loading_AIViewframe = frame
        
        let color_UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        loading_AIView = YLActivityIndicatorView(frame: loading_AIViewframe, type:.ballScaleMultiple, color: color_UIColor, padding: 20)
        view.addSubview(loading_AIView)
    }

}
