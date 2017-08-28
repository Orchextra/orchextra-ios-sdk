//
//  BundleExtension.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

extension Bundle {
    
    class func OrxBundle() -> Bundle {
        return Bundle(for: Orchextra.self)
    }
    
    class func localize(_ key: String, comment: String) -> String {
        return Bundle.localizeBundle(key: Bundle.localizeMain(key: key))
    }
    
    class func localizeMain(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    class func localizeBundle(key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.OrxBundle(), comment: "")
    }
    
    class func OrxVersion() -> String {
        guard let version = Bundle.OrxBundle().infoDictionary!["CFBundleShortVersionString"]! as? String else {
            return "3.0.0"
        }
        return version
    }
    
    class func OrxBuildVersion() -> String {
        guard let version = Bundle.OrxBundle().infoDictionary!["CFBundleVersion"]! as? String else {
            return "1"
        }
        return version
    }
}
