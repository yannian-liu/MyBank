//
//  About.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/19.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    var pageTitle_View = UIView()
    var goHome_Button = UIButton()
    var companylogo_ImageView = UIImageView()
    var stylePanel_View = UIView()
    var styleButton1_Button : YLRectButton!
    var styleButton2_Button : YLRectButton!
    var styleButton3_Button : YLRectButton!
    var content_Label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** About page ****")
        setBackground()
        setPageTitle_View()
        setGoHome_Button()
        setCompanyLogo_ImageView()
        setStylePanel()
        initStyleButtonBackgroundColor()
        setContent_Label()
    }
    
    func setBackground(){
        view.backgroundColor = AppDelegate.companyGrey_Color
        YLViewShadow.setViewControllerShadow(viewController: self)

    }
    
    func setPageTitle_View (){
        pageTitle_View = YLPageTitleView(title: "About Cyberinc")
        view.addSubview(pageTitle_View)
    }
    
    func setGoHome_Button (){
        let y = view.frame.size.height - AppDelegate.itemHeight - AppDelegate.margin*2
        goHome_Button = YLRectButton(y: y, title: "Go Home", backgroundColor: UIColor.white, titleColor: AppDelegate.companyRed_Color)
        goHome_Button.addTarget(self, action: #selector(goHome_ButtonAction), for: .touchDown)
        
        view.addSubview(goHome_Button)
    }
    
    @objc func goHome_ButtonAction(_ sender: AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goHome"), object: self)
    }
    
    func setCompanyLogo_ImageView() {
        companylogo_ImageView.backgroundColor = AppDelegate.companyGrey_Color
        let image = UIImage(named: "companyLogoColor")
        companylogo_ImageView.image = image
        let width = view.frame.size.width/2
        let height = width
        let x = (view.frame.size.width - width)/2
        let y = pageTitle_View.frame.origin.y + pageTitle_View.frame.size.height + AppDelegate.itemHeight
        let frame = CGRect(x:x, y:y, width:width, height: height)
        companylogo_ImageView.frame = frame
        view.addSubview(companylogo_ImageView)
    }
    
    func setStylePanel(){
        stylePanel_View = UIView()
        let width = view.frame.size.width-AppDelegate.margin*2
        let height = AppDelegate.itemHeight
        let x = AppDelegate.margin
        let y = goHome_Button.frame.origin.y - AppDelegate.margin - height
        let frame = CGRect(x:x,y:y,width:width,height:height)
        stylePanel_View.frame = frame
        stylePanel_View.backgroundColor = AppDelegate.companyGrey_Color
        view.addSubview(stylePanel_View)
        
        let titleWidth = AppDelegate.itemHeight*2
        let titleHeight = AppDelegate.itemHeight
        let titleX = CGFloat(0)
        let titleY = CGFloat(0)
        let titleFrame = CGRect(x:titleX,y:titleY,width:titleWidth,height:titleHeight)
        let title_Label = UILabel(frame: titleFrame)
        title_Label.text = "Style"
        title_Label.textAlignment = .center
        title_Label.font = AppDelegate.fontTitle
        title_Label.textColor = UIColor.white
        stylePanel_View.addSubview(title_Label)
        
        styleButton1_Button = YLRectButton(y: CGFloat(0), title: "Grey", backgroundColor: UIColor.white, titleColor: AppDelegate.companyGrey_Color)
        styleButton1_Button.frame.size.width = AppDelegate.itemHeight*2
        styleButton1_Button.frame.origin.x = title_Label.frame.origin.x + title_Label.frame.size.width + AppDelegate.margin
        styleButton1_Button.addTarget(self, action: #selector(styleButton1_ButtonAction), for: .touchUpInside)
        stylePanel_View.addSubview(styleButton1_Button)
        
        styleButton2_Button = YLRectButton(y: CGFloat(0), title: "Blue", backgroundColor: UIColor.white, titleColor: AppDelegate.companyGrey_Color)
        styleButton2_Button.frame.size.width = AppDelegate.itemHeight*2
        styleButton2_Button.frame.origin.x = styleButton1_Button.frame.origin.x + styleButton1_Button.frame.size.width + AppDelegate.margin
        styleButton2_Button.addTarget(self, action: #selector(styleButton2_ButtonAction), for: .touchUpInside)
        stylePanel_View.addSubview(styleButton2_Button)
        
        styleButton3_Button = YLRectButton(y: CGFloat(0), title: "Green", backgroundColor: UIColor.white, titleColor: AppDelegate.companyGrey_Color)
        styleButton3_Button.frame.size.width = AppDelegate.itemHeight*2
        styleButton3_Button.frame.origin.x = styleButton2_Button.frame.origin.x + styleButton2_Button.frame.size.width + AppDelegate.margin
        styleButton3_Button.addTarget(self, action: #selector(styleButton3_ButtonAction), for: .touchUpInside)
        stylePanel_View.addSubview(styleButton3_Button)
        
    }
    
    @objc func styleButton1_ButtonAction(_ sender: AnyObject){
        if ThemeManager.currentTheme().rawValue != "Grey" {
            styleButton1_Button.backgroundColor = UIColor.white
            styleButton2_Button.backgroundColor = UIColor.lightGray
            styleButton3_Button.backgroundColor = UIColor.lightGray
            ThemeManager.applyTheme(theme: .Grey)
            reload()
            print("@ change style to Grey @")
        }
    }
    @objc func styleButton2_ButtonAction(_ sender: AnyObject){
        if ThemeManager.currentTheme().rawValue != "Blue" {
            styleButton1_Button.backgroundColor = UIColor.lightGray
            styleButton2_Button.backgroundColor = UIColor.white
            styleButton3_Button.backgroundColor = UIColor.lightGray
            ThemeManager.applyTheme(theme: .Blue)
            reload()
            print("@ change style to Blue @")
        }
    }
    
    @objc func styleButton3_ButtonAction(_ sender: AnyObject){
        if ThemeManager.currentTheme().rawValue != "Green" {
            styleButton1_Button.backgroundColor = UIColor.lightGray
            styleButton2_Button.backgroundColor = UIColor.lightGray
            styleButton3_Button.backgroundColor = UIColor.white
            ThemeManager.applyTheme(theme: .Green)
            reload()
            print("@ change style to Blue @")
        }
    }
    
    func setContent_Label(){
        let width = view.frame.size.width - AppDelegate.margin*2
        let height = stylePanel_View.frame.origin.y - AppDelegate.itemHeight - (companylogo_ImageView.frame.origin.y + companylogo_ImageView.frame.size.height + AppDelegate.itemHeight)
        let x = AppDelegate.margin
        let y = companylogo_ImageView.frame.origin.y + companylogo_ImageView.frame.size.height + AppDelegate.itemHeight
        let frame = CGRect(x:x, y:y, width: width, height: height)
        content_Label.frame = frame
        
        content_Label.text = "Cyberinc delivers enterprise scale solutions that help CISOs address the top two threat vectors of the digital age – information loss through web based malware threats and unauthorized access, with our flagship product offering, Isla Malware Isolation platform which ensures 100% web freedom and comprehensive IAM solutions that have secured over 100 million identities across the globe."
        content_Label.textColor = UIColor.white
        content_Label.font = AppDelegate.fontContent
        content_Label.textAlignment = .center
        content_Label.lineBreakMode = .byWordWrapping
        content_Label.numberOfLines = 10
        
        view.addSubview(content_Label)
        
    }
    
    func initStyleButtonBackgroundColor(){

        if ThemeManager.currentTheme().rawValue == "Grey" {
            styleButton1_Button.backgroundColor = UIColor.white
            styleButton2_Button.backgroundColor = UIColor.lightGray
            styleButton3_Button.backgroundColor = UIColor.lightGray
            print("@ stored style is grey @")
            
        } else if ThemeManager.currentTheme().rawValue == "Blue" {
            styleButton1_Button.backgroundColor = UIColor.lightGray
            styleButton2_Button.backgroundColor = UIColor.white
            styleButton3_Button.backgroundColor = UIColor.lightGray
            print("@ stored style is blue @")
            
        } else if ThemeManager.currentTheme().rawValue == "Green" {
            styleButton1_Button.backgroundColor = UIColor.lightGray
            styleButton2_Button.backgroundColor = UIColor.lightGray
            styleButton3_Button.backgroundColor = UIColor.white
            print("@ stored style is green @")

        } else {
            styleButton1_Button.backgroundColor = UIColor.white
            styleButton2_Button.backgroundColor = UIColor.lightGray
            styleButton3_Button.backgroundColor = UIColor.lightGray
            print("@ stored style is nil @")
        }
    }
    
    func reload(){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        setBackground()
        setPageTitle_View()
        setGoHome_Button()
        setCompanyLogo_ImageView()
        setStylePanel()
        initStyleButtonBackgroundColor()
        setContent_Label()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changedTheme"), object: self)
    }
    
}
