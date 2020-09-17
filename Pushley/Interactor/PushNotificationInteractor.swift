//
//  PushNotificationInteractor.swift
//  Pushley
//
//  Created by Johnnie Cheng on 28/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Cocoa

protocol PushNotificationInteractorProtocol {
    
    func updateCertificate(_ certificate: Certificate)
    func sendNotification(notification: PushNotification,
                          completion: @escaping (Error?) -> Void)
    
    func cacheNotification(_ notification: PushNotification)
    func loadCachedNotification() -> PushNotification?
    
}

class PushNotificationInteractor: PushNotificationInteractorProtocol {
    
    private static let lastNotificationKey = "lastNotification"
    
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
        let url = "\(notification.environment.host)/3/device/\(notification.deviceToken)"
        var headers = ["apns-push-type": notification.type.rawValue,
                       "apns-priority": notification.type.defaultPriority.rawValue]
        if !notification.topic.isEmpty {
            headers["apns-topic"] = notification.topic
        }
        
        netWorker.post(url: url,
                       parameters: notification.toDictionary,
                       headers: headers)
        { response in
            if let data = response.data,
                let apnResponse = try? ApnResponse.decoded(data: data)
            {
                let error = NSError(domain: "",
                                    code: response.error?.responseCode ?? -999,
                                    userInfo: [NSLocalizedDescriptionKey: apnResponse.reason ?? "Unknown"])
                completion(error)
            }
            else {
                completion(response.error)
            }
        }
    }
    
    func cacheNotification(_ notification: PushNotification) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(notification) {
            UserDefaults.standard.set(data, forKey: PushNotificationInteractor.lastNotificationKey)
        }
    }
    
    func loadCachedNotification() -> PushNotification? {
        if let data = UserDefaults.standard.data(forKey: PushNotificationInteractor.lastNotificationKey) {
            return try? PushNotification.decoded(data: data)
        }
        return nil
    }
    
}

extension PushNotificationInteractor: Injectable {
    
    static func inject<T>(container: DIContainer) -> T {
        let networker = container.injectAPNNetworker()
        return PushNotificationInteractor(netWorker: networker) as! T
    }
    
}
