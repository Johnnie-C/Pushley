//
//  PushNotificationRepository.swift
//  Pushley
//
//  Created by Johnnie Cheng on 28/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

protocol PushNotificationRepositoryProtocol {
    
    func updateCertificate(_ certificate: Certificate)
    func sendNotification(notification: PushNotification,
                          completion: @escaping (Error?) -> Void)
    
}

class PushNotificationRepository: PushNotificationRepositoryProtocol {
    
    private let netWorker: APNNetworkerProtocol
    
    init(netWorker: APNNetworkerProtocol) {
        self.netWorker = netWorker
    }
    
    func updateCertificate(_ certificate: Certificate) {
        netWorker.updateCertificate(certificate)
    }
    
    func sendNotification(notification: PushNotification,
                          completion: @escaping (Error?) -> Void)
    {
        let url = "\(notification.environment.host)/3/device/\(notification.targetToken)"
        let headers = ["apns-push-type": notification.type.rawValue,
                       "apns-priority": notification.type.defaultPriority.rawValue]
        netWorker.post(url: url,
                       parameters: notification.toDictionary,
                       headers: headers)
        { response  in
            if let data = response.data {
                let str = String(decoding: data, as: UTF8.self)
                print("Data: \(str)")
            }
            completion(response.error)
            print("Request: \(response.request)")
            print("Response: \(response)")
            print("Request headers: \(response.response?.allHeaderFields)")
            print("Response code: \(response.response?.statusCode)")
        }
    }
    
}

extension PushNotificationRepository: Injectable {
    
    static func inject<T>(container: DIContainer) -> T? {
        let networker = container.injectAPNNetworker()!
        return PushNotificationRepository(netWorker: networker) as? T
    }
    
}
