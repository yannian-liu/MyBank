//
//  TouchID.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/28.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import LocalAuthentication
import UIKit

class YLTouchID {
    
    func authenticateUser(viewController: UIViewController, connectServer_Bock: @escaping () -> Void) -> Void {
        let context : LAContext = LAContext()
        context.localizedFallbackTitle = ""
        
        var error : NSError?
        let myLocalizedReasonString : NSString = "Authentication is required"

        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString as String, reply: {(success, evaluationError) -> Void in

                // reply block start
                if success {
                    OperationQueue.main.addOperation({ () -> Void in
                        print("@ touch ID locally successful @")
                        connectServer_Bock()
                    })
                } else {
                    // Authentification failed
                    print("@ touch ID locally unsuccessful because evaluation error @")
                    print(": evaluationError!.localizedDescription :",evaluationError!.localizedDescription)
                    OperationQueue.main.addOperation({ () -> Void in
                    })
                }
                // reply block end
                })

        } else {
            // the device can not do touch id action
            print("@ touch ID locally unsuccessful becuase devices error @")
            print(": error!.localizedDescription :",error!.localizedDescription)
            self.showAlertWithTitle(title: "Error", message: error!.localizedDescription, viewController: viewController)
            OperationQueue.main.addOperation({ () -> Void in
            })

        }
    }
    
    func authenticateUserAsDefaultAction(viewController: UIViewController, connectServer_Bock: @escaping () -> Void) -> Void {
        let context : LAContext = LAContext()
        context.localizedFallbackTitle = ""
        
        var error : NSError?
        let myLocalizedReasonString : NSString = "Authentication is required"
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString as String, reply: {(success, evaluationError) -> Void in
                
                // reply block start
                if success {
                    OperationQueue.main.addOperation({ () -> Void in
                        print("@ touch ID locally successful @")
                        connectServer_Bock()
                    })
                    return
                } else {
                    // Authentification failed
                    print("@ touch ID locally unsuccessful because evaluation error @")
                    print(": evaluationError!.localizedDescription :",evaluationError!.localizedDescription)
//                    OperationQueue.main.addOperation({ () -> Void in
//                    })
                    return
                }
                // reply block end
            })
            
        } else {
            // the device can not do touch id action
            print("@ touch ID locally unsuccessful becuase devices error @")
            print(": error!.localizedDescription :",error!.localizedDescription)
            //self.showAlertWithTitle(title: "Error", message: error!.localizedDescription, viewController: viewController)
//            OperationQueue.main.addOperation({ () -> Void in
//            })
            return
            
        }
    }

    
    func showAlertWithTitle(title:String, message:String,viewController: UIViewController){
        let alert_ViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok_Action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert_ViewController.addAction(ok_Action)
        viewController.present(alert_ViewController, animated: true, completion: nil)
    }
}
