//
//  TriggersManager.swift
//  Orchextra
//
//  Created by Carlos Vicente on 4/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

class TriggersManager {
    // MARK: - Attributes
    
    static let shared: TriggersManager = TriggersManager()
    var triggersFired: [TriggerFired]
    var triggerListMustBeUpdated = false
    
    init() {
        self.triggersFired = [TriggerFired]()
    }
    
    func add(trigger: TriggerFired) {
        self.triggersFired.append(trigger)
        self.triggerListMustBeUpdated = true
    }
    
    func retrieveTriggersFired() -> [TriggerFired] {
        return self.triggersFired
    }
}
