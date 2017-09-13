//
//  Region.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import CoreLocation

enum RegionType: String {
    case none
    case beacon_region = "beacon_region"
    case geofence = "geofence"
}

protocol Region {
    
    var code: String {get set}
    var notifyOnEntry: Bool? {get set}
    var notifyOnExit: Bool? {get set}
    
    static func region(from config: [String: Any]) -> Region?
    func prepareCLRegion() -> CLRegion?
}

class RegionFactory {
    
    
    class func geofences(from config: [String: Any]) -> Region? {
        guard let trigger = Geofence.region(from: config) else {
            return nil
        }
        return trigger
    }
    
    class func beacon(from config: [String: Any]) -> Region? {
        guard let trigger = Beacon.region(from: config) else {
            return nil
        }
        return trigger
    }
}
