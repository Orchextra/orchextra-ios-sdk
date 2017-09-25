//
//  OrchextraWrapper.swift
//  Orchextra
//
//  Created by Carlos Vicente on 4/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary
import Orchextra

class OrchextraWrapper {
    let orchextra: Orchextra = Orchextra.shared
    public static let shared: OrchextraWrapper = OrchextraWrapper()
    
    init() {
        self.orchextra.delegate = self
    }
    
    // MARK: - Initialization

    func start(with key: String, secret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.orchextra.logLevel = .debug
        self.orchextra.logStyle = .funny
        self.orchextra.environment = .staging
        
        // TODO: get data from SDK and if it is nil set default project credentials
        self.orchextra.start(with: key, apiSecret: secret, completion: completion)
    }
    
    func stop() {
        self.orchextra.stop()
    }
    
    // MARK: - Notifications
    
    func remote(apnsToken: Data) {
        self.orchextra.remote(apnsToken: apnsToken)
    }
    
    func handleNotification(userInfo: [String: Any]) {
        self.orchextra.handleNotification(userInfo: userInfo)
    }
    
    // MARK: - Scanner
    
    func openOrchextraScanner() {
        self.orchextra.openScanner()
    }
    
    func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        self.orchextra.setScanner(vc: vc)
    }
    
    func openImageRecognition() {
        self.orchextra.openImageRecognition()
    }
    
     // MARK: - Eddystone
    func openEddystone(with completionHandler: (UIBackgroundFetchResult) -> Void) {
        self.orchextra.openEddystone(with: completionHandler)
    }
}

extension OrchextraWrapper: ORXDelegate {
    func customScheme(_ scheme: String) {
        // TODO: Implement custom scheme logic
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
}
