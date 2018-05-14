//
//  SessionMock.swift
//  Orchextra
//
//  Created by Judith Medina on 17/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
@testable import Orchextra


class SessionMock: Session {
    
    var currentUserInput: UserOrx?
    var inputAccesstoken: String?
    var spyBindUser: (called: Bool, user: UserOrx?) = (called: false, user: nil)
    var spySetDeviceBusinessUnits: (called: Bool, bunits: [BusinessUnit]) = (called: false, bunits: [])
    var spySetDeviceTags: (called: Bool, tags: [Tag]) = (called: false, tags: [])
    var spyCurrentUserCalled = false
    
    override func setDeviceBusinessUnits(businessUnits: [BusinessUnit]) {
        self.spySetDeviceBusinessUnits.called = true
        self.spySetDeviceBusinessUnits.bunits = businessUnits
    }
    
    override func setDeviceTags(tags: [Tag]) {
        self.spySetDeviceTags.called = true
        self.spySetDeviceTags.tags = tags
    }
    
    override func bindUser(_ user: UserOrx) {
        self.spyBindUser.called = true
        self.spyBindUser.user = user
    }
    
    override func currentUser() -> UserOrx? {
        self.spyCurrentUserCalled = true
        return self.currentUserInput
    }
    
    override func loadAccesstoken() -> String? {
        return self.inputAccesstoken
    }

}
