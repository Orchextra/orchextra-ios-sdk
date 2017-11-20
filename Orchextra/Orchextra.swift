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
    
     // MARK: Public fetch new eddystone information
    public func openEddystone(with completionHandler: (UIBackgroundFetchResult) -> Void) {
        OrchextraWrapper.shared.openEddystone(with: completionHandler)
    }
    
    /**
     Send request with ORX headers.
     Orx will handle the accesstoken for all submodules.
     
     - parameter request: Request
     - parameter completionHandler: returns a callback Response
     - Availability: 3.0
     */
    public func sendOrxRequest(request: Request, completionHandler: @escaping (Response) -> Void) {
        OrchextraWrapper.shared.sendOrxRequest(request: request, completionHandler: completionHandler)
    }
    
    // MARK: Public trigger methods
    
    /**
     Method to set up a custom scanner with ModuleInput interface
     - vc: the scanner has to be a viewcontroller
     
     - Since: 3.0
     */
    public func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        OrchextraWrapper.shared.setScanner(vc: vc)
    }
    
    /**
     Set proximity module, if there is not module setup ORX will used the default one
     
     - Since: 3.0
     */
    public func setProximity(proximityModule: ModuleInput) {
        OrchextraWrapper.shared.proximity = proximityModule
    }
    
    /**
     Open scanner module as a trigger from outside ORX.
     
     - Since: 1.0
     */
    public func openScanner() {
        OrchextraWrapper.shared.openScanner()
    }
    
    public func openImageRecognition() {}
    
    /**
     Open scanner module as a trigger from outside ORX.
     
     - Since: 1.0
     */
    public func remote(apnsToken: Data) {
        OrchextraWrapper.shared.remote(apnsToken: apnsToken)
    }
    
    // MARK: Authorization
    
    /// Return Accesstoken from ORX
    ///
    /// - Returns: accesstoken
    public func accesstoken() -> String? {
        return OrchextraWrapper.shared.accesstoken()
    }
    
    // MARK: Public CRM methods
    public func bindUser(_ user: UserOrx) {
        OrchextraWrapper.shared.bindUser(user)
    }
    public func unbindUser() {
        OrchextraWrapper.shared.unbindUser()
    }
    public func currentUser() -> UserOrx? {
        return OrchextraWrapper.shared.currentUser()
    }
    
    public func setUserBusinessUnits(_ businessUnits: [BusinessUnit]) {
        OrchextraWrapper.shared.setUserBusinessUnits(businessUnits)
    }
    
    public func getUserBusinessUnits() -> [BusinessUnit] {
        return OrchextraWrapper.shared.getUserBusinessUnits()
    }
    
    public func setUserTags(_ tags: [Tag]) {
        OrchextraWrapper.shared.setUserTags(tags)
    }
    
    public func getUserTags() -> [Tag] {
        return OrchextraWrapper.shared.getUserTags()
    }
    
    public func getAvailableCustomFields() -> [CustomField] {
        return OrchextraWrapper.shared.getAvailableCustomFields()
    }
    
    public func setCustomFields(_ customFields: [CustomField]) {
        OrchextraWrapper.shared.setCustomFields(customFields)
    }
    
    public func getCustomFields() -> [CustomField] {
        return OrchextraWrapper.shared.getCustomFields()
    }
    
     // MARK: Public Device methods
    public func bindDevice() {
        OrchextraWrapper.shared.bindDevice()
    }
    
    public func setDeviceBusinessUnits(_ businessUnits: [BusinessUnit]) {
        OrchextraWrapper.shared.setDeviceBusinessUnits(businessUnits)
    }
    
    public func getDeviceBusinessUnits() -> [BusinessUnit] {
        return OrchextraWrapper.shared.getDeviceBusinessUnits()
    }
    
    public func setDeviceTags(_ tags: [Tag]) {
        OrchextraWrapper.shared.setDeviceTags(tags)
    }
    
    public func getDeviceTags() -> [Tag] {
        return OrchextraWrapper.shared.getDeviceTags()
    }
    
    // MARK: - Public method to handle Notification
    
    public func handleNotification(userInfo: [String: Any]) {
        PushOrxManager.shared.handleNotification(userInfo: userInfo)
    }
}
