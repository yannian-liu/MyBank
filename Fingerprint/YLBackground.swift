//
//  YLBackground.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/9.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class YLBackground: UIImageView {
    
    init(imageName: String) {
        let image = UIImage(named: imageName)
        super.init(image: image)
        self.frame = UIScreen.main.bounds
    }
    
    convenience init(){
        self.init(imageName: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBlurEffect(){
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = UIScreen.main.bounds
        self.addSubview(blurView)
    }
}
