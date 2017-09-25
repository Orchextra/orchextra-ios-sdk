//
//  EddystoneBeacon.swift
//  EddystoneExample
//
//  Created by Carlos Vicente on 1/7/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation
import GIGLibrary

enum Proximity: String {
    case unknown
    case inmediate
    case near
    case far
}

class EddystoneBeacon {
    // MARK: Public properties
    var peripheralId: UUID?
    var rangingData: Int8? // Calibrated Tx power at 0 m
    var rssiBuffer: [Int8]?
    var url: URL?
    var uid: EddystoneUID?
    var eid: String?
    var telemetry: EddystoneTelemetry?
    var proximityTimer: Timer?
    var requestWaitTime: Int
    var hasBeenSent: Bool = false
    
    // MARK: Public computed properties
    var rssi: Double {
        var totalRssi: Double = 0
        guard let rssiBuffer = self.rssiBuffer else {
            return 0
        }
        
        for rssi in rssiBuffer {
            totalRssi += Double(rssi)
        }
        
        return totalRssi / Double(rssiBuffer.count)
    }
    
    var proximity: Proximity {
        let rangingDataUnWrapped = (self.rangingData != nil) ? self.rangingData! : 0
        return self.convertRSSIToProximity(self.rssi, rangingData:rangingDataUnWrapped)
    }
    
    // MARK: Public methods
    init(peripheralId: UUID, requestWaitTime: Int) {
        self.peripheralId = peripheralId
        self.requestWaitTime = requestWaitTime
    }
    
    func updateRssiBuffer(rssi: Int8) {
        let rssiBufferCount: Int = (self.rssiBuffer != nil) ? (self.rssiBuffer?.count)! : 0
        if rssi <= 0 {
            if rssiBufferCount == 0 {
                self.rssiBuffer = [Int8]()
                self.rssiBuffer?.insert(Int8(rssi), at: 0)
            } else if rssiBufferCount < EddystoneConstants.maxRssiBufferCount {
                self.rssiBuffer?.insert(Int8(rssi), at: 0)
            } else {
                self.rssiBuffer?.removeAll()
                self.rssiBuffer?.insert(Int8(rssi), at: 0)
            }
        }
    }
    
    func canBeSentToValidateAction() -> Bool {
        guard self.uid?.namespace != nil,
            self.uid?.instance != nil,
            self.url != nil,
            self.proximity != .unknown,
            (self.proximityTimer == nil) else { return false }
        self.hasBeenSent = true
        return true
    }
    
    func updateProximity(currentProximity: Proximity) -> EddystoneBeacon {
        if self.proximity == .unknown && currentProximity != .unknown {
           self.resetProximityTimer()
        } else {
            if (currentProximity != .unknown &&
                (currentProximity != self.proximity || (self.proximityTimer == nil))) {
                if self.hasBeenSent {
                    self.resetProximityTimer()
                    self.updateProximityTimer()
                }
            }
        }
        
        return self
    }
    
    func updateProximityTimer() {
        let timerTimeInterval = TimeInterval(self.requestWaitTime)
        self.proximityTimer = Timer.scheduledTimer(timeInterval: timerTimeInterval,
                                                   target: self,
                                                   selector: #selector(self.resetProximityTimer),
                                                   userInfo: nil,
                                                   repeats: false)
    }
    
    @objc func resetProximityTimer() {
        self.proximityTimer?.invalidate()
        self.proximityTimer = nil
    }
    
    // MARK: Private methods
    private func convertRSSIToProximity(_ rssi: Double, rangingData: Int8) -> Proximity {
        var rangingDataUpdated = rangingData
        
        if rangingData == 0 {
            rangingDataUpdated = EddystoneConstants.defaultRangingData
        }
        
        let distance: Double = self.calculateDistanceFromRSSI(rssi, rangingData: rangingDataUpdated)
        let proximity: Proximity  = self.convertDistanceFromRSSI(distance)
        
        return proximity
    }
    
    private func calculateDistanceFromRSSI(_ rssi: Double, rangingData: Int8) -> Double {
        var distance: Double = 0.0
        
        if rssi == 0 {
            distance = -1 // Distance not determined
        }
        
        let ratio: Double =  rssi / Double(rangingData)
        
        if ratio < 1 {
            distance = pow(ratio, 10)
        } else {
            distance = EddystoneConstants.coefficient1 * pow(ratio, EddystoneConstants.coefficient2) + EddystoneConstants.coefficient3
        }
        
        return distance
    }
    
    private func convertDistanceFromRSSI(_ distance: Double) -> Proximity {
        var proximity: Proximity = .unknown
        if distance > 0,
            distance <= 1 {
            proximity = .inmediate
        } else if distance > 1,
            distance <= 3 {
            
            proximity = .near
            
        } else if distance > 3 {
            proximity = .far
        }
        return proximity
    }
}
