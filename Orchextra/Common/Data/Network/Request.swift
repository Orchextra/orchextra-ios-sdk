//
//  Request.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

extension Request {
    
    class func orchextraRequest(
        method: String,
        baseUrl: String,
        endpoint: String,
        urlParams: [String: Any]? = nil,
        bodyParams: [String: Any]? = nil) -> Request {
        
        return Request (
            method: method,
            baseUrl: baseUrl,
            endpoint: endpoint,
            headers: self.headers(endpoint: endpoint),
            urlParams: urlParams,
            bodyParams: bodyParams,
            verbose: Orchextra.shared.logLevel == .debug
        )
    }
    
    private class func userAgent() -> String {
        let versioniOS = UIDevice.current.systemVersion
        let bundleId = Bundle.main.bundleIdentifier ?? "com.orchextra.none"
        return "iOS_\(versioniOS)_\(bundleId)"
    }
    
    class func headers(endpoint: String) -> [String: String] {
        let acceptLanguage: String = Locale.current.identifier
        let headers =  [
            "X-app-sdk": Config.SDKVersion,
            "Accept-Language": acceptLanguage,
            "user-agent": Request.userAgent()]
        guard let authorization = self.authHeader() else {
            logWarn("Header without Bearer token \(endpoint))")
            return headers
        }
        
        let authHeader = headers + authorization
        return authHeader
    }
    
    class func authHeader() -> [String: String]? {
        guard let accesstoken: String = Session.shared.loadAccesstoken() else {
            return nil
        }
        return ["Authorization": "JWT \(accesstoken)"]
    }
    
    /// Add JWL Authentication to a request
    ///
    /// - Returns: the same request with (JWL + ORX Accesstoken)
    func addORXHeader() -> Request {
        if let headers = self.headers,
            let auth = Request.authHeader() {
            let authHeaders = auth + headers
            self.headers = authHeaders
        }
        return self
    }
    
    
    
}
