//
//  LogOutClearance.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/7.
//  Copyright © 2017年 yannian liu. All rights reserved.
//



class YLLogOutClearance {
    class func clearAll (){
        
        /*
         userStandardUserDefaults：
         1 usernameDefault: String : username for one time login
         2 usernameAutologinDefault: Int: 0(don't remember) 1(remember but not have a pin) 2(remenber and have a pin)
         3 pinStatusDefault: Bool : user have a pin in this device
         4 firstNameDefault: String: user firstName
         5 lastNameDefault: String: user firstName
         
         */
        AppDelegate.userStandardUserDefaults.set("", forKey: "usernameDefault")
        AppDelegate.userStandardUserDefaults.set(0, forKey: "usernameAutologinDefault")
        AppDelegate.userStandardUserDefaults.set(false, forKey: "pinStatusDefault")
        AppDelegate.userStandardUserDefaults.set("", forKey: "firstNameDefault")
        AppDelegate.userStandardUserDefaults.set("", forKey: "lastNameDefault")
        AppDelegate.userStandardUserDefaults.set("", forKey: "touchIdTokenDefault")
        
        AppDelegate.userStandardUserDefaults.set("", forKey: "accessTokenDefault")
        AppDelegate.userStandardUserDefaults.set("", forKey: "deviceTokenDefault")
        AppDelegate.userStandardUserDefaults.set("", forKey: "ssoTokenDefault")
        AppDelegate.userStandardUserDefaults.set("", forKey: "touchIdTokenDefault")
        
        AppDelegate.userStandardUserDefaults.set("", forKey: "SelectedTheme")
        ThemeManager.applyTheme(theme: .Default)

    }
}
