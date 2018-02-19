//
//  ORCLog.swift
//  Orchextra
//
//  Created by Carlos Vicente on 1/6/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

protocol LogError {
    static func logError(format: String)
}

protocol LogWarning {
    static func logWarning(format: String)
}

protocol LogDebug {
    static func logDebug(format: String)
}

protocol LogVerbose {
    static func logVerbose(format: String)
}

// Log Error
extension ORCLog: LogError {
    static func logError(format: String) {
        ORCLog.sharedInstance().logError(format)
    }
}

// Log Warning
extension ORCLog: LogWarning {
    static func logWarning(format: String) {
        ORCLog.sharedInstance().logWarning(format)
    }
}

// Log Debug
extension ORCLog: LogDebug {
    static func logDebug(format: String) {
        ORCLog.sharedInstance().logDebug(format)
    }
}

// Log Verbose
extension ORCLog: LogVerbose {
    static func logVerbose(format: String) {
        ORCLog.sharedInstance().logVerbose(format)
    }
}
