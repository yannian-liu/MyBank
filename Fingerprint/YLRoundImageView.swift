//
//  YLRoundImageView.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/10.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLRoundImageView: UIImageView {
    init(radius: CGFloat, x: CGFloat , y:CGFloat, imageName: String, backgroundColor:UIColor) {
        let image = UIImage(named: imageName)
        super.init(image: image)
        let frame = CGRect(x: x, y: y, width: radius*2, height: radius*2)
        self.frame = frame
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.borderColor = backgroundColor.cgColor
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
