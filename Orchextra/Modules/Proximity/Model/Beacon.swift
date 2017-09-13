//
//  Beacon.swift
//  Orchextra
//
//  Created by Judith Medina on 12/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

import CoreLocation
import GIGLibrary

struct Beacon: Region {

    // Attribute Region
    
    var code: String
    var notifyOnEntry: Bool?
    var notifyOnExit: Bool?
    
    var uuid: UUID
    var major: Int?
    var minor: Int?
    var currentProximity: CLProximity?
    
    init(code: String,
         notifyOnEntry: Bool,
         notifyOnExit: Bool,
         uuid: UUID,
         major: Int?,
         minor: Int?) {
     
        self.code = code
        self.notifyOnEntry = notifyOnEntry
        self.notifyOnExit = notifyOnExit
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
    
    static func region(from config: [String : Any]) -> Region? {
        
        guard let code = config["code"] as? String,
            let notifyOnEntry = config["notifyOnEntry"] as? Bool,
            let notifyOnExit = config["notifyOnExit"] as? Bool,
            let uuid = config["uuid"] as? String,
            let uuidRegion = UUID(uuidString: uuid)
            else { return nil }
    
        return Beacon(code: code,
                        notifyOnEntry: notifyOnEntry,
                        notifyOnExit: notifyOnExit,
                        uuid: uuidRegion,
                        major: config["major"] as? Int,
                        minor: config["minor"] as? Int)

    }
    
    func prepareCLRegion() -> CLRegion? {
        
        let beacon: CLBeaconRegion?
        
        if let major = self.major, let minor = self.minor {
            beacon = CLBeaconRegion(proximityUUID: self.uuid,
                                  major: UInt16(major),
                                  minor: UInt16(minor),
                                  identifier: self.code)
            
        } else if let major = self.major {
            beacon = CLBeaconRegion(proximityUUID: self.uuid,
                                  major: UInt16(major),
                                  identifier: self.code)
        } else {
            beacon = CLBeaconRegion(proximityUUID: self.uuid,
                                  identifier: self.code)
        }
        
        beacon?.notifyEntryStateOnDisplay = true
        if let notifyOnExit = self.notifyOnExit { beacon?.notifyOnExit = notifyOnExit }
        if let notifyOnEntry = self.notifyOnEntry { beacon?.notifyOnEntry = notifyOnEntry }
        return beacon
    }
    
}
