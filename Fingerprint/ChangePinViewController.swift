//
//  ChangePinViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/12.
//  Copyright © 2017年 yannian liu. All rights reserved.
//


import Foundation
import UIKit

class ChangePinViewController: YLPinViewController {

    var completionPanel_View = UIView()
    var completion_Label = UILabel()
    var goHome_Button=UIButton()
    var changePin_Button = UIButton()
    var checkMarkAnimationView = YLCheckmarkAnimation()

    override func connectServerWithPin (){
        
        if pinCreatIndex == 0{
            var pinSend = ""
            for i in 0...3 {
                pinSend = pinSend + String(pin_IntArray[i])
            }
            print (": pinSend: ", pinSend)
            clearAll()
            makeJsonForPinAuth(pin: pinSend)
            // test
            
            let connectServerForPinAuth = YLServerConnection()
            connectServerForPinAuth.connectWithPostMethod(AppDelegate.pinAuth_Api, addRequestValue: addRequestValueForPinAuth(request:), requestJson: request_JsonObject, successHandler: parseJsonForPinAuth(json:), unsuccessHandler: unsuccessHandler, title: "for pin auth", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)

        } else if pinCreatIndex == 1 {
            pinCreat1_IntArray = pin_IntArray
            print (": pinCreat1_IntArray: ", pinCreat1_IntArray)
            pinCreatIndex = 2
            pin_IntArray = []
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
                self.modifyPinArea()
                self.title_Label.text = "Please re-enter pin to confirm"
            })
            
        } else {
            pinCreat2_IntArray = pin_IntArray
            print (": pinCreat2_IntArray: ", pinCreat2_IntArray)

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
                connectServerForCreatingPin.connectWithPostMethod(AppDelegate.pinRegister_Api, addRequestValue: addRequestValueForPinRegister, requestJson: request_JsonObject, successHandler: parseJsonForPinRegister(json:), unsuccessHandler: unsuccessHandler, title: "for pin change", loadingAIView: loading_AIView, errorLabel: error_Label, viewController: self)
                //self.performSegue(withIdentifier: "pinRegisterToNotification_Segue", sender: self)
                
            } else {
                print("pins are not same, please try again")
                unsuccessHandler()
                pinCreatIndex = 1
                hint_Label.text = "PINs did not match. Please try again."
                
            }
        }
    }
    
    func addRequestValueForPinAuth(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
    }
    
    func addRequestValueForPinRegister(request:NSMutableURLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "usernameDefault")!, forHTTPHeaderField: "clientId")
        request.addValue(AppDelegate.userStandardUserDefaults.string(forKey: "ssoTokenDefault")!, forHTTPHeaderField: "ssoToken")
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
    
    
    
    func makeJsonForPinRegister (pin: String){
        print("= make json for pin register =")
        request_JsonObject.setValue(pin, forKey: "pin")
        print(": request_JsonObject: ",request_JsonObject )
    }
    
    func parseJsonForPinAuth(json: NSMutableDictionary ) {
        print("= parse json for pin auth =")
        var jsonError: NSError?
        
        if let status = json["status"] as? String{
            print(": pinAuth response status: ", status )
            if status == "success" {
                print("@ pin auth Successfully @")
                title_Label.text = "Please enter your new PIN"
                pinCreatIndex = 1
                clearAll()
                modifyPinArea()

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
    
    func parseJsonForPinRegister(json: NSMutableDictionary ) {
        
        print("= parse json for pin register =")
        var jsonError: NSError?

        if let status = json["status"] as? String{
            print(": pinRegister response status: ", status )
            if status == "success" {
                AppDelegate.userStandardUserDefaults.set(true, forKey: "pinStatusDefault")
                AppDelegate.userStandardUserDefaults.set(2, forKey: "usernameAutologinDefault")
                PinChangeSuccessfulCompletetion()
                print("@ pin change Successfully @")
            } else {
                print("@ pin change UNSuccessfully @")
                unsuccessHandler()
                pinCreatIndex = 1
            }
        } else {
            print("@ pin change UNSuccessfully @")
            if let jsonError = jsonError {
                print("json error: \(jsonError)")
                unsuccessHandler()
            }
        }
    }
    
    func unsuccessHandler(){
        print("= unsuccessHandler =")

        if pinCreatIndex == 0{
            print("@ pin auth Unsuccessfully @")
            hint_Label.text = "Pin authentication is unsuccessful. Please try again."

        } else {
            print("@ pin change Unsuccessfully @")
            hint_Label.text = "Changing Pin is unsuccessful. Please try again."

        }

        isJustWrong = true
        wrong_View.isHidden = false
        clearAll()
        
        // shake
        func completionBock(){
            self.modifyPinArea()
            if pinCreatIndex == 0{
                self.title_Label.text = "Please enter your PIN"
            } else {
                self.title_Label.text = "Please enter your new PIN"
            }
        }
        let pinPanel_Shake = YLShake()
        pinPanel_Shake.shake(object: self.pinPanel_View, completionBock: {
            completionBock()})
        

    }

    func PinChangeSuccessfulCompletetion(){
        setcompletionPanel_View()
    }
    
    func setcompletionPanel_View(){
        completionPanel_View.frame = view.frame

//        let background_View = YLBackground(imageName: "pinBackground")
//        background_View.setBlurEffect()
//        completionPanel_View.addSubview(background_View)
        completionPanel_View.backgroundColor = AppDelegate.companyGrey_Color
        
        setCompletion_Label()
        setGoHome_Button()
        setChangePin_Button()
        addCheckMarkAnimationView()
        view.addSubview(completionPanel_View)
    }
    func setCompletion_Label(){
        completion_Label.textColor = UIColor.white
        completion_Label.font = AppDelegate.fontContent
        completion_Label.textAlignment = .center
        completion_Label.text = "You have successfully changed your PIN"
        completion_Label.frame = title_Label.frame
        completionPanel_View.addSubview(completion_Label)
    }
    
    func setGoHome_Button (){
        let y = view.frame.size.height/4*3
        goHome_Button = YLRectButton(y: y, title: "Go Home",backgroundColor: UIColor.white, titleColor: AppDelegate.companyRed_Color)
        goHome_Button.addTarget(self, action: #selector(goHome_ButtonAction), for: .touchDown)
        completionPanel_View.addSubview(goHome_Button)
    }
    
    func setChangePin_Button (){
        let y = goHome_Button.frame.origin.y+goHome_Button.frame.size.height+10
        changePin_Button = YLRectButton(y: y, title: "Change Pin Again",backgroundColor: UIColor.white, titleColor: AppDelegate.companyRed_Color)
        changePin_Button.addTarget(self, action: #selector(changePin_ButtonAction), for: .touchDown)
        completionPanel_View.addSubview(changePin_Button)
    }
    
    @objc func goHome_ButtonAction(_ sender: AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goHome"), object: self)
    }
    @objc func changePin_ButtonAction (_ sender: AnyObject){
        reset()
    }
    
    
    override func reset(){
        print("= reset pin view controller =")
        clearAll()
        pinCreatIndex = 0
        modifyPinArea()
        error_Label.isHidden = true
        loading_AIView.isHidden = true
        loading_AIView.stopAnimating()
        title_Label.text = "Please enter your PIN"
        hint_Label.text = ""
        wrong_View.isHidden=true
        pinPanel_View.isHidden = false
        keyboardPanel_View.isHidden = false
        checkMarkAnimationView.removeFromSuperview()
        completionPanel_View.removeFromSuperview()
    }
    
    override func setInitialTitleLabelText()->String{
        let titleText_String = "Please enter your PIN"
        return titleText_String
    }
    
    func addCheckMarkAnimationView() {
        //let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        let circleWidth = CGFloat(100)
        let circleHeight = circleWidth
        let x = (view.frame.size.width-circleWidth)/2
        let y = (view.frame.size.height-circleHeight)/2
        
        // Create a new CheckMarkAnimationView
        checkMarkAnimationView = YLCheckmarkAnimation(frame: CGRect(x:x, y:y, width:circleWidth, height:circleHeight))
        
        completionPanel_View.addSubview(checkMarkAnimationView)
        
        // Animate the drawing of the circle over the course of 1 second
        checkMarkAnimationView.animateCircle(duration: 0.8)
    }
    
    override func isFingerprintButtonHidden()->Bool{
        return true
    }
    
    func clearAll(){
        pin_IntArray = []
        pinCreat1_IntArray = []
        pinCreat2_IntArray = []

    }
}
