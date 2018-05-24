//
//  TriggerBeaconRegion.swift
//  Orchextra
//
//  Created by Judith Medina on 04/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit

class TriggerBeaconRegion: Trigger {

    var triggerId: String = TriggerType.triggerBeaconRegion
    
    // Private
    var value: String
    var event: String
    
    init(value: String, event: String) {
        self.value = value
        self.event = event
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerBeaconRegion,
            let value = externalValues["value"] as? String,
            let event = externalValues["event"] as? String else {
                return nil
        }
        
        return TriggerBeaconRegion(value: value, event: event)
    }
    
    func urlParams() -> [String: Any] {
        let params = ["type": self.triggerId,
                      "value": self.value,
                      "event": self.event,
                      "phoneStatus": TriggerBeaconRegion.applicationState()]
        
        return params
    }
    
    func logsParams() -> [String: Any] {
        return self.urlParams()
    }
}
