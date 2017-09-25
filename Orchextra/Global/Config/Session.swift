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
    
    private let keyAccessToken = "accesstoken"
    private let keyCredentials = "credentials"

    var apiKey: String?
    var apiSecret: String?
    
    init(userDefault: UserDefaults = UserDefaults()) {
        self.userDefault = userDefault
    }

    // MARK: - Public

    func save(accessToken: String?) {
        self.userDefault.archiveObject(accessToken, forKey: keyAccessToken)
    }
    
    func loadAccesstoken() -> String? {
        return self.userDefault.unarchiveObject(forKey: keyAccessToken) as? String
    }
    
    func credentials(apiKey: String, apiSecret: String) {
        guard let credentials = self.loadCredentials() else {
            self.saveCredentials(apiKey: apiKey, apiSecret: apiSecret)
            return
        }
        
        if  apiKey != credentials.apiKey ||
            apiSecret != credentials.apiSecret {
            self.save(accessToken: nil)
            self.saveCredentials(apiKey: apiKey, apiSecret: apiSecret)
        }
    }
    
    // MARK: - Private
    
    private func saveCredentials(apiKey: String, apiSecret: String) {
        let credentials: [String: Any] = ["apiKey": apiKey,
                           "apiSecret": apiSecret]
        
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        
        self.userDefault.archiveObject(credentials, forKey: keyCredentials)
    }
    
    private func loadCredentials() -> (apiKey: String, apiSecret: String)? {
        var credentials = self.userDefault.unarchiveObject(forKey: keyCredentials) as? [String : Any]
        
        guard let apiKey = credentials?["apiKey"] as? String,
            let apiSecret = credentials?["apiSecret"] as? String else {
                return nil
        }

        self.apiKey = apiKey
        self.apiSecret = apiSecret
        
        return (apiKey, apiSecret)
    }
}
