//
//  TriggerBeacon.swift
//  Orchextra
//
//  Created by Judith Medina on 04/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class TriggerBeacon: Trigger {
    
    var triggerId: String = TriggerType.triggerBeacon
    
    // Private
    var value: String
    var uuid: String
    var major: String
    var minor: String
    var proximity: String

    init(value: String, uuid: String, major: String, minor: String, proximity: String) {
        self.value = value
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.proximity = proximity
    }
    
    static func trigger(from externalValues: [String: Any]) -> Trigger? {
        
        guard let type = externalValues["type"] as? String, type == TriggerType.triggerBeacon,
            let value = externalValues["value"] as? String,
            let uuid = externalValues["uuid"] as? String,
            let major = externalValues["major"] as? Int,
            let minor = externalValues["minor"] as? Int,
            let proximity = externalValues["proximity"] as? String else {
                return nil
        }
        
        return TriggerBeacon(value: value, uuid: uuid, major: "\(major)", minor: "\(minor)", proximity: proximity)
    }
    
    func urlParams() -> [String: Any] {
        
        let plainCodeBeacon = "\(self.uuid)_\(self.major)_\(self.minor)"
        guard let md5code = plainCodeBeacon.md5 else {
            LogWarn("Error creating md5 code: \(plainCodeBeacon)")
            return [:]
        }
        
        let params = ["type": self.triggerId,
                      "value": md5code,
                      "distance": self.proximity,
                      "phoneStatus": TriggerBeaconRegion.applicationState()]
        
        return params
    }
    
    func logsParams() -> [String: Any] {
        return ["type": self.triggerId,
                "value": self.value,
                "uuid": self.uuid,
                "major": self.major,
                "minor": self.minor,
                "proximity": self.proximity]
    }
    
}
