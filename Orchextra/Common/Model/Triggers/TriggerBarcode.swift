//
//  TriggerBarcode.swift
//  Orchextra
//
//  Created by Judith Medina on 25/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class TriggerBarcode: Trigger {
    
    var triggerId: String = TriggerType.triggerBarcode
    let params: [String: Any]
    
    init(params: [String: Any]) {
        self.params = params
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerBarcode,
            let value = externalValues["value"] else {
                return nil
        }
        
        let params = ["type": TriggerType.triggerBarcode,
                      "value": value]
        
        return TriggerBarcode(params: params)
    }
    
    func urlParams() -> [String: Any] {
        return self.params
    }
    
    func logsParams() -> [String: Any] {
        return self.params
    }
}
