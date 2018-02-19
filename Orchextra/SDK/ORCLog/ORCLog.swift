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
        if ORCLog.sharedInstance().isLogError() {
            print("ERROR: \(format)")
        }
       // ORCLog.sharedInstance().logError(format)
    }
}

// Log Warning
extension ORCLog: LogWarning {
    static func logWarning(format: String) {
        if ORCLog.sharedInstance().isLogWarning() {
            print("WARNING: \(format)")
        }
        
       // ORCLog.sharedInstance().logWarning(format)
    }
}

// Log Debug
extension ORCLog: LogDebug {
    static func logDebug(format: String) {
        if ORCLog.sharedInstance().isLogDebug() {
            print("DEBUG: \(format)")
        }
        
       // ORCLog.sharedInstance().logDebug(format)
    }
}

// Log Verbose
extension ORCLog: LogVerbose {
    static func logVerbose(format: String) {
        if ORCLog.sharedInstance().isLogVerbose() {
            print("VERBOSE: \(format)")
        }
        
       // ORCLog.sharedInstance().logVerbose(format)
    }
}

