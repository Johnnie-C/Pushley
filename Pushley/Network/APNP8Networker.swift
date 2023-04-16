//
//  APNP8Networker.swift
//  Pushley
//
//  Created by Xiaojun Cheng on 17/04/23.
//  Copyright © 2023 Johnnie Cheng. All rights reserved.
//

import Alamofire

class APNP8Networker: APNNetworkerProtocol {

    private let sessionManager: Session?
    
    init() {
        sessionManager = Session()
    }
    
    func updateCertificate(_ certificate: Certificate) { }
    
    @discardableResult func post(
        url: String,
        parameters: Parameters?,
        headers: [String: String]?,
        completion: @escaping (AFDataResponse<Data?>) -> Void
    ) -> Request? {
        // TODO: 
        let request = sessionManager?.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JsonBodyStringEncoding(),
            headers: HTTPHeaders(headers ?? [String: String]())
        )
        
        
        request?.response(completionHandler: completion)
            .validate(statusCode: 200..<300)

        return request
    }

}
