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
    var certificateType: CertificateType { get set }
    var keyID: String { get set }
    var issuerID: String { get set }
    var environment: Environment { get set }
    var pushType: PushType { get set }
    var contentAvailable: Bool { get set }
    var mutableContent: Bool { get set }
    var topic: String { get set }
    var notificationTitle: String { get set }
    var notificationBody: String { get set }
    var deviceToken: String { get set }
    var extraDataJson: String { get set }
    var log: String { get set }
    
    func showCertificatePicker()
    func formatExtraDataJson()
    func clearLog()
    func resetIfNeeded()
    func send()
    
}

class PushViewModel: PushViewModelProtocol {
    
    private let pushNotificationInteractor: PushNotificationInteractorProtocol
    
    @Published var certificateType: CertificateType = .p12
    @Published var certificate: Certificate?
    @Published var keyID: String = ""
    @Published var issuerID: String = ""
    @Published var environment = Environment.sandbox
    @Published var pushType = PushType.alert
    @Published var topic = ""
    @Published var contentAvailable = false
    @Published var mutableContent = false
    @Published var notificationTitle = ""
    @Published var notificationBody = ""
    @Published var deviceToken = ""
    @Published var extraDataJson = ""
    @Published var log = ""
    
    init(pushNotificationInteractor: PushNotificationInteractorProtocol = PushNotificationInteractor()) {
        self.pushNotificationInteractor = pushNotificationInteractor
        loadCachedNotification()
    }
    
    func loadCachedNotification() {
        if let notification = pushNotificationInteractor.loadCachedNotification() {
            environment = notification.environment
            pushType = notification.type
            notificationTitle = notification.title ?? ""
            notificationBody = notification.body ?? ""
            deviceToken = notification.deviceToken
            topic = notification.topic
            extraDataJson = notification.extraData?.jsonString(sortedByKey: true, prettyFormat: true) ?? ""
        }
    }
    
    func showCertificatePicker() {
        let pickerBuilder = FilePickerBuilder.defaultSingleFilePicker()
        pickerBuilder.allowedFileTypes = certificateType == .p12 ? ["p12"] : ["p8"]
        
        if let pickedFileUrl = FilePicker.pick(builder: pickerBuilder)?.first {
            if certificateType == .p12 {
                processP12Certificate(url: pickedFileUrl)
            } else if certificateType == .p8 {
                processP8Certificate(url: pickedFileUrl)
            }
        }
    }
    
    private func processP12Certificate(url: URL) {
        self.log("Loading certificate...from \(url)")
        if let password = Dialog.getInputText(title: "Password:", needSecure: true) {
            let data = try! Data(contentsOf: url)
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
    
    private func processP8Certificate(url: URL) {
        self.log("Loading private key...from \(url)")
    }
    
    func formatExtraDataJson() {
        guard let prettyJson = extraDataJson.dictionaryValue?.jsonString(sortedByKey: true, prettyFormat: true),
            !prettyJson.isEmpty else
        {
            return
        }

        extraDataJson = prettyJson
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
            extraDataJson = ""
            log = ""
        }
    }
    
    func send() {
        let notification = PushNotification(
            deviceToken: deviceToken,
            topic: topic,
            title: notificationTitle,
            body: notificationBody,
            environment: environment,
            type: pushType,
            priority: pushType.defaultPriority,
            sound: nil,
            badge: nil,
            contentAvailable: contentAvailable,
            mutableContent: mutableContent,
            extraData: extraDataJson.dictionaryValue
        )
        pushNotificationInteractor.cacheNotification(notification)
        
        guard certificate?.isValid ?? false else {
            self.log("Failed to push -- Invalid certificate")
            return
        }
        
        log("""
            sending notification:
            =======================
            \(notification.toDictionary.jsonString(sortedByKey: true, prettyFormat: true))
            =======================
            """)
        
        pushNotificationInteractor.sendNotification(notification: notification) { error in
            let result = error == nil ? "Notification send success!\n"
                : "Notification send failed! error: \(error!.localizedDescription)\n"
            self.log(result)
        }
    }
    
    private func log(_ log: String) {
        self.log.append("\(self.log.isEmpty ? "" : "\n")\(Date().timeOnlyString): \(log)")
    }

}
