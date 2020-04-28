//
//  CodableExtensions.swift
//  Pushley
//
//  Created by Johnnie Cheng on 28/4/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Foundation

extension Decodable {
    
    static func decoded(dict: [AnyHashable: Any]) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        return try decoded(data: data)
    }
    
    static func decoded(data: Data) throws -> Self {
        let decodedData = try JSONDecoder().decode(Self.self, from: data)
        return decodedData
    }
    
}

extension Encodable {
    
    func asJson() -> [AnyHashable: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: try JSONEncoder().encode(self), options: []) as? [AnyHashable: Any]
        }
        catch {
            return nil
        }
    }
    
    func asData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [])
    }
    
}

extension KeyedDecodingContainer {
    
    public func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    public func decodeIfPresent<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

}
