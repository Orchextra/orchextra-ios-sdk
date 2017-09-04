//
//  PushOrxManagerMock.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
@testable import Orchextra

class PushOrxManagerMock: PushOrxInput {
    
    var spyConfigureCalled = false
    var spyHandleNotification: (called: Bool, userInfo: [String: Any])!
    var spyDispatchNotification: (called: Bool, action: Action)!
    
    func configure() {
        self.spyConfigureCalled = true
    }
    
    func handleNotification(userInfo: [String : Any]) {
        self.spyHandleNotification.called = true
        self.spyHandleNotification.userInfo = userInfo
    }
    
    func dispatchNotification(with action: Action) {
        self.spyDispatchNotification = (called: true, action: action)
    }

}
