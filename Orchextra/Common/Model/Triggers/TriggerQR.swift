//
//  TriggerScan.swift
//  Orchextra
//
//  Created by Judith Medina on 25/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class TriggerQR: Trigger {
    
    var triggerId: String = TriggerType.triggerQR
    let params: [String: Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {

        guard let type = externalValues["type"] as? String, type == TriggerType.triggerQR,
            let value = externalValues["value"] else {
                return nil
        }
    
        let params = ["type" : TriggerType.triggerQR,
                      "value" : value]
        
        return TriggerQR(params: params)
    }
    
    func urlParams() -> [String: Any] {
        return self.params
    }

}
