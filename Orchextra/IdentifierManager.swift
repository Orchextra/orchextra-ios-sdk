//
//  IdentifierManager.swift
//  Orchextra
//
//  Created by José Estela on 11/5/18.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import AdSupport

class IdentifierManager {
    
    // MARK: - Private attributes
    
    private let userDefaults: UserDefaults
    private let session: Session
    
    private enum IdentifierKeys: String {
        case identifier = "orx_sdk_identifier"
    }
    
    // MARK: - Public methods
    
    init() {
        self.userDefaults = UserDefaults.standard
        self.session = Session.shared
    }
    
    func sdkIdentifier() -> String {
        if self.session.isAnonymousUser {
            if let identifier = self.loadIdentifier() {
                return identifier
            } else {
                let uuidString = UUID().uuidString
                self.saveIdentifier(uuidString)
                return uuidString
            }
        }
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    // MARK: - Private methods
    
    private func saveIdentifier(_ identifier: String) {
        self.userDefaults.set(identifier, forKey: IdentifierKeys.identifier.rawValue)
    }
    
    private func loadIdentifier() -> String? {
        return self.userDefaults.object(forKey: IdentifierKeys.identifier.rawValue) as? String
    }
}
