//
//  YLPageTitleView.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/10.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class YLPageTitleView: UIView {
    
    var pageTitle_Label = UILabel()
    
    init(title: String){
        let width = UIScreen.main.bounds.width
        let height = CGFloat(70)
        let frame = CGRect(x:0,y:0,width:width,height:height)
        super.init(frame:frame)
        self.backgroundColor = AppDelegate.companyGrey_Color
        setTitleL_Label(title:title)
        

    }
    
    func setTitleL_Label(title:String){
        let width = UIScreen.main.bounds.width
        let height = AppDelegate.itemHeight
        let x = CGFloat(0)
        let y = AppDelegate.margin*2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        pageTitle_Label.frame = frame
        pageTitle_Label.text = title
        pageTitle_Label.textColor = UIColor.white
        pageTitle_Label.font = AppDelegate.fontForPageTitle
        pageTitle_Label.textAlignment = .center
        self.addSubview(pageTitle_Label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
