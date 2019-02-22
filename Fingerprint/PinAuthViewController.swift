//
//  PinViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/3/27.
//  Copyright © 2017年 yannian liu. All rights reserved.
//
import Foundation
import UIKit
import Dispatch
import MapKit
import CoreTelephony.CTTelephonyNetworkInfo

class PinAuthViewController: YLPinViewController {
    override func fingerprint_ButtonAction(_ sender: AnyObject){
        if AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") == nil || AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") == ""  {
            isAllowTouchIdAuth = false
        } else {
            isAllowTouchIdAuth = true
        }
        print(": isAllowTouchIdAuth : ",isAllowTouchIdAuth)
        print(": touchIdTokenDefault : ", AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") ?? "")

        if isAllowTouchIdAuth == true {
            print("@ touch id locally start @")
            let object_TouchID = YLTouchID()
            object_TouchID.authenticateUser(viewController: self, connectServer_Bock: connectServerWithTouchID)
        } else {
            print("@ touch id is not on @")
            let touchIDOff_AlertController = UIAlertController(title:"You can not use touch ID now", message: "Please enter your PIN and then turn the touch ID switch on in the menu.",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:"OK", style:.cancel, handler:nil)
            touchIDOff_AlertController.addAction(cancelAction)
            self.present(touchIDOff_AlertController, animated: true, completion: nil)
        }

        // for some case: enter 1 or 2 or 3 pin number and then press fingerprint button, everything should be reset
        pin_IntArray = []
        modifyPinArea()
    }
    
