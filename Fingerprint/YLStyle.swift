//
//  YLStyle.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/6/19.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit
class YLStyle{
    // MARK: ToDo Table Section Headers
    //static var main_Color = UIColor(red:29.0/255.0, green:31.0/255.0, blue:33.0/255.0, alpha: 1.0)
//    static var main_Color : UIColor = {
//        loadStyle()
//    }()
    static var main_Color : UIColor!
    static let availableThemes = ["Solid Blue", "Pretty Pink", "Zen Black", "Light Blue", "Dark Blue", "Dark Green", "Dark Orange"]

    
    // MARK: Blue Color Schemes
    static func styleGrey() -> UIColor{
        let grey:UIColor = UIColor(red:29.0/255.0, green:31.0/255.0, blue:33.0/255.0, alpha: 1.0)
        return grey
    }
    
    static func styleBlue() -> UIColor{
        return UIColor.blue
    }
    
    class func loadStyle(){
        print("= loadStyle =")
        if let styleName = UserDefaults.standard.string(forKey: "styleDefault"){
            // Select the Theme
            if styleName == "Grey" {
                print("@ loadStyle grey @")
                main_Color = styleGrey()
            } else if styleName == "Blue" {
                print("@ loadStyle blue @")
                main_Color = styleBlue()
            } else {
                print ("@ styleDefault has not defined @")
                UserDefaults.standard.set("Grey", forKey: "styleDefault")
                print("@ set styleDefault as Grey")
                main_Color = styleGrey()
            }
        }
//        print("some thing wrong?")
//        main_Color = UIColor.purple
    }
    
    
}
