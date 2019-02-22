//
//  YLNetworkType.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/3.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import CoreTelephony
import SystemConfiguration

public class YLNetworkType {
    
    class func getNetworkType()->String {
        do{
            //let reachability2:Reachability = try Reachability.reachabilityForInternetConnection()
            let reachability:Reachability = try Reachability.init()!
            do{
                //try reachability.startNotifier()
                let status = reachability.currentReachabilityStatus
                if(status == .notReachable){
                    return ""
                }else if (status == .reachableViaWiFi){
                    return "Wifi"
                }else if (status == .reachableViaWWAN){
                    let networkInfo = CTTelephonyNetworkInfo()
                    let carrierType = networkInfo.currentRadioAccessTechnology
                    switch carrierType{
                    case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?: return "2G"
                    case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?: return "3G"
                    case CTRadioAccessTechnologyLTE?: return "4G"
                    default: return ""
                    }
                    
                    // Get carrier name
                    
                }else{
                    return ""
                }
            }catch{
                return ""
            }
            
        }catch{
            return ""
        }
        
        
    }
}
