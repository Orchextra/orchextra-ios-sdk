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
    static let triggerEddystone = "eddystone"
    static let triggerEddystoneRegion = "eddystone_region"
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
    
    static func applicationState() -> String
}

extension Trigger {
    
    static func applicationState() -> String {
        let state = UIApplication.shared.applicationState
        switch state {
            case .active: return "foreground"
            case .background: return "background"
            case .inactive: return "inactive"
        }
    }
}

class TriggerFactory {
    
    class func trigger(from externalValues: [String: Any]) -> Trigger? {
         let triggers = [
            TriggerQR.trigger(from: externalValues),
            TriggerBarcode.trigger(from: externalValues),
            TriggerGeofence.trigger(from: externalValues),
            TriggerBeaconRegion.trigger(from: externalValues),
            TriggerEddystoneRegion.trigger(from: externalValues),
            TriggerEddystoneBeacon.trigger(from: externalValues)
        ]
        
        return triggers.reduce(nil) { $1 ?? $0 }
    }
}
