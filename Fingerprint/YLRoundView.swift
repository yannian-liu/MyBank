//
//  YLRoundView.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/10.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLRoundView: UIView {
    init(radius: CGFloat, x: CGFloat, y:CGFloat, backgroundColor:UIColor,borderColor: CGColor){
        let frame = CGRect(x: x, y: y, width: radius*2, height: radius*2)
        super.init(frame: frame)
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
