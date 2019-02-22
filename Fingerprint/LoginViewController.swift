//
//  ViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/3/27.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Dispatch

class LoginViewController: UIViewController {
    
    var background_Object : YLBackground!
    var softLogoPanel_View : YLRoundView!
    var softwareLogo_ImageView : YLRoundImageView!
    var username_TextField = UITextField()
    var password_TextField : YLTextField!
    var login_Button : YLRoundButton!
    var passwordSecure_Button = UIButton()
    let passwordSecureImage_Png = UIImage(named: "passwordSecure")
    let passwordSecureNotImage_Png = UIImage(named:"passwordSecureNot")

    var request_JsonObject:NSMutableDictionary = NSMutableDictionary()
    var response_JsonObject:NSMutableDictionary = NSMutableDictionary()
    
    var rememberUsernamePanel_View = UIView()
    var rememberUsername_Label = UILabel()
    var rememberUsername_Switch = UISwitch()
    
    var forgottenPassword_Button = UIButton()
    
    var error_Label = UILabel()
    var loading_AIView = YLActivityIndicatorView(frame: CGRect(x: 0,y:0,width: CGFloat(0),height:CGFloat(0)))
    var bottomEdge_View = UIView()
    var companyLogo_View = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\n**** login page ****")
        // ********** Set Video Background ********** //
        setBackground()
        //setVideoBackground()
        
        // ********** Layout of software panel ********** //
        setSoftLogoPanel_View()
        
        // ********** Layout of username_TextField ********** //
        setLayoutOfUsername_TextField()
        
        // ********** Layout of password_TextField ********** //
        setLayoutOfPassword_TextField()
        
        // ********** Layout of login_Button ********** //
        setLayoutOfLogin_Button()
        
        // ********** Layout of rememberUsername_Label and Swith ********** //
        setRememberUsernamePanel_View()
        
        // ********** Layout of forgotten password button ********** //
        setForgottenPassword_Button()

        // ********** Layout of error label ********** //
        initError_Label()
        
        // ********** Layout of loading activity indicator ********** //
        initAIView()
        
        // ********** hide keyboard ********** //
        initTapToHideKeyboard_GR()
        
        // ********** initial bottom edge ********** //
        setBottomEdge_View()
        setCompanyLogo_ImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ---------- Function of set Image Background ---------- //
    func setBackground() {
        //background_Object = YLBackground(imageName: "loginBackground")
        view.backgroundColor = AppDelegate.companyGrey_Color
        YLViewShadow.setViewControllerShadow(viewController: self)

    }

