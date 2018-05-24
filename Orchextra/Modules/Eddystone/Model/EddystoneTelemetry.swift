//
//  EddystoneTelemetry.swift
//  Orchextra
//
//  Created by Carlos Vicente on 20/10/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

import Foundation

class EddystoneTelemetry: NSObject {
    var tlmVersion: String
    var batteryVoltage: Double
    var batteryPercentage: Double
    var temperature: Float
    var advertisingPDUcount: String
    var uptime: TimeInterval
    
    init(tlmVersion: String,
         batteryVoltage: Double,
         batteryPercentage: Double,
         temperature: Float,
         advertisingPDUcount: String,
         uptime: TimeInterval) {
        
        self.tlmVersion = tlmVersion
        self.batteryVoltage = batteryVoltage
        self.batteryPercentage = batteryPercentage
        self.temperature = temperature
        self.advertisingPDUcount = advertisingPDUcount
        self.uptime = uptime
    }
}
