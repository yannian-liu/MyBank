//
//  YLShowViewWithAnimation.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/11.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLShowViewWithAnimation {
    class func show(view:UIView){
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 1
            //view.layoutIfNeeded()
        }, completion: nil)
    }
}
