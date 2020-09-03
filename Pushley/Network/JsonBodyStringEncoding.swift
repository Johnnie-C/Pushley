//
//  JsonBodyStringEncoding.swift
//  Pushley
//
//  Created by Johnnie Cheng on 31/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Foundation
import Alamofire

enum Errors: Error {
    
    case emptyURLRequest
    case encodingProblem
    
    var errorDescription: String? {
        switch self {
            case .emptyURLRequest: return "Empty url request"
            case .encodingProblem: return "parameter must be [String: String]"
        }
    }
    
}

struct JsonBodyStringEncoding: ParameterEncoding {

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        
        if let parameters = parameters {
            urlRequest.httpBody = parameters.jsonString().data(using: .utf8)
        }
        
        return urlRequest
    }
}

