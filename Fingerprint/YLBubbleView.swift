//
//  YLBubbleView.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/5.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLBubbleView: UIView {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        let bubble_Image = UIImage(named:"bubble")
        let bubble_ImageView = UIImageView()
        
        let imageWidth = frame.size.width
        let imageHeight = frame.size.height
        let imageX = CGFloat(0)
        let imageY = CGFloat(0)
        let imageframe = CGRect(x:imageX,y:imageY,width:imageWidth,height:imageHeight)
        bubble_ImageView.frame = imageframe
        bubble_ImageView.image = bubble_Image
        self.addSubview(bubble_ImageView)
        
        let bubble_Label = UILabel()
        bubble_Label.text = "You can allow using touch ID in this menu."
        bubble_Label.numberOfLines = 0;
        bubble_Label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let bubble_LabelWidth = imageframe.size.width-30
        let bubble_LabelHeight = imageframe.size.height-20
        let bubble_LabelRect = CGRect(x:imageframe.origin.x+20, y:imageframe.origin.y+10, width:bubble_LabelWidth, height:bubble_LabelHeight)
        bubble_Label.frame = bubble_LabelRect
        bubble_Label.textColor = UIColor.white
        bubble_Label.font = AppDelegate.fontContent
        bubble_Label.textAlignment = .center
        self.addSubview(bubble_Label)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
