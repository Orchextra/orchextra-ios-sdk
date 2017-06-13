//
//  ORCLog.swift
//  Orchextra
//
//  Created by Carlos Vicente on 1/6/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

protocol LogError {
    static func logError(format: String, _ args: CVarArg...)
}

protocol LogWarning {
    static func logWarning(format: String, _ args: CVarArg...)
}

protocol LogDebug {
    static func logDebug(format: String, _ args: CVarArg...)
}

protocol LogVerbose {
    static func logVerbose(format: String, _ args: CVarArg...)
}

// Log Error
extension ORCLog: LogError {
    static func logError(format: String, _ args: CVarArg...) {
        ORCLog.logError(format, args: getVaList(args))
    }
}

// Log Warning
extension ORCLog: LogWarning {
    static func logWarning(format: String, _ args: CVarArg...) {
        ORCLog.logWarning(format, args: getVaList(args))
    }
}

// Log Debug
extension ORCLog: LogDebug {
    static func logDebug(format: String, _ args: CVarArg...) {
        ORCLog.logDebug(format, args: getVaList(args))
    }
}

// Log Verbose
extension ORCLog: LogVerbose {
    static func logVerbose(format: String, _ args: CVarArg...) {
        ORCLog.logVerbose(format, args: getVaList(args))
    }
}
