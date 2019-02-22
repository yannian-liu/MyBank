//
//  parseStringToJson.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/12.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit


extension String
{
    var parseJSONString: AnyObject?
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                if let jsonResult = message as? NSMutableArray
                {
                    print(jsonResult)
                    
                    return jsonResult //Will return the json array output
                }
                else
                {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
