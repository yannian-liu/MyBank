//
//  YLTableView.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/11.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
class YLTableViewForUserProfile: UITableView {
    init(y:CGFloat, height:CGFloat){
        let width = UIScreen.main.bounds.width - AppDelegate.margin*2
        let x = AppDelegate.margin
        let frame = CGRect(x:x, y:y, width:width, height:height)
        super.init(frame: frame, style: .plain)
        //设置重用ID
        
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerCell")
        
        self.estimatedRowHeight = CGFloat(80)
        self.rowHeight = AppDelegate.itemHeight
        self.sectionHeaderHeight = AppDelegate.itemHeight

        //devices_TableView.rowHeight = UITableViewAutomaticDimension
        
        //devices_TableView.isHidden = true
        
        self.allowsSelection = false
        //self.layer.cornerRadius = 3
        //self.layer.masksToBounds = true
        self.isScrollEnabled = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
