//
//  Certificate.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import Foundation

class Certificate  {
    
    var label: String
    var keyID: Data?
    var trust: SecTrust?
    var certChain: [SecTrust]?
    var identity: SecIdentity?
    let securityError: OSStatus
    var isValid: Bool { securityError == errSecSuccess }

    init(data: Data, password: String) {
        self.label = ""
        var items:CFArray?
        let certOptions:NSDictionary = [kSecImportExportPassphrase as NSString:password as NSString]

        // import certificate to read its entries
        self.securityError = SecPKCS12Import(data as NSData, certOptions, &items)
        
        if securityError == errSecSuccess {
            let certItems:Array = (items! as Array)
            let dict:Dictionary<String, AnyObject> = certItems.first! as! Dictionary<String, AnyObject>

            self.label = (dict[kSecImportItemLabel as String] as? String) ?? ""
            self.keyID = dict[kSecImportItemKeyID as String] as? Data
            self.trust = dict[kSecImportItemTrust as String] as! SecTrust?
            self.certChain = dict[kSecImportItemCertChain as String] as? [SecTrust]
            self.identity = dict[kSecImportItemIdentity as String] as! SecIdentity?
        }
    }

    public convenience init(mainBundleResource: String, resourceType: String, password: String) {
        self.init(data: NSData(contentsOfFile: Bundle.main.path(forResource: mainBundleResource, ofType:resourceType)!)! as Data, password: password)
    }

    public func urlCredential()  -> URLCredential  {
        return URLCredential(
            identity: self.identity!,
            certificates: self.certChain!,
            persistence: URLCredential.Persistence.forSession)

    }
    
    var certificate: SecCertificate? {
        guard let identity = identity else { return nil }
        
        var certificate: SecCertificate? = nil
        SecIdentityCopyCertificate(identity, &certificate)
        
        return certificate
    }

}
