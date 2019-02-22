//
//  aaa.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/5.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class YLRoundButton:UIButton {
    
    init(y: CGFloat, title: String, backgroundColor: UIColor, borderColor: CGColor, titleColor: UIColor){
        let width = AppDelegate.itemHeight*1.7
        let height = width
        let x = (UIScreen.main.bounds.width - width)/2
        let frame = CGRect(x:x, y:y, width:width, height:height)
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = 0
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = width/2
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = AppDelegate.fontContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
