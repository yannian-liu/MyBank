//
//  YLCheckmarkAnimation.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/9.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLCheckmarkAnimation: UIView {
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        let imageCheckMark = UIImage(named:"checkmark")
        let imageView = UIImageView(image: imageCheckMark)
        let imageWidth = self.frame.size.width*2/3
        let imageHeight = imageWidth
        let imageX = (self.frame.size.width-imageWidth)/2
        let imageY = (self.frame.size.height - imageHeight)/2
        let imageFrame = CGRect(x:imageX, y:imageY, width: imageWidth, height:imageHeight)
        imageView.frame = imageFrame
        self.addSubview(imageView)
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 3.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }


}
