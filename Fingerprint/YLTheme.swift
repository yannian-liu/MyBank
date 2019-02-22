//
//  YLTheme.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/6/20.
//  Copyright © 2017年 yannian liu. All rights reserved.
//
import Foundation
import UIKit


enum Theme : String {
    case Default, Grey, Blue, Green
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red:29.0/255.0, green:31.0/255.0, blue:33.0/255.0, alpha: 1.0)
        case .Grey:
            return UIColor(red:29.0/255.0, green:31.0/255.0, blue:33.0/255.0, alpha: 1.0)
        case .Blue:
            return UIColor(red:35.0/255.0, green:83.0/255.0, blue:142.0/255.0, alpha: 1.0)
        case .Green:
            return UIColor(red:6.0/255.0, green:85.0/255.0, blue:70.0/255.0, alpha: 1.0)
        }
    }
    
}

struct ThemeManager {
    
    let SelectedThemeKey = "SelectedTheme"
    
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.string(forKey: "SelectedTheme") {
            if let a = Theme(rawValue: storedTheme) {
                return Theme(rawValue: storedTheme)!
            } else {
                return .Default
            }
        } else {
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
        // 1
        UserDefaults.standard.setValue(theme.rawValue, forKey: "SelectedTheme")
        UserDefaults.standard.synchronize()
        
        // 2
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        AppDelegate.companyGrey_Color = (sharedApplication.delegate?.window??.tintColor)!
    }
}
