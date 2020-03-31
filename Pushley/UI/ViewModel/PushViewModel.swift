//
//  PushViewModel.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI
import Alamofire

protocol PushViewModelProtocol {
    
    func test()
    
}

class PushViewModel: PushViewModelProtocol {
    
//    private let certificates = [
//      "www.yourwebsite.com":
//        PinnedCertificatesTrustEvaluator(certificates: [Certificates.certificate],
//                                         acceptSelfSignedCertificates: false,
//                                         performDefaultValidation: true,
//                                         validateHost: true)
//    ]
//
//    private let session: Session
//
//    init(allHostsMustBeEvaluated: Bool) {
//        let serverTrustPolicy = ServerTrustManager(
//            allHostsMustBeEvaluated: allHostsMustBeEvaluated,
//            evaluators: certificates
//        )
//
//        session = Session(serverTrustManager: serverTrustPolicy)
//    }
//
//    func request(_ convertible: URLRequestConvertible) -> DataRequest {
//      return session.request(convertible)
//    }

    private var networker: APNNetworker?
    func test() {
//        let hostname = "gateway.sandbox.push.apple.com"
////        let hostname = "gateway.push.apple.com"
//
//        if let filePath = Bundle.main.path(forResource: "cert", ofType: "p12") {
////            let certificate = Certificate(filePath: filePath)
//
//            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
//            let password = "W@reh0use"
//            let certificate = PKCS12(data: data, password: password)
//            print("asd")
//        }
        networker = APNNetworker(certificatePath: Bundle.main.path(forResource: "cert", ofType: "p12"))
        networker?.post()
    }

}

struct Certificate {
    
    private let certificate: SecCertificate?
    
    init(filePath: String) {
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        certificate = SecCertificateCreateWithData(kCFAllocatorDefault, data as CFData)
    }
    
}
