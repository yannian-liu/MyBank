//
//  Shake.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/7.
//  Copyright © 2017年 yannian liu. All rights reserved.
//


import UIKit
import Foundation

class YLShake {
    
    func shake (object: UIView, completionBock: @escaping () -> Void){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completionBock()
        })
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        let fromPointSU:CGPoint = CGPoint(x: object.center.x - 5, y: object.center.y)
        let toPointSU:CGPoint = CGPoint(x: object.center.x + 5, y: object.center.y)
        animation.fromValue = NSValue(cgPoint:fromPointSU)
        animation.toValue = NSValue(cgPoint:toPointSU)
        object.layer.add(animation, forKey: "position")
        
        CATransaction.commit()
    }
    
    
    func shakeTwo (object1: UIView, object2: UIView, completionBock: @escaping () -> Void){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completionBock()
        })
        
        let animation1 = CABasicAnimation(keyPath: "position")
        animation1.duration = 0.07
        animation1.repeatCount = 4
        animation1.autoreverses = true
        let fromPointSU1:CGPoint = CGPoint(x: object1.center.x - 5, y: object1.center.y)
        let toPointSU1:CGPoint = CGPoint(x: object1.center.x + 5, y: object1.center.y)
        animation1.fromValue = NSValue(cgPoint:fromPointSU1)
        animation1.toValue = NSValue(cgPoint:toPointSU1)
        object1.layer.add(animation1, forKey: "position")
        
        // shake the password_Textfield //
        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.duration = 0.07
        animation2.repeatCount = 4
        animation2.autoreverses = true
        let fromPointSP2:CGPoint = CGPoint(x: object2.center.x - 5, y: object2.center.y)
        let toPointSP2:CGPoint = CGPoint(x: object2.center.x + 5, y: object2.center.y)
        animation2.fromValue = NSValue(cgPoint:fromPointSP2)
        animation2.toValue = NSValue(cgPoint:toPointSP2)
        object2.layer.add(animation2, forKey: "position")
        
        CATransaction.commit()
        
    }
}
