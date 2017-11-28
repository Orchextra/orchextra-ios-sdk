//
//  ORXDelegateMock.swift
//  OrchextraTests
//
//  Created by Carlos Vicente on 22/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

class ORXDelegateMock: ORXDelegate {
    var spyCustomSchemeCalled: (called: Bool, scheme: String?) = (called: false, scheme: nil)
    var spyTriggerFiredCalled: (called: Bool, triggerFired: Trigger?) = (called: false, triggerFired: nil)

    func customScheme(_ scheme: String) {
        self.spyCustomSchemeCalled = (called: true, scheme: scheme)
    }
    
    func triggerFired(_ trigger: Trigger) {
        self.spyTriggerFiredCalled = (called: true, triggerFired: trigger)
    }
}
