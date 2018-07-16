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
     This method will inform anytime that device have been modified.
     
     - parameter trigger:
     - Since: 3.0
     */
    func deviceBindDidComplete(result: Result<[AnyHashable: Any], Error>)
    
    /**
     This method will inform anytime that user have been modified.
     
     - parameter trigger:
     - Since: 3.0
     */
    func userBindDidComplete(result: Result<[AnyHashable: Any], Error>)
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
     Texts displayed in ORX views. Use it to localize all displayed texts.
     */
    public var translations: Translations? {
        didSet {
            if let translations = self.translations {
                OrchextraController.shared.translations = translations
            }
        }
    }
    
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
        OldDataMigrationManager().migrateData()
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
        OrchextraController.shared.start(with: apiKey, apiSecret: apiSecret, completion: completion)
    }

    
    /// Stop services with Orchextra
    public func stop() {
        OrchextraController.shared.stop()
    }
    
     // MARK: Public fetch new eddystone information
    public func openEddystone(with completionHandler: (UIBackgroundFetchResult) -> Void) {
        OrchextraController.shared.openEddystone(with: completionHandler)
    }
    
    /**
     Send request with ORX headers.
     Orx will handle the accesstoken for all submodules.
     
     - parameter request: Request
     - parameter completionHandler: returns a callback Response
     - Availability: 3.0
     */
    public func sendOrxRequest(request: Request, completionHandler: @escaping (Response) -> Void) {
        OrchextraController.shared.sendOrxRequest(request: request, completionHandler: completionHandler)
    }
    
    // MARK: Public trigger methods
    
    /**
     Method to set up a custom scanner with ModuleInput interface
     - vc: the scanner has to be a viewcontroller
     
     - Since: 3.0
     */
    public func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        OrchextraController.shared.setScanner(vc: vc)
    }
    
    /**
     Set proximity module, if there is not module setup ORX will used the default one
     
     - Since: 3.0
     */
    public func setProximity(proximityModule: ModuleInput) {
        OrchextraController.shared.proximity = proximityModule
    }
    
    /**
     Open scanner module as a trigger from outside ORX.
     
     - Since: 1.0
     */
    public func openScanner() {
        OrchextraController.shared.openScanner()
    }
    
    /**
     Open scanner from outside ORX and return scan result on completion handler.
     
     - parameter completion: Completion handler for scan result, will return a `ScannerResult` with the code ans it's
     type in case of success, or an `Error` otherwise.
     
     - Since: 3.0
     */
    public func scan(completion: @escaping (Result<ScannerResult, ScannerError>) -> Void) {
        OrchextraController.shared.scan(completion: completion)
    }
    
    /**
     Enable proximity module
     By default the proximity module will be disable to improve the performance
     and only will be used in case needed.
     
     - Since: 3.0
     */
    public func enableProximity(enable: Bool) {
        OrchextraController.shared.enableProximity(enable: enable)
    }
    
    /**
     Enable eddystone module
     
     - Since: 3.0
     */
    public func enableEddystones(enable: Bool) {
        OrchextraController.shared.enableEddystone(enable: enable)
    }
    
    /// Use this method for anonymizing the user
    ///
    /// - Parameter enabled: If the anonymization is enabled
    /// - Since: 3.0.0
    public func anonymize(enabled: Bool) {
        OrchextraController.shared.setAnonymous(enabled)
    }
    
    /// Register for remote notifications
    ///
    /// - Parameter apnsToken: The push notification token
    /// - Since: 3.0
    public func registerForRemoteNotifications(with apnsToken: Data) {
        OrchextraController.shared.remote(apnsToken: apnsToken)
    }
    
    
    /// Unregister for remote notifications
    /// - Since: 3.0
    public func unregisterForRemoteNotifications() {
        OrchextraController.shared.remote(apnsToken: nil)
    }
    
    // MARK: Authorization
    
    /// Return Accesstoken from ORX
    ///
    /// - Returns: accesstoken
    public func accesstoken() -> String? {
        return OrchextraController.shared.accesstoken()
    }
    
    // MARK: Public CRM methods
    public func bindUser(_ user: UserOrx) {
        OrchextraController.shared.bindUser(user)
    }
    
    /**
     Unbind user
     
     - Since: 1.0
     */
    public func unbindUser() {
        OrchextraController.shared.unbindUser()
    }
    
    /**
     Return the current user
     
     - Since: 1.0
     */
    public func currentUser() -> UserOrx? {
        return OrchextraController.shared.currentUser()
    }
    
    /**
     Set BusinessUnit to the current user
     
     - Since: 1.0
     */
    public func setUserBusinessUnits(_ businessUnits: [BusinessUnit]) {
        OrchextraController.shared.setUserBusinessUnits(businessUnits)
    }
    
    /**
     Get BusinessUnit from the current user
     
     - Since: 1.0
     */
    public func getUserBusinessUnits() -> [BusinessUnit] {
        return OrchextraController.shared.getUserBusinessUnits()
    }
    
    /**
     Set Tags to the current user
     
     - Since: 1.0
     */
    public func setUserTags(_ tags: [Tag]) {
        OrchextraController.shared.setUserTags(tags)
    }
    
    /**
     Get Tags from the current user
     
     - Since: 1.0
     */
    public func getUserTags() -> [Tag] {
        return OrchextraController.shared.getUserTags()
    }
    
    /**
     Get available custom fields
     
     - Since: 1.0
     */
    public func getAvailableCustomFields() -> [CustomField] {
        return OrchextraController.shared.getAvailableCustomFields()
    }
    
    /**
     Set custom fields for an specific project
     
     - Since: 1.0
     */
    public func setCustomFields(_ customFields: [CustomField]) {
        OrchextraController.shared.setCustomFields(customFields)
    }
    
    /**
     Get custom fields for an specific project
     
     - Since: 1.0
     */
    public func getCustomFields() -> [CustomField] {
        return OrchextraController.shared.getCustomFields()
    }
    
     // MARK: Public Device methods
    public func bindDevice() {
        OrchextraController.shared.bindDevice()
    }
    
    /**
     Set BusinessUnits to the device
     
     - Since: 1.0
     */
    public func setDeviceBusinessUnits(_ businessUnits: [BusinessUnit]) {
        OrchextraController.shared.setDeviceBusinessUnits(businessUnits)
    }
    
    /**
     Get BusinessUnits from the device
     
     - Since: 1.0
     */
    public func getDeviceBusinessUnits() -> [BusinessUnit] {
        return OrchextraController.shared.getDeviceBusinessUnits()
    }
    
    /**
     Set tags to a device
     
     - Since: 1.0
     */
    public func setDeviceTags(_ tags: [Tag]) {
        OrchextraController.shared.setDeviceTags(tags)
    }
    
    /**
     Get tags from the device
     
     - Since: 1.0
     */
    public func getDeviceTags() -> [Tag] {
        return OrchextraController.shared.getDeviceTags()
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
