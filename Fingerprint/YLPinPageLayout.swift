//
//  PinPageLayout.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/12.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit


class YLPinPageLayout {
    let topColorWrong: UIColor = UIColor(red:224.0/255.0, green:102.0/255.0, blue: 102.0/255.0, alpha: 1)
    let bottomColorWrong: UIColor = UIColor(red: (234/255.0), green: (153/255.0), blue: (153/255.0), alpha: 1)
    
    func setInitialBackground(viewController: UIViewController,backgroundView : UIView){
        viewController.view.addSubview(backgroundView)
    }
    
    func setWrongBackground(viewController: UIViewController,wrongView: UIView){
        wrongView.frame = viewController.view.frame
        wrongView.backgroundColor = self.topColorWrong
        wrongView.alpha = 0.3
        wrongView.isHidden = true
        viewController.view.addSubview(wrongView)
    }
    
    
    func setNumberButton(viewController: UIViewController, keyboardPanel_View: UIView, keyboard_ButtonArray:[UIButton] ){

        // decide the keyboard size according to device (ipad or iphone)
        if viewController.view.frame.size.width <= 414 {
            let keyboardPanel_Width = viewController.view.frame.size.width - 80
            let keyboardPanel_Height = keyboardPanel_Width*4/3
            let keyboardPanel_Rect = CGRect(x: (viewController.view.frame.size.width - keyboardPanel_Width)/2,
                                            y: viewController.view.frame.size.height - keyboardPanel_Height - 20,
                                            width: keyboardPanel_Width, height: keyboardPanel_Height)
            keyboardPanel_View.frame = keyboardPanel_Rect
            
            
        } else {
            let keyboardPanel_Width = viewController.view.frame.size.width/2
            let keyboardPanel_Height = keyboardPanel_Width*4/3
            let keyboardPanel_Rect = CGRect(x: (viewController.view.frame.size.width - keyboardPanel_Width)/2,
                                            y: (viewController.view.frame.size.height - keyboardPanel_Height)/2,
                                            width: keyboardPanel_Width, height: keyboardPanel_Height)
            
            
            keyboardPanel_View.frame = keyboardPanel_Rect
        }
        
        viewController.view.addSubview(keyboardPanel_View)
        
        // decide button layout and function
        let n1_Png = UIImage(named: "n1")
        let n2_Png = UIImage(named: "n2")
        let n3_Png = UIImage(named: "n3")
        let n4_Png = UIImage(named: "n4")
        let n5_Png = UIImage(named: "n5")
        let n6_Png = UIImage(named: "n6")
        let n7_Png = UIImage(named: "n7")
        let n8_Png = UIImage(named: "n8")
        let n9_Png = UIImage(named: "n9")
        let fingerprint_Png = UIImage(named: "fingerprint")
        let n0_Png = UIImage(named: "n0")
        //let delete_Png = UIImage(named: "delete")
        
        let n1w_Png = UIImage(named: "n1w")
        let n2w_Png = UIImage(named: "n2w")
        let n3w_Png = UIImage(named: "n3w")
        let n4w_Png = UIImage(named: "n4w")
        let n5w_Png = UIImage(named: "n5w")
        let n6w_Png = UIImage(named: "n6w")
        let n7w_Png = UIImage(named: "n7w")
        let n8w_Png = UIImage(named: "n8w")
        let n9w_Png = UIImage(named: "n9w")
        let fingerprintw_Png = UIImage(named: "fingerprintw")
        let n0w_Png = UIImage(named: "n0w")
        //let deletew_Png = UIImage(named: "deletew")
        
        let keyboard_ImangeArray = [n1_Png, n2_Png, n3_Png, n4_Png, n5_Png, n6_Png, n7_Png, n8_Png,n9_Png,  fingerprint_Png, n0_Png, nil]
        let keyboard_ImangeWhiteArray = [n1w_Png, n2w_Png, n3w_Png, n4w_Png, n5w_Png, n6w_Png, n7w_Png, n8w_Png,n9w_Png,  fingerprintw_Png, n0w_Png, nil]
        
        let buttonCellWeight = keyboardPanel_View.bounds.width / 3.0
        let buttonCellHeight = keyboardPanel_View.bounds.height / 4.0
        
        let button_Rect = CGRect(x: 0, y: 0, width: buttonCellWeight, height: buttonCellHeight)
        
        for j in 0..<4 {
            for i in 0..<3 {
                let buttonCell_Rect = CGRect(x: buttonCellWeight * CGFloat(i),
                                             y: buttonCellHeight * CGFloat(j),
                                             width: buttonCellWeight, height: buttonCellHeight)
                let buttonCell_View = UIView()
                buttonCell_View.translatesAutoresizingMaskIntoConstraints = false
                buttonCell_View.frame = buttonCell_Rect
                //buttonCell_View.layer.borderWidth = 0.5
                buttonCell_View.layer.borderColor = UIColor.gray.cgColor
                keyboardPanel_View.addSubview(buttonCell_View)
                
                keyboard_ButtonArray[i + j*3].frame = button_Rect
                keyboard_ButtonArray[i + j*3].setImage(keyboard_ImangeArray[i + j*3], for: .normal)
                keyboard_ButtonArray[i + j*3].setImage(keyboard_ImangeWhiteArray[i + j*3], for: .highlighted)
                buttonCell_View.addSubview(keyboard_ButtonArray[i + j*3])
                
            }
            
        }
        
        keyboard_ButtonArray[11].setTitle("Delete", for: .normal)
        keyboard_ButtonArray[11].setTitleColor(UIColor.white, for: .normal)
        keyboard_ButtonArray[11].setTitleColor(UIColor.lightText, for: .highlighted)
        keyboard_ButtonArray[11].titleLabel?.font = AppDelegate.fontTitle
        
    }
    
