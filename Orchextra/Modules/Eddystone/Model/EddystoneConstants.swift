//
//  EddystoneConstants.swift
//  EddystoneExample
//
//  Created by Carlos Vicente on 11/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

struct EddystoneConstants {
        
    // EDDYSTONE PROTOCOL
    static let serviceUUID: String = "FEAA"
    
    // BYTES MANAGEMENT
    static let bytesToStringConverterRadix: Int    = 16
    
    // TX POWER
    static let defaultRangingData: Int8    = -65
    
    // URL SCHEME
    static let urlSchemeTypeHttp_www: String = "http://www."
    static let urlSchemeTypeHttps_www: String = "https://www."
    static let urlSchemeTypeHttp: String = "http://"
    static let urlSchemeTypeHttps: String = "https://"
    
    // URL DECODED
    static let urlDecodingCom_Slash: String = ".com/"
    static let urlDecodingOrg_Slash: String = ".org/"
    static let urlDecodingEdu_Slash: String = ".edu/"
    static let urlDecodingNet_Slash: String = ".net/"
    static let urlDecodingInfo_Slash: String = ".info/"
    static let urlDecodingBiz_Slash: String = ".biz/"
    static let urlDecodingGov_Slash: String = ".gov/"
    static let urlDecodingCom: String = ".com"
    static let urlDecodingOrg: String = ".org"
    static let urlDecodingEdu: String = ".edu"
    static let urlDecodingNet: String = ".net"
    static let urlDecodingInfo: String = ".info"
    static let urlDecodingBiz: String = ".biz"
    static let urlDecodingGov: String = ".gov"
    
    // FRAME TYPE
    static let frameUID: UInt8 = 0x00
    static let frameURL: UInt8 = 0x10
    static let frameTelemetry: UInt8  = 0x20
    static let frameEID: UInt8  = 0x30
    
    // URL PREFIX
    static let urlSchemePrefixHttp_www: UInt8  = 0x00
    static let urlSchemePrefixHttps_www: UInt8  = 0x01
    static let urlSchemePrefixHttp: UInt8  = 0x02
    static let urlSchemePrefixHttps: UInt8  = 0x03
    
    // URL ENCODED
    static let urlEncodingCom_Slash: UInt8  = 0x00
    static let urlEncodingOrg_Slash: UInt8  = 0x01
    static let urlEncodingEdu_Slash: UInt8  = 0x02
    static let urlEncodingNet_Slash: UInt8  = 0x03
    static let urlEncodingInfo_Slash: UInt8  = 0x04
    static let urlEncodingBiz_Slash: UInt8  = 0x05
    static let urlEncodingGov_Slash: UInt8  = 0x06
    static let urlEncodingCom: UInt8  = 0x07
    static let urlEncodingOrg: UInt8  = 0x08
    static let urlEncodingEdu: UInt8  = 0x09
    static let urlEncodingNet: UInt8  = 0x0a
    static let urlEncodingInfo: UInt8  = 0x0b
    static let urlEncodingBiz: UInt8  = 0x0c
    static let urlEncodingGov: UInt8  = 0x0d
    
    // TRACE CONSTANTS
    static let frameTypePosition: Int = 0
    static let rangingDataPosition: Int = 1
    
    static let uidMinimiumSize: Int = 18
    static let uidNamespaceInitialPosition: Int = 2
    static let uidNamespaceEndPosition: Int = 12
    static let uidInstanceInitialPosition: Int = 12
    static let uidInstanceEndPosition: Int = 18
    
    static let urlSchemePrefixPosition: Int = 2
    static let urlHostInitialPosition: Int = 3
    
    static let eidInitialPosition: Int = 2
    
    static let tlmVersionInitialPosition: Int = 1
    static let tlmVersionEndPosition: Int = 2
    static let tlmBatteryInitialPosition: Int = 2
    static let tlmBatteryEndPosition: Int = 4
    static let tlmTemperatureFixedInitialPosition: Int = 4
    static let tlmTemperatureFixedEndPosition: Int = 5
    static let tlmTemperatureFractionalInitialPosition: Int = 5
    static let tlmTemperatureFractionalEndPosition: Int = 6
    static let tlmAdvertisingPDUCountInitialPosition: Int = 6
    static let tlmAdvertisingPDUCountEndPosition: Int = 10
    static let tlmTimeOnSincePowerOnInitialPosition: Int = 10
    static let tlmTimeOnSincePowerOnEndPosition: Int = 13

    // UNITS CONVERSION
    static let miliVoltsToVolts: Double = 1000.0
    static let temperature8pointeNotation: Float  = 256.0
    
    // DISTANCE COEFICIENTS
    static let coefficient1: Double = 0.89976
    static let coefficient2: Double = 7.7095
    static let coefficient3: Double = 0.111
    
    // RSSI BUFFER 
    static let maxRssiBufferCount: Int    = 20
    
    // CORE BLUETOOTH Timers
    static let timeToStopScanner: Int    = 30
    static let timeToStartScannerBackground: Int    = 180
    static let timeToStartScanner: Int    = 300
    
    // BACKGROUND TASKS IDENTIFIERS
    static let backgrond_task_start_scanner: String = "start_scanner_task"
    static let backgrond_task_stop_scanner: String = "stop_scanner_task"
    static let coreBluetoothStart: String = "core_bluetooth_start"
    static let coreBluetoothStop: String = "core_bluetooth_stop"
    
    // REQUEST WAIT TIME
    static let defaultRequestWaitTime: Int    = 0
}
