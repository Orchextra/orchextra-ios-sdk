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
    var spyHandleNotification: (called: Bool, userInfo: [AnyHashable: Any]?)! = (called: false, userInfo: nil)
    var spyDispatchNotification: (called: Bool, action: Action?)! = (called: false, action: nil)
    
    var spyHandleRemoteNotification: (called: Bool, userInfo: [AnyHashable: Any]?)! = (called: false, userInfo: nil)
    var spyDispatchAction: (called: Bool, action: Action?)! = (called: false, action: nil)
    
    func configure() {
        self.spyConfigureCalled = true
    }
    
    func handleLocalNotification(userInfo: [AnyHashable : Any]) {
        self.spyHandleNotification.called = true
        self.spyHandleNotification.userInfo = userInfo
    }
    
    func handleRemoteNotification(_ notification: PushNototificationORX, data: [AnyHashable: Any]) {
        self.spyHandleRemoteNotification.called = true
        self.spyHandleRemoteNotification.userInfo = data
    }
    
    func dispatchNotification(with action: Action) {
        self.spyDispatchNotification = (called: true, action: action)
    }
    
    func dispatch(_ action: Action) {
        self.spyDispatchAction = (called: true, action: action)
    }

}
