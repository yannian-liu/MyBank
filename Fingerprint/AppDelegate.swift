//
//  AppDelegate.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/3/27.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    // ~~·~~·~~·~~·~~·~~·~~·~~·~~· API ~~·~~·~~·~~·~~·~~·~~·~~·~~· //
//    static let login_Api = "http://139.162.24.71:10010/api/v1/auth/regAuth"
//    static let pinAuth_Api = "http://139.162.24.71:10010/api/v1/auth/pinAuth"
//    static let pinRegister_Api = "http://139.162.24.71:10010/api/v1/auth/registerPin"
//    static let userProfile_Api = "http://139.162.24.71:10010/api/v1/auth/getUserAttrs"
//    static let touchIDRegister_Api = "http://139.162.24.71:10010/api/v1/auth/registerTouchId"
//    static let touchIDAuth_Api = "http://139.162.24.71:10010/api/v1/auth/touchIdAuth"
//    static let getDevices_Api = "http://139.162.24.71:10010/api/v1/auth/getDevices"
//    static let deregisterDevice_Api = "http://139.162.24.71:10010/api/v1/auth/deregisterDevice"
    
    static var login_Api = YLDefaultApi.login_Api_Default
    static var pinAuth_Api = YLDefaultApi.pinAuth_Api_Default
    static var pinRegister_Api = YLDefaultApi.pinRegister_Api_Default
    static var userProfile_Api = YLDefaultApi.userProfile_Api_Default
    static var touchIDRegister_Api = YLDefaultApi.touchIDRegister_Api_Default
    static var touchIDAuth_Api = YLDefaultApi.touchIDAuth_Api_Default
    static var getDevices_Api = YLDefaultApi.getDevices_Api_Default
    static var deregisterDevice_Api = YLDefaultApi.deregisterDevice_Api_Default
    
    // ~~·~~·~~·~~·~~·~~·~~·~~·~~· user default ~~·~~·~~·~~·~~·~~·~~·~~·~~· //
    static var userStandardUserDefaults = UserDefaults.standard
    /*
     userStandardUserDefaults：
     usernameDefault: String : username for one time login
     usernameAutologinDefault: Int: 0(don't remember) 1(remember but not have a pin, or didn't finish creating a pin) 2(remenber and have a pin)
     pinStatusDefault: Bool : user have a pin in this device
     firstNameDefault: String: user firstName
     lastNameDefault: String: user firstName
     SelectedTheme: String: theme style
     
     // 👇 do not neet to clear when log out (deregister)
     rememberMeDefault : Bool: user want to remember me or not
     usernameLastTimeDefault: String : username used for last time
     // 👆 do not neet to clear when log out (deregister)

     
     tokens:
     accessToken: accessTokenDefault String
     deviceToken: deviceTokenDefault String
     ssoToken: ssoTokenDefault String
     
     touchIdToken: touchIdTokenDefault String
    */

    // ~~·~~·~~·~~·~~·~~·~~·~~·~~· colour ~~·~~·~~·~~·~~·~~·~~·~~·~~· //
    //static let deepRed_Color : UIColor = UIColor(red:180.0/255.0, green:16.0/255.0, blue:16.0/255.0, alpha: 1.0)
    static let companyRed_Color: UIColor = UIColor(red:235.0/255.0, green:34.0/255.0, blue:39.0/255.0, alpha: 1.0)
    static var companyGrey_Color: UIColor = UIColor(red:29.0/255.0, green:31.0/255.0, blue:33.0/255.0, alpha: 1.0)
    //static var companyGrey_Color : UIColor!

    
    static let lightGrey_Color = UIColor.lightGray
    static let lightestGrey_Color = UIColor(red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha: 1.0)
    

    
    // ~~·~~·~~·~~·~~·~~·~~·~~·~~· layout ~~·~~·~~·~~·~~·~~·~~·~~·~~· //
    static let margin:CGFloat = UIScreen.main.bounds.size.width/41
    static let itemHeight:CGFloat = UIScreen.main.bounds.size.height/18
    
    // ~~·~~·~~·~~·~~·~~·~~·~~·~~· font ~~·~~·~~·~~·~~·~~·~~·~~·~~· //
    static let fontContent = UIFont.systemFont(ofSize: 15)
    static let fontTitle = UIFont.boldSystemFont(ofSize: 15)
    static let fontHint = UIFont.systemFont(ofSize: 13)
    static let fontTrebuchet = UIFont(name:"Trebuchet MS", size:14)
    static let fontTrebuchetBold = UIFont(name:"TrebuchetMS-Bold", size:14)
    static let fontForPageTitle = UIFont.boldSystemFont(ofSize: 17)

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("\n**** App Delegate ****")

        // auto login
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // initialize theme accoring to current theme stored
        let theme = ThemeManager.currentTheme()
        ThemeManager.applyTheme(theme: theme)
        print("@ apply restored theme @")
        
        // go to first page
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        if AppDelegate.userStandardUserDefaults.integer(forKey: "usernameAutologinDefault") == 0 || AppDelegate.userStandardUserDefaults.integer(forKey: "usernameAutologinDefault") == 1 {
            let exampleViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = exampleViewController
            
        }else{
            let exampleViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "PinAuthViewController")
            self.window?.rootViewController = exampleViewController
        }
        self.window?.makeKeyAndVisible()

        //show request alert of location auth
        YLGeolocation.sharedInstance.showRequestAlert()
        
        // register setting bundle
        registerSettingsBundle()
        updateDisplayFromDefaults()
        NotificationCenter.default.addObserver(self,selector: #selector(AppDelegate.defaultsChanged),name: UserDefaults.didChangeNotification,object: nil)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func registerSettingsBundle(){
        print ("= register Settings Bundle =")
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
//        let ud = UserDefaults.standard
//        ud.synchronize()

    }
    
    func updateDisplayFromDefaults(){
        print ("= update Display From Defaults =")
        //Get the defaults
        let settings = UserDefaults.standard
        if let login_Api_String: String = settings.string(forKey: "login_Api"){
            if login_Api_String != ""{
                AppDelegate.login_Api = login_Api_String
            } else {
                AppDelegate.login_Api = YLDefaultApi.login_Api_Default
            }
        } else {
            AppDelegate.login_Api = YLDefaultApi.login_Api_Default
        }
        
        if let pinAuth_Api_String: String = settings.string(forKey: "pinAuth_Api"){
            if pinAuth_Api_String != ""{
                AppDelegate.pinAuth_Api = pinAuth_Api_String
            } else {
                AppDelegate.pinAuth_Api = YLDefaultApi.pinAuth_Api_Default
            }
        } else {
            AppDelegate.pinAuth_Api = YLDefaultApi.pinAuth_Api_Default
        }
        
        if let pinRegister_Api_String: String = settings.string(forKey: "pinRegister_Api"){
            if pinRegister_Api_String != ""{
                AppDelegate.pinRegister_Api = pinRegister_Api_String
            } else {
                AppDelegate.pinRegister_Api = YLDefaultApi.pinRegister_Api_Default
            }
        } else {
            AppDelegate.pinRegister_Api = YLDefaultApi.pinRegister_Api_Default
        }
        
        if let userProfile_Api_String: String = settings.string(forKey: "userProfile_Api"){
            if userProfile_Api_String != ""{
                AppDelegate.userProfile_Api = userProfile_Api_String
            } else {
                AppDelegate.userProfile_Api = YLDefaultApi.userProfile_Api_Default
            }
        } else {
            AppDelegate.userProfile_Api = YLDefaultApi.userProfile_Api_Default
        }
        
        if let touchIDRegister_Api_String: String = settings.string(forKey: "touchIDRegister_Api"){
            if touchIDRegister_Api_String != ""{
                AppDelegate.touchIDRegister_Api = touchIDRegister_Api_String
            } else {
                AppDelegate.touchIDRegister_Api = YLDefaultApi.touchIDRegister_Api_Default
            }
        } else {
            AppDelegate.touchIDRegister_Api = YLDefaultApi.touchIDRegister_Api_Default
        }
        
        if let touchIDAuth_Api_String: String = settings.string(forKey: "touchIDAuth_Api"){
            if touchIDAuth_Api_String != ""{
                AppDelegate.touchIDAuth_Api = touchIDAuth_Api_String
            } else {
                AppDelegate.touchIDAuth_Api = YLDefaultApi.touchIDAuth_Api_Default
            }
        } else {
            AppDelegate.touchIDAuth_Api = YLDefaultApi.touchIDAuth_Api_Default
        }
        
        if let getDevices_Api_String: String = settings.string(forKey: "getDevices_Api"){
            if getDevices_Api_String != ""{
                AppDelegate.getDevices_Api = getDevices_Api_String
            } else {
                AppDelegate.getDevices_Api = YLDefaultApi.getDevices_Api_Default
            }
        } else {
            AppDelegate.getDevices_Api = YLDefaultApi.getDevices_Api_Default
        }
        
        if let deregisterDevice_Api_String: String = settings.string(forKey: "deregisterDevice_Api"){
            if deregisterDevice_Api_String != ""{
                AppDelegate.deregisterDevice_Api = deregisterDevice_Api_String
            } else {
                AppDelegate.deregisterDevice_Api = YLDefaultApi.deregisterDevice_Api_Default
            }
        } else {
            AppDelegate.deregisterDevice_Api = YLDefaultApi.deregisterDevice_Api_Default
        }
        
    }
    
    
    @objc func defaultsChanged(){
        print ("= defaults Changed =")
        updateDisplayFromDefaults()
    }
}

