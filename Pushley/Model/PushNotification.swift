//
//  PushNotification.swift
//  Pushley
//
//  Created by Johnnie Cheng on 27/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

enum Environment: String {
    
    case production
    case sandbox
    
    var host: String {
        switch self {
        case .production:
            return "https://gateway.push.apple.com:443"
        case .sandbox:
            return "https://api.sandbox.push.apple.com:443"
        }
    }
    
}

enum PushType: String {
    
    case alert
    case background
    case voip
    
    var defaultPriority: Priority {
        switch self {
        case .alert:
            return Priority.high
        case .background:
            return Priority.normal
        case .voip:
            return Priority.high
        }
    }
    
    var defaultContentAvailable: Bool {
        switch self {
        case .alert:
            return false
        case .background:
            return true
        case .voip:
            return false
        }
    }
    
}

enum Priority: String {
    
    case normal = "5"
    case high = "10"
    
}

struct PushNotification {
    
    let targetToken: String
    let title: String?
    let body: String?
    let environment: Environment
    let type: PushType
    let priority: Priority
    let sound: String?
    let badge: Int?
    let contentAvailable: Bool
    let extraData: [String: Any]?
    
    init(targetToken: String,
         title: String? = nil,
         body: String? = nil,
         environment: Environment,
         type: PushType = .alert,
         priority: Priority = .high,
         sound: String? = nil,
         badge: Int? = nil,
         contentAvailable: Bool = false,
         extraData: [String: Any]? = nil)
    {
        self.targetToken = targetToken
        self.title = title
        self.body = body
        self.environment = environment
        self.type = type
        self.priority = priority
        self.sound = sound
        self.badge = badge
        self.contentAvailable = contentAvailable
        self.extraData = extraData
    }
    
    var toDictionary: [String: Any] {
        var aps = [String: Any]()
        
        if type != .background {
            var alert = [String: Any]()
            if let title = title {
                alert["title"] = title
            }
            if let body = body {
                alert["body"] = body
            }
            aps["alert"] = alert
        }
        
        if let sound = sound {
            aps["sound"] = sound
        }
        if let badge = badge {
            aps["badge"] = badge
        }
        if type.defaultContentAvailable {
            aps["content-available"] = 1
        }
        
        var root: [String: Any] = ["aps": aps]
        
        if let extraData = extraData {
            extraData.forEach {
                root[$0] = $1
            }
       }
        
        return root
    }
    
}
