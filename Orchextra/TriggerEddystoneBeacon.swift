//
//  TriggerEddystoneBeacon.swift
//  Orchextra
//
//  Created by Carlos Vicente on 12/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class TriggerEddystoneBeacon: Trigger {
    
    var triggerId: String = TriggerType.triggerEddystone
    let params: [String: Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerEddystone,
            let value = externalValues["value"],
            let namespace = externalValues["namespace"],
            let instance = externalValues["instance"],
            let distance = externalValues["distance"],
            let url = externalValues["url"] else {
                return nil
        }
        
        var params = ["type": TriggerType.triggerEddystone,
                      "value": value,
                      "namespace": namespace,
                      "instance": instance,
                      "distance": distance,
                      "url": url,
                      "phoneStatus": self.applicationState()
        ]
        
        if let batteryPercentage = externalValues["battery"] {
            params["battery"] = batteryPercentage
        }
        
        if let temperature = externalValues["temperature"] {
            params["temperature"] = temperature
        }
        
        return TriggerEddystoneBeacon(params: params)
    }
    
    func urlParams() -> [String: Any] {
        return self.params
    }
}
