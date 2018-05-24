//
//  BundleExtension.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

extension Bundle {
    
    class func orxBundle() -> Bundle {
        return Bundle(for: Orchextra.self)
    }
    
    class func localize(_ key: String, comment: String) -> String {
        return Bundle.localizeBundle(key: Bundle.localizeMain(key: key))
    }
    
    class func localizeMain(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    class func localizeBundle(key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.orxBundle(), comment: "")
    }
    
    class func orxVersion() -> String {
        guard let version = Bundle.orxBundle().infoDictionary!["CFBundleShortVersionString"]! as? String else {
            return "3.0.0"
        }
        return version
    }
    
    class func orxBuildVersion() -> String {
        guard let version = Bundle.orxBundle().infoDictionary!["CFBundleVersion"]! as? String else {
            return "1"
        }
        return version
    }
}
