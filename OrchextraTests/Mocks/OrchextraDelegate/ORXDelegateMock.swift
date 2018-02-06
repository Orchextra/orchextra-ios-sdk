//
//  ORXDelegateMock.swift
//  OrchextraTests
//
//  Created by Carlos Vicente on 22/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra
@testable import Orchextra
import GIGLibrary

class ORXDelegateMock: ORXDelegate {
    func bindDidCompleted(result: Result<[AnyHashable: Any], Error>) {
        
    }
    
    var spyCustomSchemeCalled: (called: Bool, scheme: String?) = (called: false, scheme: nil)
    var spyTriggerFiredCalled: (called: Bool, triggerFired: Trigger?) = (called: false, triggerFired: nil)
    var spyBindDidCompletedCalled: (called: Bool, bindValues: [AnyHashable : Any]?) = (called: false, bindValues: nil)

    func customScheme(_ scheme: String) {
        self.spyCustomSchemeCalled = (called: true, scheme: scheme)
    }
    
    func triggerFired(_ trigger: Trigger) {
        self.spyTriggerFiredCalled = (called: true, triggerFired: trigger)
    }
    
    func bindDidCompleted(bindValues: [AnyHashable :Any]) {
        self.spyBindDidCompletedCalled = (called: true, bindValues: bindValues)
    }
}
