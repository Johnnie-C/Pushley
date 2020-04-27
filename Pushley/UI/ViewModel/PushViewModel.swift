//
//  PushViewModel.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI
import Alamofire
import Combine

protocol PushViewModelProtocol: ObservableObject {
    
    var certificate: Certificate? { get }
    func test()
    
}

class PushViewModel: PushViewModelProtocol {
    
    @Published var certificate: Certificate?
    private var networker: APNNetworker?
    
    func showCertificatePicker() {
        let pickerBuilder = FilePickerBuilder.defaultSingleFilePicker()
        pickerBuilder.allowedFileTypes = ["p12"]
        
        if let pickedFileUrl = FilePicker.pick(builder: pickerBuilder)?.first,
            let password = Dialog.getInputText(title: "Password:", needSecure: true)
        {
            let data = try! Data(contentsOf: pickedFileUrl)
            let certificate = Certificate(data: data, password: password)
            if certificate.isValid {
                self.certificate = certificate
            }
            else {
                Dialog.showSimpleAlert(title: "Wrong Password")
            }
        }
    }
    
    func test() {
        networker?.post()
    }

}
