//
//  DictionaryExtension.swift
//  Pushley
//
//  Created by Johnnie Cheng on 3/9/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

extension Dictionary {
    
    func jsonString(sortedByKey: Bool = false,
                    prettyFormat: Bool = false)
        -> String
    {
        var string = ""
        do {
            var options: JSONSerialization.WritingOptions = []
            if sortedByKey {
                options.insert(.sortedKeys)
            }
            if prettyFormat{
                options.insert(.prettyPrinted)
            }
            let data = try JSONSerialization.data(withJSONObject: self, options: options)
            string = String(data: data, encoding: .utf8) ?? ""
        }
        catch {
            
        }
        
        return string
    }

}
