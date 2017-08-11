//
//  Orchextra.swift
//  Orchextra
//
//  Created by Carlos Vicente on 11/8/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

/**
 The Orchextra class provides you with methods for starting the framework and get notified when a trigger is fired or an action is launched within your app.
 
 
 ### Usage
 
 You should use the `shared` property to get a unique singleton instance, then set your `logLevel`
 
 
 ### Overview
 
 Once the framework is started, you can get notified when a trigger is fired or an action is launched within your app..
 
 
 - Since: 3.0
 - Version: 3.0
 - Author: Gigigo S.L.
 - Copyright: Gigigo S.L.
 */

public class Orchextra {
    //swiftlint:disable file_length
    
    // MARK: Public properties
    
    /**
     Orchextra Singleton instance
     
     - Since: 3.0
     */
    public static let shared: Orchextra = Orchextra()
    
    /**
     Type of Orchextra's logs you want displayed in the debug console
     
     - **off**: No log will be shown. Recommended for production environments.
     - **error**: Only errors. Recommended for develop environments.
     - **warning**: Only warnings and errors. Recommended for develop environments.
     - **debug**: Debug logs "basic information". Recommended for testing Orchextra integration.
     - **all**: Request and Responses to Orchextra's server will be displayed. Recommended to use, only for debugging Orchextra.
     */
    public var logLevel: ORCLogLevel = .off {
        didSet {
            ORCLog.logLevel(logLevel)
        }
    }
    
    // MARK: Public SDK methods
    /**
     Initializes an Orchextra instance.
     
     - Since: 3.0
     */
    init(with apiKey: String, apiSecret:String) {
        //Persist apiKey and apiSecret and creates the session
    }
    
    public func start() {}
    public func status() {}
    public func stop() {}
    public func geolocation() {}
    
    // MARK: Public submit SDK methods
    public func commitConfiguration() {}
    
    // MARK: Public trigger methods
    public func openScanner() {}
    public func openImageRecognition() {}
    
    // MARK: Public CRM methods
    public func bindUser(_ user: ORCUser) {}
    public func unbindUser() {}
    public func currentUser() -> ORCUser { return ORCUser() }
    
    // MARK: Private methods
    /** Initializes a basic Orchextra instance.
     
     - Since: 3.0
     */
    fileprivate init() {
        // Do notihing. This method has been created only to initialize shared Instance without ApiKey and secret to conform file (Introduction.md) Ask if can be changed to avoid this boilerplate method.
    }
    
    //swiftlint:enable file_legth
}
