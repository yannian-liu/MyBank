//
//  YLViewShadow.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/11.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class YLViewShadow {
    class func setViewControllerShadow(viewController: UIViewController){
        viewController.view.layer.shadowColor = UIColor.black.cgColor
        viewController.view.layer.shadowOffset =  CGSize.zero
        viewController.view.layer.shadowOpacity = 0.6
//        viewController.view.layer.shadowRadius = 5
    }
    
    class func setViewShadow(view:UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 0.3
    }
    
    class func setTableViewShadow (tableView: UITableView){
        //tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        tableView.layer.shadowOpacity = 0.3
    }
    
}