    func setInitialPinArea(viewController: UIViewController,pinPanel_View: UIView,keyboardPanel_View:UIView, pin_ImageViewArray:[UIImageView],pinSmall_Png:UIImage){
        let pinWidth = CGFloat(60)
        let pinHeight = pinWidth
        
        let pinPanelWidth = pinWidth.multiplied(by: 4)
        let pinPanelHeight = pinHeight
        
        let pinPanel_Rect = CGRect(x: (viewController.view.frame.size.width - pinPanelWidth)/2, y: (keyboardPanel_View.frame.origin.y/2 ), width: pinPanelWidth, height: pinPanelHeight)
        pinPanel_View.frame = pinPanel_Rect
        viewController.view.addSubview(pinPanel_View)
        
        for i in 0...3 {
            pin_ImageViewArray[i].frame = CGRect(x: pinWidth * CGFloat(i), y: 0, width:pinWidth ,height:pinHeight)
            pin_ImageViewArray[i].image = pinSmall_Png
            pinPanel_View.addSubview(pin_ImageViewArray[i])
            
        }
    }
    
    
    func setInitialTitle_Label (viewController: UIViewController,title_Label:UILabel,pinPanel_View:UIView){
        
        title_Label.textColor = UIColor.white
        title_Label.font = AppDelegate.fontContent
        title_Label.textAlignment = .center
        
        let title_LabelWidth = viewController.view.frame.size.width
        let title_LabelHeight = CGFloat(30)
        
        let title_LabelRect = CGRect(x: viewController.view.frame.origin.x, y:pinPanel_View.frame.origin.y - title_LabelHeight, width: title_LabelWidth, height:title_LabelHeight)
        title_Label.frame = title_LabelRect
        viewController.view.addSubview(title_Label)
    }
    
    func setInitialHint_Label(viewController: UIViewController,hint_Label:UILabel,pinPanel_View:UIView){
        hint_Label.isHidden = false
        hint_Label.text = ""
        hint_Label.textColor = UIColor.white
        hint_Label.font = AppDelegate.fontHint
        hint_Label.textAlignment = .center
        
        let hint_LabelWidth = viewController.view.frame.size.width
        let hint_LabelHeight = CGFloat(30)
        let hint_LabelRect = CGRect(x: viewController.view.frame.origin.x, y:pinPanel_View.frame.origin.y + pinPanel_View.frame.size.height, width: hint_LabelWidth, height:hint_LabelHeight)
        hint_Label.frame = hint_LabelRect
        viewController.view.addSubview(hint_Label)
    }

}
