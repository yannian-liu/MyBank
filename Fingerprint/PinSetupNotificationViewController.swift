//
//  FingerprintAuth.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/6.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class PinSetupNotificationViewController: UIViewController {
    var pageTitle_View = UIView()
    var notification_Label = UILabel()
    var ok_Button = UIButton()
    var checkMarkAnimationView = YLCheckmarkAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n**** pin setup notification page ****")

        setBackground()
        setPageTitle_View()
        setNotification_Label()
        setCheckmarkAnimation()
        setOk_Button()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setBackground(){
        view.backgroundColor = AppDelegate.companyGrey_Color
        YLViewShadow.setViewControllerShadow(viewController: self)

    }
    func setPageTitle_View (){
        pageTitle_View = YLPageTitleView(title: "Setup Complete")
        view.addSubview(pageTitle_View)

    }

    
    func setNotification_Label(){
        notification_Label.text  = "PIN successfully setup"
        notification_Label.font = AppDelegate.fontContent
        notification_Label.textColor = UIColor.white
        notification_Label.textAlignment = .center
        
        let notification_LabelWidth = view.frame.size.width-AppDelegate.margin*2
        let notification_LabelHeight = AppDelegate.itemHeight
        let x = AppDelegate.margin
        let y = pageTitle_View.frame.origin.y + pageTitle_View.frame.size.height + AppDelegate.margin*2
        let notification_LabelRect = CGRect(x: x, y:y, width: notification_LabelWidth, height:notification_LabelHeight)
        notification_Label.frame = notification_LabelRect
        view.addSubview(notification_Label)
    }
    
    func setCheckmarkAnimation(){
        let circleWidth = CGFloat(100)
        let circleHeight = circleWidth
        let x = (view.frame.size.width-circleWidth)/2
        let y = (view.frame.size.height-circleHeight)/2
        
        // Create a new CheckMarkAnimationView
        checkMarkAnimationView = YLCheckmarkAnimation(frame: CGRect(x:x, y:y, width:circleWidth, height:circleHeight))
        
        view.addSubview(checkMarkAnimationView)
        
        // Animate the drawing of the circle over the course of 1 second
        checkMarkAnimationView.animateCircle(duration: 0.8)
    }
    
    func setOk_Button(){
        let y = view.frame.size.height - AppDelegate.margin*2 - AppDelegate.itemHeight
        ok_Button = YLRectButton(y: y, title: "OK", backgroundColor: UIColor.white, titleColor: AppDelegate.companyRed_Color)
        ok_Button.addTarget(self, action: #selector(PinSetupNotificationViewController.ok_ButtonAction), for: .touchDown)
        view.addSubview(ok_Button)
    }
    @objc func ok_ButtonAction (_ sender: AnyObject){
        performSegue(withIdentifier: "notificationToContainer_Segue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "notificationToContainer_Segue") {
            let yourNextViewController = segue.destination as! ContainerViewController
            yourNextViewController.isFromRegisterPage = true
        }
        
    }


}
