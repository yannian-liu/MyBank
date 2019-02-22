//
//  ConnectServer.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/5.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class YLServerConnection {

    //var loading_AIView = NVActivityIndicatorView(frame: CGRect(x: 0,y:0,width: CGFloat(0),height:CGFloat(0)))
    var waitingLength_Int : Int!
    var timer_Timer: Foundation.Timer!
    var protection_View = UIView()
    
    func connectWithPostMethod(_ urlString: String, addRequestValue: @escaping (_ request: NSMutableURLRequest) -> Void,requestJson: NSMutableDictionary,  successHandler: @escaping (_ json: NSMutableDictionary) -> Void, unsuccessHandler: @escaping () -> Void, title: String, loadingAIView:YLActivityIndicatorView, errorLabel:UILabel, viewController: UIViewController) {
        
        print ("= connect with server ",title, " =")
        startConnectionViewChange(viewController: viewController, loadingAIView: loadingAIView, errorLabel: errorLabel)
        
        let url = URL(string: urlString)
        
        //let session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        // to be tested
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
        let request = NSMutableURLRequest(url:url!);
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestJson, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(": error at make request httpBody : ", error.localizedDescription)
            endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: error.localizedDescription)
            unsuccessHandler()
        }
        
        addRequestValue(request)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if error != nil
            {
                print(": error in connection : ", error?.localizedDescription ?? "unknown")
                self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: (error?.localizedDescription)!)
                unsuccessHandler()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                let statusCodeFirstDigit = statusCode/100
                let description_String = YLServerConnectionStatusCode.getDescription(statusCode: statusCode)
                
                do {
                    if let response_JsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                        if statusCodeFirstDigit == 2 {
                            print(": status code : ",statusCode)
                            print(": response json: ", response_JsonObject)
                            self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: "")
                            successHandler(response_JsonObject as! NSMutableDictionary)
                        } else if statusCodeFirstDigit == 4 {
                            print(": status code : ",statusCode)
                            print(": response json: ", response_JsonObject)
                            self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText:"")
                            unsuccessHandler()
                        } else{
                            print(": status code : ",statusCode)
                            print(": response json: ", response_JsonObject)
                            self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: "Error Code: \(statusCode) Server is not working.")
                            unsuccessHandler()
                        }
                    }
                    
                } catch let error {
                    print(": error in get json : \(error.localizedDescription)")
                    self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: error.localizedDescription)
                    unsuccessHandler()
                }
                
            }

            
        })
        task.resume()

    }
    
    func connectWithGetMethod(_ urlString: String, addRequestValue: @escaping (_ request: NSMutableURLRequest) -> Void, queryParameters: String,  successHandler: @escaping (_ json: NSMutableDictionary) -> Void, unsuccessHandler:@escaping ()->Void, title: String, loadingAIView:YLActivityIndicatorView, errorLabel:UILabel, viewController: UIViewController) {
        
        print ("= connect with server ",title, " =")
        startConnectionViewChange(viewController: viewController, loadingAIView: loadingAIView, errorLabel: errorLabel)

        let configuration = URLSessionConfiguration.default
        // to be tested
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
                
        // Define server side script URL
        let scriptUrl = AppDelegate.userProfile_Api
        // Add one parameter
        let urlWithParams = scriptUrl + queryParameters
        // Create NSURL Ibject
        let url = NSURL(string: urlWithParams);
        // Create URL Request
        let request = NSMutableURLRequest(url:url! as URL);
        
        request.httpMethod = "GET"
        
        addRequestValue(request)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest) {data, response, error in
            // Check for error
            if error != nil
            {
                print(": error in connection : \(String(describing: error))")
                self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: (error?.localizedDescription)!)
                unsuccessHandler()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                let statusCodeFirstDigit = httpResponse.statusCode/100
                let description_String = YLServerConnectionStatusCode.getDescription(statusCode: statusCode)
                
                do {
                    if let response_JsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                        if statusCodeFirstDigit == 2{
                            print(": status code : ",statusCode)
                            print(": response json: ", response_JsonObject)
                            self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: "")
                            successHandler(response_JsonObject as! NSMutableDictionary)
                        } else if statusCodeFirstDigit == 4 {
                            print(": status code : ",statusCode)
                            print(": response json: ", response_JsonObject)
                            self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: "")
                            unsuccessHandler()
                        } else {
                            print(": status code : ",statusCode)
                            print(": response json: ", response_JsonObject)
                            self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: "Error Code: \(statusCode) Server is not working")
                            unsuccessHandler()
                        }

                    }
                } catch let error {
                    print(": error : ", error.localizedDescription)
                    self.endConnectionViewChange(loadingAIView: loadingAIView, errorLabel: errorLabel, labelText: (error.localizedDescription))
                    unsuccessHandler()
                }

            }
            
        }
        
        task.resume()

    }
    
    func startAIView(loadingAIView: YLActivityIndicatorView){
        OperationQueue.main.addOperation {
            loadingAIView.isHidden = false
            loadingAIView.startAnimating()
            self.waitingLength_Int = 5
        }
    }

    func stopAIView(loadingAIView: YLActivityIndicatorView){
        OperationQueue.main.addOperation {
            //self.timer_Timer.invalidate()
            self.waitingLength_Int = 5
            loadingAIView.isHidden = true
            loadingAIView.stopAnimating()
        }
    }
    
    func initProtectionView(viewController: UIViewController){
        protection_View.frame = viewController.view.frame
        protection_View.backgroundColor = UIColor.clear
        OperationQueue.main.addOperation {
            viewController.view.addSubview(self.protection_View)
        }
    }
    
    func removeProtectionView(){
        OperationQueue.main.addOperation {
            self.protection_View.removeFromSuperview()
        }
    }
    
    func hideErrorLabel(errorLabel:UILabel){
        OperationQueue.main.addOperation {
            errorLabel.text = ""
            errorLabel.isHidden = true
        }
    }
    
    func showErrorLabel(errorLabel:UILabel,labelText:String){
        OperationQueue.main.addOperation {
            errorLabel.text = labelText
            errorLabel.isHidden = false
        }
    }
    
    func startConnectionViewChange(viewController: UIViewController,loadingAIView: YLActivityIndicatorView,errorLabel:UILabel){
        self.initProtectionView(viewController: viewController)
        self.startAIView(loadingAIView: loadingAIView)
        self.hideErrorLabel(errorLabel: errorLabel)
        
    }
    func endConnectionViewChange(loadingAIView: YLActivityIndicatorView,errorLabel:UILabel,labelText:String){
        self.removeProtectionView()
        self.stopAIView(loadingAIView: loadingAIView)
        self.showErrorLabel(errorLabel: errorLabel, labelText: labelText)
    }
}

