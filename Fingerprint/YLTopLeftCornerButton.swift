//
//  YLTopLeftCornerButton.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/10.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLTopLeftCornerButton: UIButton {
    init(title: String) {
        let width = CGFloat(100)
        let height = AppDelegate.itemHeight
        let x = AppDelegate.margin
        let y = AppDelegate.margin*2
        let frame = CGRect(x:x, y:y, width:width, height:height)
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 3
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = AppDelegate.fontContent
        self.titleLabel?.textAlignment = .left
        
        
        let image = UIImage(named: "back")
        self.setImage(image, for: .normal)
        self.titleEdgeInsets.left = CGFloat(0)
        //self.imageEdgeInsets.left = CGFloat(10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth / 2, bottom: 0, right: 0)
    }

}
