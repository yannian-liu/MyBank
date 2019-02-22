//
//  YLTableViewForWelcome.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/11.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLTableViewForWelcome: UITableView {
    init(y:CGFloat, height:CGFloat){
        let width = UIScreen.main.bounds.width - AppDelegate.margin*2
        let x = AppDelegate.margin
        let frame = CGRect(x:x, y:y, width:width, height:height)
        super.init(frame: frame, style: .plain)
        //设置重用ID
        
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerCell")
        
        self.estimatedRowHeight = AppDelegate.itemHeight*1.5
        self.rowHeight = AppDelegate.itemHeight*1.5
        self.sectionHeaderHeight = AppDelegate.itemHeight*1.5
        
        //devices_TableView.rowHeight = UITableViewAutomaticDimension
        
        //devices_TableView.isHidden = true
        
        self.allowsSelection = false
        //self.layer.cornerRadius = 3
        self.layer.masksToBounds = false
        self.isScrollEnabled = false
//        self.layer.borderWidth = 0.7
//        self.layer.borderColor = AppDelegate.companyRed_Color.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
