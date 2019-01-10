//
//  Log.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 10/01/2019.
//  Copyright © 2019 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

public class OrchextraAppLogger: LoggableModule {
    public static var logLevel: LogLevel {
        set {
            try? LogManager.shared.setLogLevel(newValue, forModule: self)
        }
        get {
            return LogManager.shared.logLevel(forModule: self) ?? .none
        }
    }
    
    public static var logStyle: LogStyle {
        set {
            try? LogManager.shared.setLogStyle(newValue, forModule: self)
        }
        get {
            return LogManager.shared.logStyle(forModule: self) ?? .none
        }
    }
    
    public static func logInfo(_ logInfo: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
        GIGLibrary.gigLogInfo(logInfo, module: OrchextraAppLogger.self, filename: filename, line: line, funcname: funcname)
    }
    
    public static func logDebug(_ logInfo: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
        GIGLibrary.gigLogDebug(logInfo, module: OrchextraAppLogger.self, filename: filename, line: line, funcname: funcname)
    }
    
    public static func logWarn(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
        GIGLibrary.gigLogWarn(message, module: OrchextraAppLogger.self, filename: filename, line: line, funcname: funcname)
    }
    
    public static func logError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
        GIGLibrary.gigLogError(error, module: OrchextraAppLogger.self, filename: filename, line: line, funcname: funcname)
    }
}

func logInfo(_ logInfo: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    OrchextraAppLogger.logInfo(logInfo, filename: filename, line: line, funcname: funcname)
}

func logDebug(_ logInfo: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    OrchextraAppLogger.logDebug(logInfo, filename: filename, line: line, funcname: funcname)
}

func logWarn(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    OrchextraAppLogger.logWarn(message, filename: filename, line: line, funcname: funcname)
}

func logError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    OrchextraAppLogger.logError(error, filename: filename, line: line, funcname: funcname)
}
