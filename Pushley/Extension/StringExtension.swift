//
//  StringExtension.swift
//  Pushley
//
//  Created by Johnnie Cheng on 3/9/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

extension String {

    var dictionaryValue: [String: Any]? {
        var dict: [String: Any]? = nil
        if let jsonData = data(using: .utf8) {
            do {
                dict = (try JSONSerialization.jsonObject(with: jsonData, options: [])) as? [String : Any]
            }
            catch {
                print(error)
            }
        }
        
        return dict
    }
    
}
