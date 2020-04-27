//
//  DateExtension.swift
//  Pushley
//
//  Created by Johnnie Cheng on 27/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Foundation

extension Date {
    
    var timeOnlyString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.string(from: self)
    }

}