    func connectServerWithTouchID(){
        makeJsonForTouchIDAuth()
        let connectServer_Object = YLServerConnection()
        connectServer_Object.connectWithPostMethod(AppDelegate.touchIDAuth_Api, addRequestValue: addRequestValueForTouchIDAuth(request:), requestJson: request_JsonObject, successHandler: parseJsonForTouchIDAuth(json:), unsuccessHandler: unsuccessHandler, title: "for touch id auth", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
    }
    
    override func connectServerWithPin (){
        
        // already have a pin
        
        var pinSend = ""
        for i in 0...3 {
            pinSend = pinSend + String(pin_IntArray[i])
        }
        print (": pinSend: ", pinSend)
        
        
        makeJsonForPinAuth(pin: pinSend)
        // test
        
        let connectServerForPinAuth = YLServerConnection()
        
        connectServerForPinAuth.connectWithPostMethod(AppDelegate.pinAuth_Api, addRequestValue: addRequestValueForPinAuth(request:), requestJson: request_JsonObject, successHandler: parseJsonForPinAuth(json:), unsuccessHandler: unsuccessHandler, title: "for pin auth", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
    }
    
    override func setTopLeftButton() {
        logOut_Button = YLTopLeftCornerButton(title: "Back")
        logOut_Button.addTarget(self, action: #selector(PinAuthViewController.topLeftButtonAction), for: .touchDown)
        view.addSubview(logOut_Button)
    }
    override func topLeftButtonAction (_ sender: AnyObject){
        YLLogOutClearance.clearAll()
        performSegue(withIdentifier: "logOutFromPinAuth_Segue", sender: sender)
        
    }
    
    override func setTopRightButton(){
        forgotPin_Button = YLTopRightCornerButton(title: "Forgot Pin")
        forgotPin_Button.addTarget(self, action: #selector(PinAuthViewController.topRightButtonAction), for: .touchDown)
        view.addSubview(forgotPin_Button)
    }
    
    override func topRightButtonAction (_ sender: AnyObject){
        performSegue(withIdentifier: "pinAuthToPasswordForForgotPin_Segue", sender: sender)
    }
    


    
    func addRequestValueForPinAuth(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
    }
    
    func makeJsonForPinAuth (pin: String){
        print("= make json for pin auth =")
        let credentials_JsonObject: NSMutableDictionary = NSMutableDictionary()
        credentials_JsonObject.setValue(AppDelegate.userStandardUserDefaults.string(forKey: "deviceTokenDefault"),forKey: "deviceToken")
        credentials_JsonObject.setValue(pin, forKey: "pin")
        
        let deviceProfile_JsonObject: NSMutableDictionary = YLMakeJson.makeJsonWithDeviceProfileAll()
        
        request_JsonObject.setValue(credentials_JsonObject, forKey: "credentials")
        request_JsonObject.setValue(deviceProfile_JsonObject, forKey: "deviceProfile")
        print(": request_JsonObject: ",request_JsonObject )
    }
    
    func parseJsonForPinAuth(json: NSMutableDictionary ) {
        print("= parse json for pin auth =")
        var jsonError: NSError?

        if let status = json["status"] as? String{
            print(": pinAuth response status: ", status )
            if status == "success" {
                print("@ pin auth Successfully @")
                self.performSegue(withIdentifier: "pinAuthToContainer_Segue", sender: self)
            } else {
                print("@ pin auth UNSuccessfully @")
                unsuccessHandler()
            }
        } else {
            print("@ pin auth UNSuccessfully @")
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
            }
            unsuccessHandler()
        }
    }
    
    func parseJsonForTouchIDAuth(json: NSMutableDictionary ) {
        print("= parse json for touch id auth =")
        var jsonError: NSError?

        if let status = json["status"] as? String {
            print(": pinAuth response status: ", status )
            if status == "success" {
                print("@ pin auth Successfully @")
                self.performSegue(withIdentifier: "pinAuthToContainer_Segue", sender: self)
            } else {
                print("@ pin auth UNSuccessfully @")
                unsuccessHandler()
                hint_Label.text = "PIN is not correct. Please try again."
            }

        } else {
            print("@ pin auth UNSuccessfully @")
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
            }
            unsuccessHandler()
        }
    }
    
    func unsuccessHandler(){
        print("@ pin auth Unsuccessfully @")
        hint_Label.text = "Pin authentication is unsuccessful. Please try again."
        isJustWrong = true
        wrong_View.isHidden = false
        pin_IntArray = []
        
        // shake
        func completionBock(){
            self.modifyPinArea()
            title_Label.text = "Please enter your PIN"
        }
        let pinPanel_Shake = YLShake()
        pinPanel_Shake.shake(object: self.pinPanel_View, completionBock: {
            completionBock()})
        
        
    }
    
    func addRequestValueForTouchIDAuth(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
    }
    
    func makeJsonForTouchIDAuth (){
        print("= make json for touch id auth =")
        let credentials_JsonObject: NSMutableDictionary = NSMutableDictionary()
        credentials_JsonObject.setValue(AppDelegate.userStandardUserDefaults.string(forKey: "deviceTokenDefault"),forKey: "deviceToken")
        credentials_JsonObject.setValue(AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault"), forKey: "touchIdToken")
        
        let deviceProfile_JsonObject: NSMutableDictionary = YLMakeJson.makeJsonWithDeviceProfileAll()
        
        request_JsonObject.setValue(credentials_JsonObject, forKey: "credentials")
        request_JsonObject.setValue(deviceProfile_JsonObject, forKey: "deviceProfile")
        
        print(":request_JsonObject: ",request_JsonObject)
    }
    
    override func setInitialTitleLabelText()->String{
        let titleText_String = "Please enter your PIN"
        return titleText_String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "pinAuthToContainer_Segue") {
            let yourNextViewController = segue.destination as! ContainerViewController
            yourNextViewController.isFromRegisterPage = false
        }
        
    }
    override func authTouchIDAsDefaultAction(){
        if AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") == nil || AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") == ""  {
            isAllowTouchIdAuth = false
        } else {
            isAllowTouchIdAuth = true
        }
        print(": isAllowTouchIdAuth : ",isAllowTouchIdAuth)
        print(": touchIdTokenDefault : ", AppDelegate.userStandardUserDefaults.string(forKey: "touchIdTokenDefault") ?? "")
        
        if isAllowTouchIdAuth == true {
            print("@ touch id locally start @")
            let object_TouchID = YLTouchID()
            object_TouchID.authenticateUserAsDefaultAction(viewController: self, connectServer_Bock: connectServerWithTouchID)
        }
        
        // for some case: enter 1 or 2 or 3 pin number and then press fingerprint button, everything should be reset
        pin_IntArray = []
        modifyPinArea()

    }
}
