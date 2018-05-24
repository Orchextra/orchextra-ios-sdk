//
//  Region.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import CoreLocation

enum RegionType: String, Codable {
    case none
    case beacon_region
    case beacon
    case geofence
}

protocol Region {
    
    var code: String {get set}
    var notifyOnEntry: Bool? {get set}
    var notifyOnExit: Bool? {get set}
    var name: String {get set}
    
    static func region(from config: [String: Any]) -> Region?
    func prepareCLRegion() -> CLRegion?
    func convertRegionModelOrx() -> RegionModelOrx
}

struct RegionModelOrx: Codable {
    var type: RegionType
    var code: String
    var name: String
    
    var staytime: Int?
    
    var uuid: String?
    var major: Int?
    var minor: Int?
    
    func values(event: String) -> [String: Any] {
        
        if self.type == .geofence {
            var values = [
                "type": self.type.rawValue,
                "value": self.code,
                "event": event,
                "name": self.name]
            
            if let staytime = self.staytime { values["staytime"] = "\(staytime)" }
            return values
            
        } else if self.type == .beacon_region {
            var values = [
                "type": self.type.rawValue,
                "value": self.code,
                "event": event,
                "name": self.name]
            
            if let uuid = self.uuid { values["uuid"] = "\(uuid)" }
            if let major = self.major { values["major"] = "\(major)" }
            if let minor = self.minor { values["minor"] = "\(minor)" }
            
            return values
        }
        return [:]
    }
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
