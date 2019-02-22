//
//  YLErrorLabel.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/10.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLErrorLabel: UILabel {
    init(y: CGFloat){
        let width = UIScreen.main.bounds.width-AppDelegate.margin*2
        let height = AppDelegate.itemHeight
        let x = AppDelegate.margin
        let frame = CGRect(x:x,y:y,width:width,height:height)
        super.init(frame: frame)
        self.textColor = AppDelegate.companyRed_Color
        //self.error_Label.backgroundColor = UIColor.white
        self.font = AppDelegate.fontTitle
        self.textAlignment = .center
        self.isHidden = true
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 2

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
