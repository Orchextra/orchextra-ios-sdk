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
        self.orchextra.environment = .quality
        
        // TODO: get data from SDK and if it is nil set default project credentials
        self.orchextra.start(with: key, apiSecret: secret, completion: completion)
    }
    
    func stop() {
        self.orchextra.stop()
    }
    
    // MARK: - Notifications
    
    func handleNotification(userInfo: [String: Any]) {
        self.orchextra.handleNotification(userInfo: userInfo)
    }
    
    // MARK: - Scanner
    
    func openOrchextraScanner() {
        self.orchextra.openScanner()
    }
    
    func openCustomScanner() {
        // TODO: Implement
    }
    
    func openImageRecognition() {
        self.orchextra.openImageRecognition()
    }
}

extension OrchextraWrapper: ORXDelegate {
    func customScheme(_ scheme: String) {
        // TODO: Implement custom scheme logic
    }
    
    func triggerFired(_ trigger: Trigger) {
        let timestamp: Int = Int(Date().timeIntervalSince1970 * 1000)
        let triggerFired = TriggerFired(trigger: trigger, timestamp: timestamp)
        TriggersManager.shared.add(trigger: triggerFired)
    }
}
