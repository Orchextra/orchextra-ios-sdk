//
//  EddystoneBeacon.swift
//  EddystoneExample
//
//  Created by Carlos Vicente on 1/7/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation

@objc public enum proximity: Int {
    case unknown
    case inmediate
    case near
    case far
}

@objc public class ORCEddystoneBeacon: NSObject {
    // MARK: Public properties
    public var peripheralId: UUID?
    public var rangingData: Int8? // Calibrated Tx power at 0 m
    public var rssiBuffer: [Int8]?
    @objc public var url: URL?
    @objc public var uid: ORCEddystoneUID?
    public var eid:String?
    @objc public var telemetry: ORCEddystoneTelemetry?
    public var proximityTimer: Timer?
    public var requestWaitTime: Int
    var hasBeenSent: Bool = false
    
    // MARK: Public computed properties
    public var rssi:Double {
        get {
            var totalRssi: Double = 0
            guard let rssiBuffer = self.rssiBuffer else {
                return 0
            }
            
            for rssi in rssiBuffer {
                totalRssi += Double(rssi)
            }
            
            return totalRssi / Double(rssiBuffer.count)
        }
    }
    
    @objc public var proximity: proximity {
        get {
            let rangingDataUnWrapped = (self.rangingData != nil) ? self.rangingData! : 0
            return self.convertRSSIToProximity(self.rssi, rangingData:rangingDataUnWrapped)
        }
    }
    
    // MARK: Public methods
    @objc public init(peripheralId:UUID, requestWaitTime: Int) {
        self.peripheralId = peripheralId
        self.requestWaitTime = requestWaitTime
        
        super.init()
    }
    
    @objc public func updateRssiBuffer(rssi: Int8) {
        let rssiBufferCount: Int = (self.rssiBuffer != nil) ? (self.rssiBuffer?.count)! : 0
        
        if rssi <= 0 {
            if rssiBufferCount == 0 {
                self.rssiBuffer = [Int8]()
                self.rssiBuffer?.insert(Int8(rssi), at: 0)
            } else if rssiBufferCount < ORCEddystoneConstants.maxRssiBufferCount {
                self.rssiBuffer?.insert(Int8(rssi), at: 0)
            } else {
                self.rssiBuffer?.removeAll()
                self.rssiBuffer?.insert(Int8(rssi), at: 0)
            }
        }
    }
    
    public func canBeSentToValidateAction() -> Bool {
        guard self.uid?.namespace != nil,
            self.uid?.instance != nil,
            self.url != nil,
            self.proximity != .unknown,
            (self.proximityTimer == nil),
            !(self.hasBeenSent) else { return false }
        self.hasBeenSent = true
        return true
    }
    
    public func updateProximity(currentProximity: proximity) -> ORCEddystoneBeacon {
        if self.proximity == .unknown && currentProximity != .unknown {
            self.resetProximityTimer()
        } else {
            if currentProximity != .unknown &&
                (currentProximity != self.proximity || (self.proximityTimer == nil)) {
                if self.hasBeenSent {
                    self.resetProximityTimer()
                    self.updateProximityTimer()
                }
            }
        }
        
        return self
    }
    
    public func updateProximityTimer() {
        let timerTimeInterval = TimeInterval(self.requestWaitTime)
        self.proximityTimer = Timer.scheduledTimer(timeInterval: timerTimeInterval,
                                                   target: self,
                                                   selector: #selector(resetProximityTimer),
                                                   userInfo: nil,
                                                   repeats: false)
    }
    
    @objc public func resetProximityTimer() {
        self.proximityTimer?.invalidate()
        self.proximityTimer = nil
    }
    
    // MARK: Private methods
    private func convertRSSIToProximity(_ rssi: Double, rangingData: Int8) -> proximity {
        var rangingDataUpdated = rangingData
        
        if rangingData == 0 {
            rangingDataUpdated = ORCEddystoneConstants.defaultRangingData
        }
        
        let distance: Double = self.calculateDistanceFromRSSI(rssi, rangingData: rangingDataUpdated)
        let proximity:proximity  = self.convertDistanceFromRSSI(distance)
        
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
            distance = ORCEddystoneConstants.coefficient1 * pow(ratio, ORCEddystoneConstants.coefficient2) + ORCEddystoneConstants.coefficient3
        }
        
        return distance
    }
    
    private func convertDistanceFromRSSI(_ distance: Double) -> proximity {
        var proximity: proximity = .unknown
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
