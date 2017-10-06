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

class Beacon: Region {
    
    // Attribute Region
    
    var code: String
    var notifyOnEntry: Bool?
    var notifyOnExit: Bool?
    var name: String?

    // Attribute Beacon
    
    var uuid: UUID
    var major: Int?
    var minor: Int?
    var currentProximity: CLProximity?
    
    // Private attributes
    
    fileprivate var canUseImmediate = true
    fileprivate var canUseNear = true
    fileprivate var canUseFar = true
    
    fileprivate var immediateTimer: Timer?
    fileprivate var nearTimer: Timer?
    fileprivate var farTimer: Timer?

    init(code: String,
         notifyOnEntry: Bool,
         notifyOnExit: Bool,
         uuid: UUID,
         major: Int?,
         minor: Int?,
         name: String?) {
     
        self.code = code
        self.notifyOnEntry = notifyOnEntry
        self.notifyOnExit = notifyOnExit
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.name = name
    }
    
    // MARK: -
    
    static func region(from config: [String: Any]) -> Region? {
        
        guard
            let type = config["type"] as? String,
            type == RegionType.beacon_region.rawValue,
            let code = config["code"] as? String,
            let notifyOnEntry = config["notifyOnEntry"] as? Bool,
            let notifyOnExit = config["notifyOnExit"] as? Bool,
            let name = config["name"] as? String,
            let uuid = config["uuid"] as? String,
            let uuidRegion = UUID(uuidString: uuid)
            else { return nil }
    
        return Beacon(code: code,
                        notifyOnEntry: notifyOnEntry,
                        notifyOnExit: notifyOnExit,
                        uuid: uuidRegion,
                        major: config["major"] as? Int,
                        minor: config["minor"] as? Int,
                        name: name)
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
    
    func outputValues(type: RegionType, event: String?) -> [String: Any] {
        
        // Output for beacons
        var beacon: [String: Any] =
            [
             "value": self.code,
             "uuid": self.uuid.uuidString]
        
        if let major = self.major { beacon["major"] = major }
        if let minor = self.minor { beacon["minor"] = minor }
        
        if type == .beacon {
            beacon["type"] = RegionType.beacon.rawValue
            if let proximity = self.currentProximity { beacon["proximity"] = proximity.name() }
        } else {
            beacon["type"] = RegionType.beacon_region.rawValue
            beacon["event"] = event
        }
        
        return beacon
    }
    
    func isEqualtoCLBeacon(clBeacon: CLBeacon) -> Bool {
        guard let major = self.major, NSNumber(value: major) == clBeacon.major,
            let minor = self.minor, NSNumber(value: minor) == clBeacon.minor,
            self.uuid ==  clBeacon.proximityUUID else {
            return false
        }
        return true
    }
}

// MARK: - Timer

extension Beacon {
    
    func newProximity(proximity: CLProximity) -> Bool {
        if canUseProximity(proximity: proximity) && proximity != .unknown {
            self.usingProximity(proximity: proximity)
            self.currentProximity = proximity
            return true
        }
        return false
    }
    
    func canUseProximity(proximity: CLProximity) -> Bool {
        switch proximity {
        case .immediate:
            return self.canUseImmediate
        case .near:
            return self.canUseNear
        case .far:
            return self.canUseFar
        case .unknown:
            return false
        }
    }
    
    func changeProximityState(proximity: CLProximity) {
        switch proximity {
        case .immediate:
            self.canUseImmediate = !self.canUseImmediate
        case .near:
            self.canUseNear = !self.canUseNear
        case .far:
            self.canUseFar = !self.canUseFar
        case .unknown:
            break
        }
    }
    
    func usingProximity(proximity: CLProximity) {
        switch proximity {
        case .immediate:
            self.createTimerProximity(timer: self.immediateTimer, proximity: proximity)
        case .near:
            self.createTimerProximity(timer: self.nearTimer, proximity: proximity)
        case .far:
            self.createTimerProximity(timer: self.farTimer, proximity: proximity)
        case .unknown: break
        }
    }
    
    func createTimerProximity(timer: Timer?, proximity: CLProximity) {
        if let proximityTimer = timer {
            self.invalidateTimer(timer: proximityTimer)
        }
       
        let requestWaitTime = 120.0
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: requestWaitTime, repeats: false, block: { _ in
                self.changeProximityState(proximity: proximity)
            })
        } else {
            // TODO: Fallback on earlier versions
        }
        self.changeProximityState(proximity: proximity)
    }
    
    private func invalidateTimer(timer: Timer) {
        timer.invalidate()
    }
}

extension CLProximity {
    func name() -> String {
        switch self {
        case .immediate: return "immediate"
        case .near:      return "near"
        case .far:       return "far"
        case .unknown:   return "unknown"
        }
    }
}
