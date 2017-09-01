//
//  Orchextra.swift
//  Orchextra
//
//  Created by Carlos Vicente on 11/8/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import GIGLibrary

/**
 
 The Orchextra class provides you with methods for starting the
 framework and get notified when a trigger
 is fired or an action is launched within your app.
 
 ### Usage
 
 You should use the `shared` property to get a unique singleton 
 instance, then set your `logLevel`
 
 ### Overview
 
 Once the framework is started, you can get notified when a trigger is f
 ired or an action is launched within your app..
 
 - Since: 3.0
 - Version: 3.0
 - Authors: 
 Judith Medina
 Carlos Vicente

 - Copyright: Gigigo S.L.
 */



/**
 This protocol is used to comunicate Orchextra with integrative application.
 
 - Since: 1.0
 */
public protocol ORXDelegate {
    
    /**
     Use this method to execute a custom action associated to a scheme.
     
     - parameter scheme: The scheme to be executed.
     - Since: 3.0
     */
    func customScheme(_ scheme: String)
    
    /**
     Use this method to inform the integrative app about all trigger that have been fired.
     
     - parameter trigger: Trigger fired by the system.
     - Since: 3.0
     */
    func triggerFired(_ trigger: Trigger)

}

open class Orchextra {
    
    // MARK: Public properties
    
    /**
     Orchextra Singleton instance
     
     - Since: 3.0
     */
    public static let shared: Orchextra = Orchextra()
    
    
    /**
     The ORX delegate. Use it to communicate with integrative application.
     
     - Since: 1.0
     */
    public var delegate: ORXDelegate?
    
    
    /**
     Type of Orchextra logs you want displayed in the debug console
     
     - **none**: No log will be shown. Recommended for production environments.
     - **error**: Only warnings and errors. Recommended for develop environments.
     - **info**: Errors and relevant information. Recommended for testing
     - **debug**: Not recommended to use, only for debugging ORCHEXTRA .
     */
    public var logLevel: LogLevel {
        didSet {
            LogManager.shared.logLevel = self.logLevel
        }
    }
    
    /**
     Type of Orchextra logs you want displayed in the debug console
     
     - **none**: No emojis will be displayed.
     - **funny**: Emojis will be displayed.
     */
    public var logStyle: LogStyle {
        didSet {
            LogManager.shared.logStyle = self.logStyle
        }
    }
    
    public var environment: Environment
    
    init() {
        self.logLevel = .debug
        self.logStyle = .funny
        self.environment = .production
        LogManager.shared.appName = "ORCHEXTRA"
    }
    
    // MARK: PUBLIC SDK METHODS
    
    /**
     Initializes an Orchextra instance with ApiKey and ApiSecret.
     - parameter apiKey: orchextra ApiKey
     - parameter apiSecret: orchextra ApiSecret
     - parameter completion: returns a callback Result<Bool, Error>
     - Availability: 3.0.0
     */
    @available(*, introduced: 3.0.0, message: "use start: instead", renamed: "start")
    public func start(with apiKey: String, apiSecret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        OrchextraWrapper.shared.start(with: apiKey, apiSecret: apiSecret, completion: completion)
    }
    
    public func status() {}
    public func stop() {}
    public func geolocation() {}
    
    // MARK: Public submit SDK methods
    public func commitConfiguration() {}

    
    // MARK: Public trigger methods
    public func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        OrchextraWrapper.shared.setScanner(vc: vc)
    }
    
    public func openScanner() {
        OrchextraWrapper.shared.openScanner()
    }
    
    public func openImageRecognition() {}
    
//    // MARK: Public CRM methods
//    public func bindUser(_ user: ORCUser) {}
//    public func unbindUser() {}
//    public func currentUser() -> ORCUser { return ORCUser() }
    
    // MARK: - Public method to handle Notification
    
    public func handleNotification(userInfo: [String: Any]) {
        PushOrxManager.shared.handleNotification(userInfo: userInfo)
    }

    
}
