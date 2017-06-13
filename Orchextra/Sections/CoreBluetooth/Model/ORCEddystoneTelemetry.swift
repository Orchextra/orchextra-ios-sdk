//
//  ORCEddystoneTelemetry.swift
//  Orchextra
//
//  Created by Carlos Vicente on 20/10/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation

@objc public class Telemetry: NSObject {
    
    public var tlmVersion: String
    public var batteryVoltage: Double
    public var batteryPercentage: Double
    public var temperature: Float
    public var advertisingPDUcount: String
    public var uptime: TimeInterval
    
    public init(tlmVersion: String,
                batteryVoltage: Double,
                batteryPercentage: Double,
                temperature: Float,
                advertisingPDUcount:String,
                uptime: TimeInterval) {
        
        self.tlmVersion = tlmVersion
        self.batteryVoltage = batteryVoltage
        self.batteryPercentage = batteryPercentage
        self.temperature = temperature
        self.advertisingPDUcount = advertisingPDUcount
        self.uptime = uptime
    }
}
