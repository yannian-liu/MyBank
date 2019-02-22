//
//  RectangleTextField.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/19.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class YLTextField: UITextField {
    
    let passwordSecureImage_Png = UIImage(named: "passwordSecure")
    let passwordSecureNotImage_Png = UIImage(named:"passwordSecureNot")

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    init(y: CGFloat, placeholder:String, imageName: String, keyboardType: UIKeyboardType) {
        let width = UIScreen.main.bounds.size.width - CGFloat(AppDelegate.margin * 2)
        let height = AppDelegate.itemHeight
        let frame = CGRect(x: AppDelegate.margin, y: y, width: width, height: height)
        super.init(frame: frame)
    
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        self.layer.borderColor = AppDelegate.lightGrey_Color.cgColor
        self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textColor = UIColor.white
        self.font = AppDelegate.fontContent
        
        self.leftViewMode = UITextField.ViewMode.always
        let emailImage_View = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let emailImage_Png = UIImage(named: imageName)
        emailImage_View.image = emailImage_Png
        self.leftView = emailImage_View
        
    }
    
    func setRightViewModeWithSecureButton(){
        self.rightViewMode = UITextField.ViewMode.always
        let passwordSecure_Button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.rightView = passwordSecure_Button
        
        self.isSecureTextEntry = true
        passwordSecure_Button.setImage(passwordSecureImage_Png, for: .normal)
        passwordSecure_Button.addTarget(self, action: #selector(passwordSecure_ButtonAction), for: .touchDown)

    }
    
    
    @objc func passwordSecure_ButtonAction(_ sender: AnyObject) {

        if self.isSecureTextEntry{
            self.isSecureTextEntry = false
            let rightButton = self.rightView as! UIButton
            rightButton.setImage(passwordSecureNotImage_Png, for: .normal)
            self.rightView = rightButton
            
        }else{
            self.isSecureTextEntry = true;
            let rightButton_t = self.rightView as! UIButton
            rightButton_t.setImage(passwordSecureImage_Png, for: .normal)
            self.rightView = rightButton_t
        }
    }

}
