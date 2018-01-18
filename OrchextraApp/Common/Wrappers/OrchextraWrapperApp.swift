//
//  OrchextraWrapperApp.swift
//  Orchextra
//
//  Created by Carlos Vicente on 4/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary
import Orchextra

class OrchextraWrapperApp {
    let orchextra: Orchextra = Orchextra.shared
    public static let shared: OrchextraWrapperApp = OrchextraWrapperApp()
    
    init() {
        self.orchextra.delegate = self
    }
    
    // MARK: - Initialization

    func start(with key: String, secret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.orchextra.logLevel = .info
        self.orchextra.logStyle = .funny
        self.orchextra.environment = .staging
        
        self.orchextra.enableProximity(enable: true)
        self.orchextra.enableEddystones(enable: true)
        
        // TODO: get data from SDK and if it is nil set default project credentials
        self.orchextra.start(with: key, apiSecret: secret, completion: completion)
    }
    
    func stop() {
        self.orchextra.stop()
    }
    
    // MARK: - Handle Request ORX
    
    func sendOCMRequest(request: Request, completionHandler: @escaping (Response) -> Void) {
        self.orchextra.sendOrxRequest(request: request, completionHandler: completionHandler)
    }
    
    // MARK: - Notifications
    
    func remote(apnsToken: Data) {
        self.orchextra.remote(apnsToken: apnsToken)
    }
    
    func handleLocalNotification(userInfo: [AnyHashable: Any]) {
        self.orchextra.handleLocalNotification(userInfo: userInfo)
    }
    
    func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
        self.orchextra.handleRemoteNotification(userInfo: userInfo)
    }
    
    // MARK: - Scanner
    
    func openOrchextraScanner() {
        self.orchextra.openScanner()
    }
    
    func invalidatePreviousScanner() {
        self.orchextra.invalidatePreviousScanner()
    }
    
    func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        self.orchextra.setScanner(vc: vc)
    }
    
     // MARK: - Eddystone
    func openEddystone(with completionHandler: (UIBackgroundFetchResult) -> Void) {
        self.orchextra.openEddystone(with: completionHandler)
    }
}

extension OrchextraWrapperApp: ORXDelegate {
    func customScheme(_ scheme: String) {
        let alert = Alert(title: scheme, message: "")
        alert.addDefaultButton("OK", usingAction: nil)
        alert.show()
        Log("Custom scheme: - \(scheme) received")
    }
    
    func triggerFired(_ trigger: Trigger) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateWithoutFormat = Date()
        let dateString = dateWithoutFormat.description
        let dateFormatted: Date = dateFormatter.date(from: dateString) ?? Date()
        let dateFormatedString = dateFormatter.string(from: dateFormatted)
        let triggerFired = TriggerFired(trigger: trigger, date: dateFormatedString)
        TriggersManager.shared.add(trigger: triggerFired)
    }
    
    func bindDidCompleted(bindValues: [AnyHashable: Any]) {
        let alert = Alert(title: "Orchextra informs", message: "Bind has been made")
        alert.addDefaultButton("OK", usingAction: nil)
        alert.show()
        Log("bindDidCompleted with values: - \(bindValues) ")
    }
}
