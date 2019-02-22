//
//  YLPhoneCarrier.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/3.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
import CoreTelephony.CTTelephonyNetworkInfo

class YLPhoneCarrier {
    class func getPhoneCarrierName() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        var carrierName_String = ""
        if carrier?.carrierName != nil {
            carrierName_String = (carrier?.carrierName)!
        }
        return carrierName_String
    }
}
