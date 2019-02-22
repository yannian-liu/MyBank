//
//  YLDefaultApi.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/6/9.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
class YLDefaultApi {
    static let login_Api_Default = "http://139.162.24.71:10010/api/v1/auth/regAuth"
    static let pinAuth_Api_Default = "http://139.162.24.71:10010/api/v1/auth/pinAuth"
    static let pinRegister_Api_Default = "http://139.162.24.71:10010/api/v1/auth/registerPin"
    static let userProfile_Api_Default = "http://139.162.24.71:10010/api/v1/auth/getUserAttrs"
    static let touchIDRegister_Api_Default = "http://139.162.24.71:10010/api/v1/auth/registerTouchId"
    static let touchIDAuth_Api_Default = "http://139.162.24.71:10010/api/v1/auth/touchIdAuth"
    static let getDevices_Api_Default = "http://139.162.24.71:10010/api/v1/auth/getDevices"
    static let deregisterDevice_Api_Default = "http://139.162.24.71:10010/api/v1/auth/deregisterDevice"
}
