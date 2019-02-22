//
//  MenuButton.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/18.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class YLMenuButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        //self.backgroundColor = UIColor.clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0;
        self.setTitle("Menu", for: .normal)
        self.setTitleColor(AppDelegate.companyRed_Color, for: .normal)
        
        let menuClose = UIImage(named: "menuClose")
        self.setImage(menuClose, for: .normal)
        self.addTarget(self.superview, action: #selector(YLMenuButton.menu_ButtonAction(_:)), for:.touchDown)

    }
    @objc func menu_ButtonAction(_ sender: AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menu_ButtonTapped"), object: self)
    }
    
}
