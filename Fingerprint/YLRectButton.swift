//
//  YLRectButton.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/9.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class YLRectButton:UIButton {
    
    init(y: CGFloat, title: String, backgroundColor: UIColor, titleColor:UIColor) {
        let width = UIScreen.main.bounds.width - AppDelegate.margin*2
        let height = AppDelegate.itemHeight
        let x = AppDelegate.margin
        let frame = CGRect(x:x, y:y, width:width, height:height)
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 3
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = AppDelegate.fontContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
