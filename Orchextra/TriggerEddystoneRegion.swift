//
//  TriggerEddystoneRegion.swift
//  Orchextra
//
//  Created by Carlos Vicente on 12/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class TriggerEddystoneRegion: Trigger {
    
    var triggerId: String = TriggerType.triggerEddystoneRegion
    let params: [String: Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerEddystoneRegion,
            let value = externalValues["value"],
            let namespace = externalValues["namespace"],
            let event = externalValues["event"] else {
                return nil
        }
        
        let params = ["type": TriggerType.triggerEddystoneRegion,
                      "value": value,
                      "namespace": namespace,
                      "event": event,
                      "phoneStatus": self.applicationState()]
        
        return TriggerEddystoneRegion(params: params)
    }
    
    func urlParams() -> [String: Any] {
        return self.params
    }
}
