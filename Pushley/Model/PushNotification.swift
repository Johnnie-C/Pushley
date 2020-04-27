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
    
}

enum PushType: String {

    case alert
    case background
    case voip
    
}

enum Priority: String {
    
    case normal = "1"
    case high = "5"
    
}

struct PushNotification {
    
    let title: String?
    let body: String?
    let environment: Environment
    let type: PushType
    let priority: Priority
    let sound: String?
    let badge: Int?
    let contentAvailable: Bool
    let extraData: [AnyHashable: Any]?

    init(title: String? = nil,
         body: String? = nil,
         environment: Environment,
         type: PushType = .alert,
         priority: Priority = .high,
         sound: String? = nil,
         badge: Int? = nil,
         contentAvailable: Bool = false,
         extraData: [AnyHashable: Any]? = nil)
    {
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

}
