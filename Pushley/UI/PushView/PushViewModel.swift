//
//  PushViewModel.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Foundation
import Alamofire
import Combine

protocol PushViewModelProtocol: ObservableObject {
    
    var certificate: Certificate? { get set }
    var environment: Environment { get set }
    var pushType: PushType { get set }
    var notificationTitle: String { get set }
    var notificationBody: String { get set }
    var deviceToken: String { get set }
    var extraDataJSON: String { get set }
    var log: String { get set }
    
    func showCertificatePicker()
    func clearLog()
    func resetIfNeeded()
    func send()
    
}

class PushViewModel: PushViewModelProtocol {
    
    private let pushNotificationInteractor: PushNotificationInteractorProtocol
    private let pushViewRouter: PushViewRouterProtocol
    
    @Published var certificate: Certificate?
    @Published var environment = Environment.sandbox
    @Published var pushType = PushType.alert
    @Published var notificationTitle = ""
    @Published var notificationBody = ""
    @Published var deviceToken = ""
    @Published var extraDataJSON = ""
    @Published var log = ""
    
    init(pushNotificationInteractor: PushNotificationInteractorProtocol,
         pushViewRouter: PushViewRouterProtocol)
    {
        self.pushNotificationInteractor = pushNotificationInteractor
        self.pushViewRouter = pushViewRouter
        loadCachedNotification()
    }
    
    func loadCachedNotification() {
        if let notification = pushNotificationInteractor.loadCachedNotification() {
            environment = notification.environment
            pushType = notification.type
            notificationTitle = notification.title ?? ""
            notificationBody = notification.body ?? ""
            deviceToken = notification.deviceToken
        }
    }
    
    func showCertificatePicker() {
        let pickerBuilder = FilePickerBuilder.defaultSingleFilePicker()
        pickerBuilder.allowedFileTypes = ["p12"]
        
        if let pickedFileUrl = FilePicker.pick(builder: pickerBuilder)?.first {
            self.log("Loading certificate...from \(pickedFileUrl)")
            if let password = Dialog.getInputText(title: "Password:", needSecure: true) {
                let data = try! Data(contentsOf: pickedFileUrl)
                let certificate = Certificate(data: data, password: password)
                if certificate.isValid {
                    self.certificate = certificate
                    self.pushNotificationInteractor.updateCertificate(certificate)
                    self.log("Certificate loaded! -- \(self.certificate?.label ?? "")")
                }
                else {
                    Dialog.showSimpleAlert(title: "Wrong Password")
                    self.log("Failed load certificate!")
                }
            }
            else {
                self.log("Cancel loading certificate")
            }
        }
    }
    
    func clearLog() {
        log = ""
    }
    
    func resetIfNeeded() {
        if Dialog.showYesCancelAlert(title: "Reset notification and certificate?") {
            certificate = nil
            environment = Environment.sandbox
            pushType = PushType.alert
            notificationTitle = ""
            notificationBody = ""
            deviceToken = ""
            extraDataJSON = ""
            log = ""
        }
    }
    
    func send() {
        let notification = PushNotification(deviceToken: deviceToken,
                                            title: notificationTitle,
                                            body: notificationBody,
                                            environment: environment,
                                            type: pushType,
                                            priority: pushType.defaultPriority,
                                            sound: nil,
                                            badge: nil,
                                            contentAvailable: pushType.defaultContentAvailable,
                                            extraData: nil)
        pushNotificationInteractor.cacheNotification(notification)
        
        guard certificate?.isValid ?? false else {
            self.log("Failed to push -- Invalid certificate")
            return
        }
        
        pushNotificationInteractor.sendNotification(notification: notification) { error in
            let result = error == nil ? "Notification send success!" : error.debugDescription
            self.log(result)
        }
    }
    
    private func log(_ log: String) {
        self.log.append("\(self.log.isEmpty ? "" : "\n")\(Date().timeOnlyString): \(log)")
    }

}

extension PushViewModel: Injectable {
    
    static func inject<T>(container: DIContainer) -> T {
        let pushNotificationInteractor = container.injectPushNotificationInteractor()
        let pushViewRouter = container.injectPushViewRouter()
        
        return PushViewModel(pushNotificationInteractor: pushNotificationInteractor,
                             pushViewRouter: pushViewRouter) as! T
    }
    
}
