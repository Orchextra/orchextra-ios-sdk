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
    case beacon_region
    case beacon
    case geofence
}

protocol Region {
    
    var code: String {get set}
    var notifyOnEntry: Bool? {get set}
    var notifyOnExit: Bool? {get set}
    var name: String? {get set}
    
    static func region(from config: [String: Any]) -> Region?
    func prepareCLRegion() -> CLRegion?
}

class RegionFactory {
    
    class func region(from config: [String: Any]) -> Region? {
        let regions = [
            Geofence.region(from: config),
            Beacon.region(from: config)
        ]
        
        // Returns the last action that is not nil
        return regions.reduce(nil) { $1 ?? $0 }
    }
}
