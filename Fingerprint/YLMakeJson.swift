//
//  YLMakeJson.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/3.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import UIKit


class YLMakeJson {
    class func makeJsonWithDeviceProfileAll() -> NSMutableDictionary {
        let deviceProfile_JsonObject = NSMutableDictionary()
        
        // hardwareId
        let hardwareId_String = UIDevice.current.identifierForVendor!.uuidString
        deviceProfile_JsonObject.setValue(hardwareId_String, forKey: "hardwareId")
        print(": hardwareId of this device : ", hardwareId_String)
        
        // isJailbroken
        let isJailbroken_String = String(YLJailbroken.isJailbroken())
        deviceProfile_JsonObject.setValue(isJailbroken_String, forKey: "jailbroken")
        
        //  Geolocation
        let Coordinate_String = YLGeolocation.sharedInstance.getCurrentGeolocation()
        deviceProfile_JsonObject.setValue(Coordinate_String, forKey: "geolocation")
        
        // networktype
        let networktype_String = YLNetworkType.getNetworkType()
        deviceProfile_JsonObject.setValue(networktype_String, forKey: "networktype")
        
        // vpnenabled : just leave it as false
        let vpnenabled_String = "false"
        deviceProfile_JsonObject.setValue(vpnenabled_String, forKey: "vpnenabled")
        
        // ostype
        let ostype_String = UIDevice.current.systemName
        deviceProfile_JsonObject.setValue(ostype_String, forKey: "ostype")
        
        // phonecarriername ??? if the device has no carrier, carrierName_String will be "" not nil.
        let carrierName_String = YLPhoneCarrier.getPhoneCarrierName()
        deviceProfile_JsonObject.setValue(carrierName_String, forKey: "phonecarriername")
        
        // locale
        let locale_String = YLLocale.getLocaleWithLanguageAndRegion()
        deviceProfile_JsonObject.setValue(locale_String, forKey: "locale")
        
        // osversion
        let osversion_String = UIDevice.current.systemVersion
        deviceProfile_JsonObject.setValue(osversion_String, forKey: "osversion")

        return deviceProfile_JsonObject
    }
}
