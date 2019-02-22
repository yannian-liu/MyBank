//
//  NetworkType.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/21.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
import CoreTelephony.CTTelephonyNetworkInfo
import SystemConfiguration.CaptiveNetwork

enum NetworkReachable {
    case CanReachable
    case NotReachable
}

enum NetworkType {
    case WiFi
    case Unknown
    case Cellular2G
    case Cellular3G
    case Cellular4G
}

struct NetworkStatus {
    func getCurrentWifiInfo() -> (String, String) {
        if let interfaces = CNCopySupportedInterfaces() {
            let if0: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, 0)
            let interfaceName: CFString = unsafeBitCast(if0, to: CFString.self)
            let ssidNSDic = CNCopyCurrentNetworkInfo(interfaceName) as NSDictionary?
            var ssid = String()
            var bssid = String()
            if ssidNSDic != nil { // 未连接WiFi的情况会返回nil
                ssid =  ssidNSDic!["SSID"] as! String
                bssid = ssidNSDic!["BSSID"] as! String
                return (bssid, ssid)
            } else {
                return ("", "")
            }
        }
        return ("", "")
    }
     
     // 在调用该接口之前一定要用isNetworkReachable()来确保有网络连接
    func currentNetworkType() -> NetworkType {
        let networkType = CTTelephonyNetworkInfo().currentRadioAccessTechnology
        if networkType == nil { // 非蜂窝网络下会返回nil
            // 排除是WiFi还是无网络
            if isNetworkReachable() == .CanReachable { // 这下可以判断是Wifi了
                return .WiFi
            } else {
                assert(false, "要是仅仅判断有无网络的话就用isNetworkReachable()，该接口是判断网络类型的，你应该在确保有网络的情况下调用该接口")
                return .Unknown
            }
        } else {
            switch networkType! {
            case CTRadioAccessTechnologyGPRS:
                return .Cellular2G
            case CTRadioAccessTechnologyEdge:
                return .Cellular2G // 2.75G的EDGE网络
            case CTRadioAccessTechnologyWCDMA:
                return .Cellular3G
            case CTRadioAccessTechnologyHSDPA:
                return .Cellular3G // 3.5G网络
            case CTRadioAccessTechnologyHSUPA:
                return .Cellular3G // 3.5G网络
            case CTRadioAccessTechnologyCDMA1x:
                return .Cellular2G // CDMA2G网络
            case CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                 CTRadioAccessTechnologyCDMAEVDORevB:
                return .Cellular3G
            case CTRadioAccessTechnologyeHRPD:
                return .Cellular3G // 电信的怪胎，只能算3G
            case CTRadioAccessTechnologyLTE:
                return .Cellular4G
            default:
                return .Unknown
            }
            
        }
        
    }
 
    func isNetworkReachable() -> NetworkReachable {
        var isCellularReachable = false // wifi 是否连接了
        let networkType = CTTelephonyNetworkInfo().currentRadioAccessTechnology
        if networkType == nil { // 非蜂窝网络下会返回nil
            isCellularReachable = false
        } else {
            isCellularReachable = true
        }
        
        /*
         
         * there are total three condition
         
         * 1.not reachable, 2.cellular, 3.wifi
         
         */
        
        var isWifiReachable = false // wifi 是否连接了
        if let interfaces = CNCopySupportedInterfaces() {
            let if0: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, 0)
            let interfaceName: CFString = unsafeBitCast(if0, to: CFString.self)
            
            let ssidNSDic = CNCopyCurrentNetworkInfo(interfaceName) as NSDictionary?
            
            if ssidNSDic == nil {
                
                isWifiReachable = false
                
            } else {
                
                isWifiReachable = true
                
            }
            
        }

        if isCellularReachable == false && isWifiReachable == false { // 非蜂窝网络下会返回nil && 未连接WiFi的情况会返回nil
            return .NotReachable
        } else {
            return .CanReachable
        }
        
    }
    
    var reachable: NetworkReachable {
        get {
            return isNetworkReachable()
        }
        
    }
    
    var networkType: NetworkType {
        get {
            return currentNetworkType()
            
        }
        
    }
    
    
    
}

