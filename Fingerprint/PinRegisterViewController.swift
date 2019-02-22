//
//  PinRegisterViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/18.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class PinRegisterViewController: YLPinViewController {

    
    override func fingerprint_ButtonAction(_ sender: AnyObject){
        print("try to use fingerprint")
        print("@ touch id is not on @")
        
        let touchIDOff_AlertController = UIAlertController(title:"You can not use touch ID now", message: "You have not used this device before. Please create your pin first and then turn the touch ID switch on in the menu.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"OK", style:.cancel, handler:nil)
        touchIDOff_AlertController.addAction(cancelAction)
        self.present(touchIDOff_AlertController, animated: true, completion: nil)
        
        pin_IntArray = []
        modifyPinArea()
        
    }


    override func connectServerWithPin (){
        // create a pin
        
        if pinCreatIndex == 1 {
            pinCreat1_IntArray = pin_IntArray
            pinCreatIndex = 2
            self.pin_IntArray = []
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
                self.modifyPinArea()
                self.title_Label.text = "Please Re-enter Pin to Confirm"
            })
            
        } else {
            pinCreat2_IntArray = pin_IntArray
            
            // check the two series of pin are the same
            var same = true
            
            for i in 0...3 {
                if pinCreat1_IntArray[i] != pinCreat2_IntArray[i] {
                    same = false
                    break
                }
            }
            
            if same == true {
                var pinSend = ""
                for i in 0...3 {
                    pinSend = pinSend + String(pinCreat1_IntArray[i])
                }
                print ("pinSend: ", pinSend)
                
                makeJsonForPinRegister(pin: pinSend)
                // test
                let connectServerForCreatingPin = YLServerConnection()
                connectServerForCreatingPin.connectWithPostMethod(AppDelegate.pinRegister_Api, addRequestValue: addRequestValueForPinRegister, requestJson: request_JsonObject, successHandler: parseJsonForPinRegister(json:), unsuccessHandler: unsuccessHandler, title: "for pin register", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
                //self.performSegue(withIdentifier: "pinRegisterToNotification_Segue", sender: self)
                
            } else {
                print("PINs are not same, please try again")
                unsuccessHandler()
                hint_Label.text = "PINs did not match. Please try again."
            }
        }
    }
    
    override func setTopLeftButton() {
        logOut_Button = YLTopLeftCornerButton(title: "Back")
        logOut_Button.addTarget(self, action: #selector(PinAuthViewController.topLeftButtonAction), for: .touchDown)
        view.addSubview(logOut_Button)
    }
    
    override func topLeftButtonAction (_ sender: AnyObject){
        YLLogOutClearance.clearAll()
        performSegue(withIdentifier: "logOutFromPinRegister_Segue", sender: sender)
    }
    
    
    func addRequestValueForPinRegister(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "ssoTokenDefault")!, forHTTPHeaderField: "ssoToken")
    }
    
    
    
    func makeJsonForPinRegister (pin: String){
        print("= make json for pin register =")
        request_JsonObject.setValue(pin, forKey: "pin")
        print(": request_JsonObject: ",request_JsonObject )
    }
    
    func parseJsonForPinRegister(json: NSMutableDictionary ) {
        print("= parse json for pin register =")
        var jsonError: NSError?

        if let status = json["status"] as? String {
            print(": pinRegister response status: ", status)
            if status == "success"{
                AppDelegate.userStandardUserDefaults.set(true, forKey: "pinStatusDefault")
                AppDelegate.userStandardUserDefaults.set(2, forKey: "usernameAutologinDefault")
                print("@ pin register Successfully @")
                self.performSegue(withIdentifier: "pinRegisterToNotification_Segue", sender: self)

            } else {
                print("@ pin register UNSuccessfully @")
                unsuccessHandler()
            }

        } else {
            print("@ pin register UNSuccessfully @")
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
                unsuccessHandler()
            }
        }
    }
    
    func unsuccessHandler(){
        print("= unsuccessHandler for pin register =")
        hint_Label.text = "Creating Pin is unsuccessful. Please try again."
        isJustWrong = true
        wrong_View.isHidden = false
        pin_IntArray = []
        pinCreatIndex = 1
        pinCreat1_IntArray = []
        pinCreat2_IntArray = []

        // shake
        func completionBock(){
            self.modifyPinArea()
            self.title_Label.text = "Please create a Pin"
        }
        let pinPanel_Shake = YLShake()
        pinPanel_Shake.shake(object: self.pinPanel_View, completionBock: {
            completionBock()})
    }
    
    override func setInitialTitleLabelText()->String{
        let titleText_String = "Please create your PIN"
        return titleText_String
    }
    
    override func setInitialPinCreateIndex()->Int{
        return 1
    }

}
