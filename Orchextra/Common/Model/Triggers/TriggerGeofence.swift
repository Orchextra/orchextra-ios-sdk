//
//  File.swift
//  Orchextra
//
//  Created by Judith Medina on 06/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class TriggerGeofence: Trigger {
    
    var triggerId: String = TriggerType.triggerGeofence
    
    var name: String
    var event: String
    var value: String
    var staytime: Int
    
    init(name: String, value: String, staytime: Int, event: String) {
        self.name = name
        self.staytime = staytime
        self.event = event
        self.value = value
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerGeofence,
            let value = externalValues["value"] as? String,
            let event = externalValues["event"] as? String,
            let name = externalValues["name"] as? String,
            let stayTime = externalValues["staytime"] as? Int
            else { return nil }

        return TriggerGeofence(name: name, value: value, staytime: stayTime, event: event)
    }
    
    func urlParams() -> [String: Any] {
        let params = ["type": self.triggerId,
                      "value": self.value,
                      "event": self.event,
                      "phoneStatus": TriggerGeofence.applicationState()]
        
        return params
    }
    
    func logsParams() -> [String: Any] {
        return ["type": self.triggerId,
                "value": self.name,
                "event": self.event]
    }
}
