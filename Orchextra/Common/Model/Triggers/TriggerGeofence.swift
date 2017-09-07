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
    let params: [String: Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerGeofence,
            let value = externalValues["value"],
            let event = externalValues["event"] else {
                return nil
        }
        
        let params = ["type" : type,
                      "value" : value,
                      "event": event,
                      "phoneStatus": self.applicationState()]
        
        return TriggerGeofence(params: params)
    }
    
    func urlParams() -> [String: Any] {
        return self.params
    }
    
}
