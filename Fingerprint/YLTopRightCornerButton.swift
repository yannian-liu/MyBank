//
//  YLTopRightCornerButton.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/10.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

import UIKit
class YLTopRightCornerButton: UIButton {
    init(title: String) {
        let width = CGFloat(100)
        let height = AppDelegate.itemHeight
        let x = UIScreen.main.bounds.width - width - AppDelegate.margin
        let y = AppDelegate.margin*2
        let frame = CGRect(x:x, y:y, width:width, height:height)
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 3
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = AppDelegate.fontContent
        self.titleLabel?.textAlignment = .right
        
        
        let image = UIImage(named: "forward")
        self.setImage(image, for: .normal)
        self.titleEdgeInsets.right = CGFloat(0)
        //self.imageEdgeInsets.right = CGFloat(10)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
    }
    
}
