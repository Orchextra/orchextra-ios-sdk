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
    
    var apiKey: String?
    var apiSecret: String?
    
    init(userDefault: UserDefaults = UserDefaults()) {
        self.userDefault = userDefault
    }

    func save(accessToken: String?) {
        self.userDefault.archiveObject(accessToken, forKey: keyAccessToken)
    }
    
    func loadAccesstoken() -> String? {
        return self.userDefault.unarchiveObject(forKey: keyAccessToken) as? String
    }
}
