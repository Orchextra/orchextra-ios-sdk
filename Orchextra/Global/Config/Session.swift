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
    var project: Project?
    var apiKey: String?
    var apiSecret: String?
    var isAnonymousUser: Bool = false
    
    // Attributes core
    private let keyAccessToken = "orx_accesstoken"
    private let keyCredentials = "orx_credentials"
    private let keyUser = "orx_user"
    private let keyDeviceBusinessUnits = "orx_device_business_units"
    private let keyDeviceTags = "orx_device_tags"
    private let keyPushNotificationsToken = "orx_push_notifications_token"
    
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
    
    // MARK: - CRM User public methods
    
    func bindUser(_ user: UserOrx) {
        self.userDefault.set(try? PropertyListEncoder().encode(user), forKey: keyUser)
    }
    
    func unbindUser() {
        let user = UserOrx()
         self.userDefault.set(try? PropertyListEncoder().encode(user), forKey: keyUser)
    }
    
    func currentUser() -> UserOrx? {
        if let data = self.userDefault.value(forKey: keyUser) as? Data {
            let user = try? PropertyListDecoder().decode(UserOrx.self, from: data)
            return user
        }
        return nil
    }
    
    func deviceBusinessUnits() -> [BusinessUnit] {
        guard let data = self.userDefault.value(forKey: keyDeviceBusinessUnits) as? Data else { return [BusinessUnit]() }
        return (try? PropertyListDecoder().decode([BusinessUnit].self, from: data)) ?? [BusinessUnit]()
    }
    
    func setDeviceBusinessUnits(businessUnits: [BusinessUnit]) {
        self.userDefault.set(try? PropertyListEncoder().encode(businessUnits), forKey: keyDeviceBusinessUnits)
    }
    
    func deviceTags() -> [Tag] {
        guard let data = self.userDefault.value(forKey: keyDeviceTags) as? Data else { return [Tag]() }
        return (try? PropertyListDecoder().decode([Tag].self, from: data)) ?? [Tag]()
    }
    
    func setDeviceTags(tags: [Tag]) {
        self.userDefault.set(try? PropertyListEncoder().encode(tags), forKey: keyDeviceTags)
    }
    
    // MARK: - Push notifications public methods
    
    func pushNotificationToken() -> Data? {
        guard let data = self.userDefault.value(forKey: keyPushNotificationsToken) as? Data else {
            LogWarn("Push notification token not set yet")
            return nil
        }
        return (try? PropertyListDecoder().decode(Data.self, from: data)) ?? nil
    }
    
    func setPushNotification(token: Data?) {
        self.userDefault.set(try? PropertyListEncoder().encode(token), forKey: keyPushNotificationsToken)
    }
    
    /// Method to store apikey and apisecret
    ///
    /// - Parameters:
    ///   - apiKey: apikey orx project
    ///   - apiSecret: apisecret orx project
    /// - Returns:
    ///     - true: if credentials have been changed
    ///     - false: if credentials have stored already and haven't changed since last time.

    func credentials(apiKey: String, apiSecret: String) -> Bool {
        
        guard let credentials = self.loadCredentials() else {
            self.saveCredentials(apiKey: apiKey, apiSecret: apiSecret)
            return true
        }
        
        if  apiKey != credentials.apiKey ||
            apiSecret != credentials.apiSecret {
            self.save(accessToken: nil)
            self.saveCredentials(apiKey: apiKey, apiSecret: apiSecret)
            return true
        }
        return false
    }
    
    func setAnonymous(_ anonymous: Bool) {
        self.isAnonymousUser = anonymous
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
        var credentials = self.userDefault.unarchiveObject(forKey: keyCredentials) as? [String: Any]
        
        guard let apiKey = credentials?["apiKey"] as? String,
            let apiSecret = credentials?["apiSecret"] as? String else {
                return nil
        }

        self.apiKey = apiKey
        self.apiSecret = apiSecret
        
        return (apiKey, apiSecret)
    }
    
    private func statusORX(status: Bool) {
        
    }
}
