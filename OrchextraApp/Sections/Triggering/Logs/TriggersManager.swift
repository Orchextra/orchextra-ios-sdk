//
//  TriggersManager.swift
//  Orchextra
//
//  Created by Carlos Vicente on 4/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

class TriggersManager {
    //MARK: - Attributes
    
    static let shared: TriggersManager = TriggersManager()
    var triggersFired: [Trigger]
    var triggerListMustBeUpdated = false
    
    init() {
        self.triggersFired = [Trigger]()
    }
    
    func add(trigger: Trigger) {
        self.triggersFired.append(trigger)
        self.triggerListMustBeUpdated = true
    }
    
    func retrieveTriggersFired() -> [Trigger] {
        return self.triggersFired
    }
}
