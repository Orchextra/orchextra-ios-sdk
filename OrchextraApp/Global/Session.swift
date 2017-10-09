//
//  Session.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class Session {
    
    static let shared = Session()
    let userDefault: UserDefaults
    
    private let keyOrchextraRunning = "keyOrchextraRunning"
    private let keyCredentials = "keyCredentials"

    var apiKey: String?
    var apiSecret: String?
    
    init(userDefault: UserDefaults = UserDefaults()) {
        self.userDefault = userDefault
    }

    // MARK: - Public

    func orchextraRunning(running: Bool) {
        self.userDefault.set(running, forKey: keyOrchextraRunning)
    }
    
    func isOrchextraRunning() -> Bool? {
        return self.userDefault.value(forKey: keyOrchextraRunning) as? Bool
    }
}
