//
//  YLActivityIndicatorAnimationDelegate.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/1.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

protocol YLActivityIndicatorAnimationDelegate {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}
