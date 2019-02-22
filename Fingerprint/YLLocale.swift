//
//  YLLocale.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/3.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit

class YLLocale {
    class func getLocaleWithLanguageAndRegion() -> String {
        let languageCode_String = Locale.current.languageCode
        let regionCode_String = Locale.current.regionCode
        let locale_String = languageCode_String!+"-"+regionCode_String!
        return locale_String
    }
}