    // ---------- Function of set Video Background ---------- //
    func setVideoBackground () {
        
        let filePath = Bundle.main.path(forResource: "BackgroundVideo", ofType: "mp4")
        let player = AVPlayer(url: NSURL(fileURLWithPath: filePath!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame;
        
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        player.seek(to: CMTime.zero);
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerLayer.player?.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                playerLayer.player?.seek(to: CMTime.zero)
                playerLayer.player?.play()
            }
        })
        self.view.layer.addSublayer(playerLayer)

// $$$$$$$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$$$$$$$$
// $$$$$$$$        code below is about playing a gif     $$$$$$$$
// $$$$$$$$&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$$$$$$$$
        
//        let filePath = Bundle.main.path(forResource: "loginBackground_Gif", ofType: "gif")
//        let video = NSData(contentsOfFile: filePath!)
//        
//        let webViewBG = UIWebView(frame: self.view.frame)
//        
//        webViewBG.load(video as! Data, mimeType:"image/gif", textEncodingName: "", baseURL: NSURL() as URL)
//        webViewBG.isUserInteractionEnabled = false;
//        self.view.addSubview(webViewBG)
        
    }
    
    // ---------- Function of Set Layout of Username_TextField ---------- //
    func setLayoutOfUsername_TextField (){
        let y = softLogoPanel_View.frame.size.height+softLogoPanel_View.frame.origin.y + AppDelegate.margin*5
        username_TextField = YLTextField(y: y, placeholder: "Username", imageName: "emailImage", keyboardType: .emailAddress)
        if AppDelegate.userStandardUserDefaults.bool(forKey: "rememberMeDefault") == true {
            username_TextField.text = AppDelegate.userStandardUserDefaults.string(forKey: "usernameLastTimeDefault")
        }
        view.addSubview(username_TextField)

    }
    
    // ---------- Function of Set Layout of Password_TextField ---------- //
    func setLayoutOfPassword_TextField(){
        let y = username_TextField.frame.origin.y + username_TextField.frame.size.height + AppDelegate.margin
        password_TextField = YLTextField(y:y, placeholder: "Password", imageName: "passwordImage", keyboardType: .alphabet)
        password_TextField.setRightViewModeWithSecureButton()

        view.addSubview(password_TextField)
    }
    
    // ---------- Function of Set Layout of Login_Button ---------- //
    func setLayoutOfLogin_Button(){
        let y = password_TextField.frame.origin.y + password_TextField.frame.size.height + AppDelegate.margin
        //login_Button = YLRectButton (y: y, title: "Login",backgroundColor: AppDelegate.companyRed_Color, titleColor: UIColor.white)
        login_Button = YLRoundButton(y: y, title: "Login", backgroundColor:UIColor.white, borderColor: UIColor.white.cgColor, titleColor: AppDelegate.companyRed_Color)
        
        login_Button.addTarget(self, action: #selector(LoginViewController.login_ButtonAction), for: .touchDown)
        view.addSubview(login_Button)

    }

    @objc func login_ButtonAction(_ sender: AnyObject){
        AppDelegate.userStandardUserDefaults.set(username_TextField.text, forKey: "usernameDefault")
        dismissKeyboard()
        makeJsonForLogin()
        // TEST
        let loginConnect = YLServerConnection()
        loginConnect.connectWithPostMethod(AppDelegate.login_Api, addRequestValue: addRequestValueForLogin(request:), requestJson: request_JsonObject, successHandler: parseJsonForLogin(json:), unsuccessHandler: unsuccessHandler, title: "for log in", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
    }

    // ---------- Function of Set remember username PANEL ---------- //
    func setRememberUsernamePanel_View(){
        let width = view.frame.size.width/2 - AppDelegate.margin
        let height = AppDelegate.itemHeight
        let x = view.frame.origin.x + AppDelegate.margin
        let y = login_Button.frame.origin.y + login_Button.frame.size.height + AppDelegate.margin
        let frame = CGRect(x:x,y:y,width:width,height:height)
        rememberUsernamePanel_View.frame = frame
        
        let switchWidth = CGFloat(50)
        let switchHeight = AppDelegate.itemHeight
        let switchX = CGFloat(0)
        let switchY = CGFloat(0)
        
        let labelWidth = CGFloat(200)
        let labelHeight = AppDelegate.itemHeight
        let labelX = switchX+switchWidth+5
        let labelY = CGFloat(0)
        
        let switchFrame = CGRect(x:switchX,y:switchY,width:switchWidth,height:switchHeight)
        rememberUsername_Switch.frame = switchFrame
        rememberUsernamePanel_View.addSubview(rememberUsername_Switch)
        if AppDelegate.userStandardUserDefaults.bool(forKey: "rememberMeDefault") == true {
            rememberUsername_Switch.isOn = true
        } else {
            rememberUsername_Switch.isOn = false
        }
        rememberUsername_Switch.layer.cornerRadius = 8.0;
        rememberUsername_Switch.onTintColor = AppDelegate.companyRed_Color
        rememberUsernamePanel_View.addSubview(rememberUsername_Switch)

        
        let labelFrame = CGRect(x:labelX, y:labelY,width:labelWidth,height:labelHeight)
        rememberUsername_Label.frame = labelFrame
        rememberUsername_Label.text = "Remember me"
        rememberUsername_Label.textColor = UIColor.white
        rememberUsername_Label.font = AppDelegate.fontContent
        rememberUsername_Label.textAlignment = .left
        rememberUsernamePanel_View.addSubview(rememberUsername_Label)
        
        view.addSubview(rememberUsernamePanel_View)

    }
    
    func setForgottenPassword_Button (){
        let width = view.frame.size.width/2 - AppDelegate.margin
        let height = AppDelegate.itemHeight
        let x = view.frame.size.width/2
        let y = login_Button.frame.origin.y + login_Button.frame.size.height + AppDelegate.margin
        let frame = CGRect(x:x,y:y,width:width,height:height)
        forgottenPassword_Button.frame = frame
        
        forgottenPassword_Button.layer.cornerRadius = 5
        forgottenPassword_Button.setTitle("Forgotten password?", for: .normal)
        forgottenPassword_Button.setTitleColor(UIColor.white, for: .normal)
        forgottenPassword_Button.titleLabel?.font = AppDelegate.fontContent
        forgottenPassword_Button.titleLabel?.textAlignment = .right
        forgottenPassword_Button.contentHorizontalAlignment = .right;
        forgottenPassword_Button.addTarget(self, action: #selector(LoginViewController.forgottenPassword_ButtonAction), for: .touchDown)
        view.addSubview(forgottenPassword_Button)

    }
    
    @objc func forgottenPassword_ButtonAction(_ sender: AnyObject){
        dismissKeyboard()
        // open a link
        if let url = NSURL(string: "http://openam.aps-iam.com:5000/#password_recovery"){
            print("@ open link for forgot password @")
            UIApplication.shared.openURL(url as URL)
        } else {
            print("@ link is wrong @")
        }
        
    }
    
    func addRequestValueForLogin(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(username_TextField.text!, forHTTPHeaderField: "clientId")
    }
    
    func makeJsonForLogin(){
        print("= make json for login =")
        
        let credentials_JsonObject: NSMutableDictionary = NSMutableDictionary()
        credentials_JsonObject.setValue(password_TextField.text, forKey: "password")
        credentials_JsonObject.setValue(username_TextField.text, forKey: "userId")

        let deviceProfile_JsonObject: NSMutableDictionary = YLMakeJson.makeJsonWithDeviceProfileAll()

        request_JsonObject.setValue(credentials_JsonObject, forKey: "credentials")
        request_JsonObject.setValue(deviceProfile_JsonObject, forKey: "deviceProfile")
        
        print(":request_JsonObject: ",request_JsonObject)

    }
    
    func parseJsonForLogin (json: NSMutableDictionary){
        print("= parse json for login =")
        var jsonError: NSError?

        if let status = json["status"] as? String, let tokens = json["tokens"] as? NSMutableDictionary, let securityAttributes = json["securityAttributes"] as? NSMutableDictionary {
            print(": login response status: ", status )
            
            if status == "success",
                let firstName = securityAttributes["firstName"] as? String,
                let lastName = securityAttributes["lastName"] as? String,
                let pinStatus = securityAttributes["pinStatus"] as? String,
                let accessToken = tokens["accessToken"]as?String,
                let deviceToken = tokens["deviceToken"]as?String,
                let ssoToken = tokens["ssoToken"]as?String
            {
                AppDelegate.userStandardUserDefaults.set(accessToken, forKey: "accessTokenDefault")
                AppDelegate.userStandardUserDefaults.set(deviceToken, forKey: "deviceTokenDefault")
                AppDelegate.userStandardUserDefaults.set(ssoToken, forKey: "ssoTokenDefault")
                
                // auto login
                if pinStatus == "active" {
                    AppDelegate.userStandardUserDefaults.set(2, forKey: "usernameAutologinDefault")
                } else{
                    AppDelegate.userStandardUserDefaults.set(1, forKey: "usernameAutologinDefault")
                }
                
                if rememberUsername_Switch.isOn{
                    AppDelegate.userStandardUserDefaults.set(username_TextField.text, forKey: "usernameLastTimeDefault")
                    AppDelegate.userStandardUserDefaults.set(true, forKey: "rememberMeDefault")
                } else{
                    AppDelegate.userStandardUserDefaults.set("", forKey: "usernameLastTimeDefault")
                    AppDelegate.userStandardUserDefaults.set(false, forKey: "rememberMeDefault")
                }
                
                //pinStatusDefault: Bool : user have a pin in this device
                if pinStatus == "active" {
                    AppDelegate.userStandardUserDefaults.set(true, forKey: "pinStatusDefault")
                } else {
                    AppDelegate.userStandardUserDefaults.set(false, forKey: "pinStatusDefault")
                }
                //firstNameDefault: String: user firstName
                AppDelegate.userStandardUserDefaults.set(firstName, forKey: "firstNameDefault")
                
                //lastNameDefault: String: user firstName
                AppDelegate.userStandardUserDefaults.set(lastName, forKey: "lastNameDefault")
                
                print("@ login Successfully @")

                if AppDelegate.userStandardUserDefaults.bool(forKey: "pinStatusDefault") == true {
                    self.performSegue(withIdentifier: "loginToContrainer_Segue", sender: self)
                } else {
                    self.performSegue(withIdentifier: "loginToPinRegister_Segue", sender: self)
                }
                
            } else {
                print("@ login UNSuccessfully @")
                if let jsonError = jsonError {
                    print("json error: \(jsonError)")
                }
            }
        } else {
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
                print("@ login UNSuccessfully @")

            }
        }
    }

    func unsuccessHandler (){
        print("= unsuccessHandler for login =")

        AppDelegate.userStandardUserDefaults.set("", forKey: "usernameDefault")
        
        username_TextField.textColor = AppDelegate.companyRed_Color
        password_TextField.textColor = AppDelegate.companyRed_Color
        
        // shake
        func completionBock(){
            self.username_TextField.textColor = UIColor.white
            self.password_TextField.textColor = UIColor.white
        }
        let usernameAndPasswordTextField_shake = YLShake()
        usernameAndPasswordTextField_shake.shakeTwo(object1: self.username_TextField, object2: self.password_TextField, completionBock: completionBock)
    }
    
    
    func initError_Label(){
        let y = forgottenPassword_Button.frame.origin.y+forgottenPassword_Button.frame.size.height+AppDelegate.margin
        error_Label = YLErrorLabel(y: y)
        view.addSubview(self.error_Label)

    }
    
    func initAIView(){
        let width = view.frame.size.width
        let height = width
        let x = CGFloat(0)
        let y = login_Button.frame.origin.y + login_Button.frame.size.height/2 - height/2
        let frame = CGRect(x:x,y:y,width:width,height:height)
        let loading_AIViewframe = frame

        let color_UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        loading_AIView = YLActivityIndicatorView(frame: loading_AIViewframe, type:.ballScaleMultiple, color: color_UIColor, padding: 20)
        view.insertSubview(loading_AIView, at: 0)

    }

    func initTapToHideKeyboard_GR(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func setBottomEdge_View(){
        let width = view.frame.size.width
        let height = view.frame.size.height/100
        let x = CGFloat(0)
        let y = view.frame.size.height - height
        let frame = CGRect(x:x,y:y,width:width,height:height)
        bottomEdge_View.frame = frame
        bottomEdge_View.backgroundColor = AppDelegate.companyRed_Color
        view.addSubview(bottomEdge_View)

    }
    
    func setSoftLogoPanel_View(){
        let radius = AppDelegate.itemHeight*1.5
        let gap = radius/8

        let x = view.frame.size.width/2 - radius
        let y = view.frame.size.height/5 - radius
        
        let backgroundColor = UIColor.white.withAlphaComponent(0.2)
        let borderColor = UIColor.lightGray.cgColor
        softLogoPanel_View = YLRoundView(radius: radius, x: x, y: y, backgroundColor: backgroundColor,borderColor: borderColor)
        
        softwareLogo_ImageView = YLRoundImageView(radius: radius-gap, x: gap, y: gap, imageName: "softwareLogo", backgroundColor: AppDelegate.companyRed_Color)
        softLogoPanel_View.addSubview(softwareLogo_ImageView)
        view.addSubview(softLogoPanel_View)

    }
    
    func setCompanyLogo_ImageView(){
        let image = UIImage(named:"companyLogo")
        companyLogo_View = UIImageView(image:image)
        let width = AppDelegate.itemHeight*2.5
        let height = width
        let x = (view.frame.size.width - width)/2
        let y = bottomEdge_View.frame.origin.y-height
        let frame = CGRect(x:x, y:y, width:width, height:height)
        companyLogo_View.frame = frame
        view.addSubview(companyLogo_View)
    }

}

