//
//  Log.swift
//  OrchextraApp
//
//  Created by Alejandro Jiménez Agudo on 19/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

import Foundation


public enum LogLevel: Int {
    /// No log will be shown.
    case none = 0
    
    /// Only warnings and errors.
    case error = 1
    
    /// Errors and relevant information.
    case info = 2
    
    /// Request and Responses will be displayed.
    case debug = 3
}

public enum LogStyle: Int {
    
    /// Profesional style no emojis
    case  none = 0
    
    /// Funny style with emojis
    case funny = 1
}


public func >=(levelA: LogLevel, levelB: LogLevel) -> Bool {
    return levelA.rawValue >= levelB.rawValue
}


open class LogManager {
    
    open static let shared = LogManager()
    
    open var appName: String?
    open var logLevel: LogLevel = .none
    open var logStyle: LogStyle = .none
}


public func Log(_ log: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    guard LogManager.shared.logLevel != .none else { return }
    let appName = LogManager.shared.appName ?? "Gigigo Log Manager"
    
    print("\(appName)::" + log)
}

public func LogInfo(_ log: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    let className = filename.lastPathComponent.components(separatedBy: ".").first!
    let emoji = (LogManager.shared.logStyle == .funny) ? " ⓘ" : ""
    let caller = " [Info\(emoji)] \(className)(\(line)) - \(funcname): "
    guard LogManager.shared.logLevel >= .info else { return }
    Log(caller + log)
}

public func LogDebug(_ log: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    let className = filename.lastPathComponent.components(separatedBy: ".").first!
    let emoji = (LogManager.shared.logStyle == .funny) ? " 🐛" : ""
    let caller = " [Debug\(emoji)] \(className)(\(line)) - \(funcname): "
    guard LogManager.shared.logLevel >= .debug else { return }
    Log(caller + log)
}

public func LogWarn(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    guard LogManager.shared.logLevel >= .error else { return }
    let className = filename.lastPathComponent.components(separatedBy: ".").first!
    let emoji = (LogManager.shared.logStyle == .funny) ? " 🔥" : ""
    let caller = " [Error\(emoji)] \(className)(\(line)) - \(funcname): "
    Log(caller + message)
}

public func LogError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    guard
        LogManager.shared.logLevel >= .error,
        let err = error
        else { return }
    let className = filename.lastPathComponent.components(separatedBy: ".").first!
    let emoji = (LogManager.shared.logStyle == .funny) ? " 🔥" : ""
    let caller = " [Error\(emoji)] \(className)(\(line)) - \(funcname): \(err.localizedDescription)"
    Log(caller)
}
