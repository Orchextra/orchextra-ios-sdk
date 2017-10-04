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
    let params: [String: Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerBeaconRegion,
            let value = externalValues["value"],
            let event = externalValues["event"] else {
                return nil
        }
        
        let params = ["type": type,
                      "value": value,
                      "event": event,
                      "phoneStatus": self.applicationState()]
        
        return TriggerBeaconRegion(params: params)
    }
    
    func urlParams() -> [String: Any] {
        return self.params
    }
}
