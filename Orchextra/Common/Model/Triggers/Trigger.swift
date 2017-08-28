//
//  Trigger.swift
//  Orchextra
//
//  Created by Judith Medina on 25/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

struct TriggerType {
    static let triggerBeacon = "beacon"
    static let triggerBeaconRegion = "beacon_region"
    static let triggerGeofence = "geofence"
    static let triggerQR = "qr"
    static let triggerBarcode = "barcode"
    static let triggerIR = "vuforia"
}

public protocol Trigger {
    
    var triggerId: String {get set}
    
    static func trigger(from
        externalValues: [String: Any]) -> Trigger?
    func urlParams() -> [String: Any]
}

class TriggerFactory {
    
    class func trigger(from externalValues: [String: Any]) -> Trigger? {
         let triggers = [
            TriggerQR.trigger(from: externalValues),
            TriggerBarcode.trigger(from: externalValues)]
        
        return triggers.reduce(nil) { $1 ?? $0 }

    }
}
