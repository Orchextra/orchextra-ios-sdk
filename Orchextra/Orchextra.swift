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
    
    /**
     This method will inform anytime that user or device have been modified.
     
     - parameter trigger:
     - Since: 3.0
     */
    
    func bindDidCompleted(result: Result<[AnyHashable: Any], Error>)
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
    
    /**
     Push Manager input Singleton instance
     
     - Since: 3.0
     */
    public var pushManager: PushOrxInput
    
    init() {
        self.logLevel = .debug
        self.logStyle = .funny
        self.environment = .production
        self.pushManager = PushOrxManager.shared
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

    
    /// Stop services with Orchextra
    public func stop() {
        OrchextraWrapper.shared.stop()
    }
    
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
    
    /**
     Enable proximity module
     By default the proximity module will be disable to improve the performance
     and only will be used in case needed.
     
     - Since: 3.0
     */
    public func enableProximity(enable: Bool) {
        OrchextraWrapper.shared.enableProximity(enable: enable)
    }
    
    /**
     Enable eddystone module
     
     - Since: 3.0
     */
    public func enableEddystones(enable: Bool) {
        OrchextraWrapper.shared.enableEddystone(enable: enable)
    }
    
    /**
     Save remote notifications token.
     
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
    
    /**
     Unbind user
     
     - Since: 1.0
     */
    public func unbindUser() {
        OrchextraWrapper.shared.unbindUser()
    }
    
    /**
     Return the current user
     
     - Since: 1.0
     */
    public func currentUser() -> UserOrx? {
        return OrchextraWrapper.shared.currentUser()
    }
    
    /**
     Set BusinessUnit to the current user
     
     - Since: 1.0
     */
    public func setUserBusinessUnits(_ businessUnits: [BusinessUnit]) {
        OrchextraWrapper.shared.setUserBusinessUnits(businessUnits)
    }
    
    /**
     Get BusinessUnit from the current user
     
     - Since: 1.0
     */
    public func getUserBusinessUnits() -> [BusinessUnit] {
        return OrchextraWrapper.shared.getUserBusinessUnits()
    }
    
    /**
     Set Tags to the current user
     
     - Since: 1.0
     */
    public func setUserTags(_ tags: [Tag]) {
        OrchextraWrapper.shared.setUserTags(tags)
    }
    
    /**
     Get Tags from the current user
     
     - Since: 1.0
     */
    public func getUserTags() -> [Tag] {
        return OrchextraWrapper.shared.getUserTags()
    }
    
    /**
     Get available custom fields
     
     - Since: 1.0
     */
    public func getAvailableCustomFields() -> [CustomField] {
        return OrchextraWrapper.shared.getAvailableCustomFields()
    }
    
    /**
     Set custom fields for an specific project
     
     - Since: 1.0
     */
    public func setCustomFields(_ customFields: [CustomField]) {
        OrchextraWrapper.shared.setCustomFields(customFields)
    }
    
    /**
     Get custom fields for an specific project
     
     - Since: 1.0
     */
    public func getCustomFields() -> [CustomField] {
        return OrchextraWrapper.shared.getCustomFields()
    }
    
     // MARK: Public Device methods
    public func bindDevice() {
        OrchextraWrapper.shared.bindDevice()
    }
    
    /**
     Set BusinessUnits to the device
     
     - Since: 1.0
     */
    public func setDeviceBusinessUnits(_ businessUnits: [BusinessUnit]) {
        OrchextraWrapper.shared.setDeviceBusinessUnits(businessUnits)
    }
    
    /**
     Get BusinessUnits from the device
     
     - Since: 1.0
     */
    public func getDeviceBusinessUnits() -> [BusinessUnit] {
        return OrchextraWrapper.shared.getDeviceBusinessUnits()
    }
    
    /**
     Set tags to a device
     
     - Since: 1.0
     */
    public func setDeviceTags(_ tags: [Tag]) {
        OrchextraWrapper.shared.setDeviceTags(tags)
    }
    
    /**
     Get tags from the device
     
     - Since: 1.0
     */
    public func getDeviceTags() -> [Tag] {
        return OrchextraWrapper.shared.getDeviceTags()
    }
    
    // MARK: - Public method to handle local Notification
    
    public func handleLocalNotification(userInfo: [AnyHashable: Any]) {
       self.pushManager.handleLocalNotification(userInfo: userInfo)
    }
    
    // MARK: - Public method to handle remote Notification
    
    public func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
        let notificationJson = JSON(from: userInfo)
        guard let notification = PushNototificationORX.parse(from: notificationJson) else {
            LogWarn("Notification is invalid")
            return
        }
        
        guard let data = userInfo["data"] as? [AnyHashable: Any] else {
            LogWarn("Invalid data node")
            return
        }
        
        self.pushManager.handleRemoteNotification(notification, data: data)
    }
}
