//
//  DIContainer.swift
//  Pushley
//
//  Created by Johnnie Cheng on 28/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

protocol Injectable {
    
    static func inject<T>(container: DIContainer) -> T?
    
}

class DIContainer: NSObject {

    static let shared = DIContainer()

    func injectAPNNetworker() -> APNNetworkerProtocol? {
        return APNNetworker.inject(container: self)
    }
    
    func injectPushNotificationRepository() -> PushNotificationRepositoryProtocol? {
        return PushNotificationRepository.inject(container: self)
    }
    
    func injectPushViewModel() -> PushViewModel? {
        return PushViewModel.inject(container: self)
    }
    
}
