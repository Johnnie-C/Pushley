//
//  APNNetworker.swift
//  Pushley
//
//  Created by Johnnie Cheng on 30/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Alamofire

protocol APNNetworkerProtocol {
    
    func updateCertificate(_ certificate: Certificate)
    
    @discardableResult func post(url: String,
                                 parameters: Parameters?,
                                 headers: [String: String]?,
                                 completion: @escaping (AFDataResponse<Data?>) -> Void)
        -> Request?
    
}

class APNNetworker: APNNetworkerProtocol {

    private let sessionManager: Session?
    private var credential: URLCredential? = nil
    
    init() {
        sessionManager = Session()
    }
    
    func updateCertificate(_ certificate: Certificate) {
        if certificate.isValid,
            let identity = certificate.identity,
            let certificate = certificate.certificate
        {
            credential = URLCredential(identity: identity, certificates: [certificate], persistence: .permanent)
        }
    }
    
    @discardableResult func post(url: String,
                                 parameters: Parameters?,
                                 headers: [String: String]?,
                                 completion: @escaping (AFDataResponse<Data?>) -> Void)
        -> Request?
    {
        let request = sessionManager?.request(url,
                                              method: .post,
                                              parameters: parameters,
                                              encoding: JsonBodyStringEncoding(),
                                              headers: HTTPHeaders(headers ?? [String: String]()))

        if let credential = credential {
            request?.authenticate(with: credential)
        }

        request?.response(completionHandler: completion)

        return request
    }

}

extension APNNetworker: Injectable {
    
    static func inject<T>(container: DIContainer) -> T? {
        return APNNetworker() as? T
    }
    
}
