//
//  APNNetworker.swift
//  Pushley
//
//  Created by Johnnie Cheng on 30/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Alamofire

class APNNetworker {

    private static let hostname = "https://api.sandbox.push.apple.com"
//    private static let hostname = "gateway.push.apple.com"
            
    private let sessionManager: Session?
    private var credential: URLCredential? = nil
    
    init(certificatePath: String?) {
        if let certificatePath = certificatePath {
            let data = try! Data(contentsOf: URL(fileURLWithPath: certificatePath))
            let password = ""
            let p12Cert = PKCS12(data: data, password: password)
            
            if let identity = p12Cert.identity,
                let certificate = p12Cert.certificate
            {
                credential = URLCredential(identity: identity, certificates: [certificate], persistence: .permanent)
            }
        }
        
        sessionManager = Session()
    }
    
    func post() {
        let url = "\(APNNetworker.hostname):2197/3/device/xxx"
        
        let parameters = ["aps": ["alert": "Hello"]]
        let request = sessionManager?.request(url,
                                              method: .post,
                                              parameters: parameters,
                                              encoding: JsonBodyStringEncoding(),
                                              headers: ["apns-push-type": "alert",
                                                        "apns-priority": "10"])
        
        if let credential = credential {
            request?.authenticate(with: credential)
        }
        
        request?.response { response in
            if let data = response.data {
                let str = String(decoding: data, as: UTF8.self)
                print("Data: \(str)")
            }
            
            print("Request: \(response.request)")
            print("Response: \(response)")
            print("Request headers: \(response.response?.allHeaderFields)")
            print("Response code: \(response.response?.statusCode)")
        }
    }
    
}
