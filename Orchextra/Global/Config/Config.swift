//
//  Config.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

public enum Environment {
    case staging
    case quality
    case production
}

class Config {

    static var SDKVersion: String {
        let bundle = Bundle.orchextraBundle()
        let sdkVersion: String? = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        let versionNumber = sdkVersion ?? "3.0.0"
        let version = "IOS_\(versionNumber)"
        return version
    }
    
    /// Core Endpoint based on the environment
    static var coreEndpoint: String {
        switch Orchextra.shared.environment {
        case .staging:
            return "https://sdk.s.orchextra.io/v1"
        case .quality:
            return "https://sdk.q.orchextra.io/v1"
        case .production:
            return "https://sdk.orchextra.io/v1"
        }
    }
    
}


