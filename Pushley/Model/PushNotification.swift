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
    
    init(environment: String?) {
        if environment == Environment.production.rawValue {
            self = .production
        }
        else if environment == Environment.sandbox.rawValue {
            self = .sandbox
        }
        else {
            self = .sandbox
        }
    }
    
    var host: String {
        switch self {
        case .production:
            return "https://api.push.apple.com:443"
        case .sandbox:
            return "https://api.sandbox.push.apple.com:443"
        }
    }
    
}

enum PushType: String {
    
    case alert
    case background
    case voip
    
    init(pushType: String?) {
        if pushType == PushType.alert.rawValue {
            self = .alert
        }
        else if pushType == PushType.background.rawValue {
            self = .background
        }
        else if pushType == PushType.voip.rawValue {
            self = .voip
        }
        else {
            self = .alert
        }
    }
    
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
    
    init(priority: String?) {
        if priority == Priority.normal.rawValue {
            self = .normal
        }
        else if priority == Priority.high.rawValue {
            self = .high
        }
        else {
            self = .high
        }
    }
    
}

struct PushNotification: Codable {
    
    let deviceToken: String
    let title: String?
    let body: String?
    let environment: Environment
    let type: PushType
    let priority: Priority
    let sound: String?
    let badge: Int?
    let contentAvailable: Bool
    let mutableContent: Bool
    let extraData: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case deviceToken
        case title
        case body
        case environment
        case type
        case priority
        case sound
        case badge
        case contentAvailable
        case mutableContent
        case extraData
    }
    
    init(from decoder: Decoder) throws {
        let keys = try decoder.container(keyedBy: CodingKeys.self)
        deviceToken = try keys.decodeIfPresent(.deviceToken) ?? ""
        title = try keys.decodeIfPresent(.title)
        body = try keys.decodeIfPresent(.body)
        
        let environmentString = try keys.decodeIfPresent(.environment, as: String.self)
        environment = Environment(environment: environmentString)
        
        let typeString = try keys.decodeIfPresent(.type, as: String.self)
        type = PushType(pushType: typeString)
        
        let priorityString = try keys.decodeIfPresent(.priority, as: String.self)
        priority = Priority(priority: priorityString)
        
        sound = try keys.decodeIfPresent(.sound)
        badge = try keys.decodeIfPresent(.badge)
        contentAvailable = try keys.decodeIfPresent(.contentAvailable) ?? false
        mutableContent = try keys.decodeIfPresent(.mutableContent) ?? false
        
        if let extraDataRawData = try keys.decodeIfPresent(.extraData, as: Data.self) {
            extraData = try? JSONSerialization.jsonObject(with: extraDataRawData) as? [String: Any]
        }
        else {
            extraData = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceToken, forKey: .deviceToken)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encode(environment.rawValue, forKey: .environment)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(priority.rawValue, forKey: .priority)
        try container.encode(sound, forKey: .sound)
        try container.encode(badge, forKey: .badge)
        try container.encode(contentAvailable, forKey: .contentAvailable)
        try container.encode(mutableContent, forKey: .mutableContent)
        
        if let extraData = extraData {
            let extraDataRawData = try? JSONSerialization.data(withJSONObject: extraData, options: [])
            try container.encode(extraDataRawData, forKey: .extraData)
        }
    }
    
    init(deviceToken: String,
         title: String? = nil,
         body: String? = nil,
         environment: Environment,
         type: PushType = .alert,
         priority: Priority = .high,
         sound: String? = nil,
         badge: Int? = nil,
         contentAvailable: Bool = false,
         mutableContent: Bool = false,
         extraData: [String: Any]? = nil)
    {
        self.deviceToken = deviceToken
        self.title = title
        self.body = body
        self.environment = environment
        self.type = type
        self.priority = priority
        self.sound = sound
        self.badge = badge
        self.contentAvailable = contentAvailable
        self.mutableContent = mutableContent
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
        if type.defaultContentAvailable || contentAvailable {
            aps["content-available"] = 1
        }
        
        if mutableContent {
            aps["mutable-content"] = 1
        }
        
        var root: [String: Any] = ["aps": aps]
        if let extraData = extraData {
            root.merge(extraData) { current, _ in current }
        }

        return root
    }
    
}
