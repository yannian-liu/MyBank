//
//  YLServerConnectionStatusCode.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/5.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation

class YLServerConnectionStatusCode{
    class func getDescription(statusCode: Int)->String{
        var description = ""
        switch statusCode {
        case 401:
            description = "Unauthorized! Please try correct username and password."
        case 402:
            description = "Unauthorized"
        case 403:
            description = "Forbidden"
        case 404:
            description = "Not Found"
        case 405:
            description = "Method Not Allowed"
        case 406:
            description = "Not Acceptable"
        case 407:
            description = "Proxy Authentication Required"
        case 408:
            description = "Request Timeout"
        case 409:
            description = "?"
        case 410:
            description = "?"
        case 411:
            description = "?"
        case 412:
            description = "?"
        case 413:
            description = "?"
        case 414:
            description = "?"
        case 415:
            description = "?"
        case 416:
            description = "?"
        case 417:
            description = "?"
        case 418:
            description = "?"
        case 421:
            description = "?"
        case 422:
            description = "?"
        case 423:
            description = "?"
        case 424:
            description = "?"
        case 426:
            description = "?"
        case 428:
            description = "?"
        case 429:
            description = "?"
        case 431:
            description = "?"
        case 451:
            description = "?"
        default:
            description = "unknown"
        }
        
        return description
    }
}
