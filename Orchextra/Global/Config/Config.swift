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

enum Modules {
    case proximity
    case eddystones
    case imageRecognition
}

class Config {

    static var SDKVersion: String {
        let bundle = Bundle.orxBundle()
        let sdkVersion: String? = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        let versionNumber = sdkVersion ?? "3.0.0"
        let version = "IOS_\(versionNumber)"
        return version
    }
    
    /// Core Endpoint based on the environment
    static var coreEndpoint: String {
        switch Orchextra.shared.environment {
        case .staging:
            return "https://core.s.orchextra.io"
        case .quality:
            return "https://core.q.orchextra.io"
        case .production:
            return "https://core.orchextra.io"
        }
    }
    
    /// Triggering Endpoint based on the environment
    static var triggeringEndpoint: String {
        switch Orchextra.shared.environment {
        case .staging:
            return "https://tr.s.orchextra.io"
        case .quality:
            return "https://tr.q.orchextra.io"
        case .production:
            return "https://tr.orchextra.io"
        }
    }
    
    /// Custom scheme to launch scanner module
    static var scannerCustomScheme: String {
        return "Orchextra://scanner"
    }
}

func localize(_ key: String, comment: String) -> String {
    return localizeFromSDK(key: localizeMainBundle(key: key))
}

func localizeMainBundle(key: String) -> String {
    return NSLocalizedString(key, tableName: nil, bundle: Bundle.main, comment: "")
}

func localizeFromSDK(key: String) -> String {
    return NSLocalizedString(key, tableName: nil, bundle: Bundle.orxBundle(), comment: "")
}
