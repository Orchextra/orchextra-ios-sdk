//
//  EddystoneProtocolParserTests.swift
//  EddystoneExample
//
//  Created by Carlos Vicente on 11/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import XCTest
@testable import Orchextra

class EddystoneProtocolParserTests: XCTestCase {
    
     var eddystoneProtocolParser: ORCEddystoneProtocolParser?
     var peripheralId:UUID?
     var rssi: Int?
    
    override func setUp() {
        super.setUp()
        
        let validatorActionInteractor = ORCValidatorActionInterator()
        eddystoneProtocolParser = ORCEddystoneProtocolParser(requestWaitTime: 120, validatorInteractor: validatorActionInteractor)
        peripheralId = UUID(uuidString:"4B9F9513-2877-77B1-5B9F-A198CCF814DF")
        rssi = -32
    }
    
    override func tearDown() {
        eddystoneProtocolParser = nil
        peripheralId = nil
        rssi = -1
        
        super.tearDown()
    }
    
    func testFrameTypeParser() {
        if let eddystoneParser = self.eddystoneProtocolParser {
            var frameType:frameType = eddystoneParser.frameType(0x00)
            XCTAssertTrue(frameType == .uid)
            
            frameType = eddystoneParser.frameType(0x10)
            XCTAssertTrue(frameType == .url)
            
            frameType = eddystoneParser.frameType(0x20)
            XCTAssertTrue(frameType == .telemetry)
            
            frameType = eddystoneParser.frameType(0x30)
            XCTAssertTrue(frameType == .eid)
            
            frameType = eddystoneParser.frameType(0x50)
            XCTAssertTrue(frameType == .unknown)
        }
    }
    
    func testUrlSchemePrefixParser() {
        if let eddystoneParser = self.eddystoneProtocolParser {
            var urlSchemePrefix: String = eddystoneParser.urlSchemePrefix(0x00)
            XCTAssertTrue(urlSchemePrefix == EddystoneConstants.urlSchemeTypeHttp_www)
            
            urlSchemePrefix = eddystoneParser.urlSchemePrefix(0x01)
            XCTAssertTrue(urlSchemePrefix == EddystoneConstants.urlSchemeTypeHttps_www)
            
            urlSchemePrefix = eddystoneParser.urlSchemePrefix(0x02)
            XCTAssertTrue(urlSchemePrefix == EddystoneConstants.urlSchemeTypeHttp)
            
            urlSchemePrefix = eddystoneParser.urlSchemePrefix(0x03)
            XCTAssertTrue(urlSchemePrefix == EddystoneConstants.urlSchemeTypeHttps)
            
            urlSchemePrefix = eddystoneParser.urlSchemePrefix(0x04)
            XCTAssertTrue(urlSchemePrefix == "")
        }
    }
    
    func testUrlEncodingParser() {
        if let eddystoneParser = self.eddystoneProtocolParser {
            var urlDecoded: String = eddystoneParser.urlDecoded(0x00)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
            
            urlDecoded = eddystoneParser.urlDecoded(0x01)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
            
            urlDecoded = eddystoneParser.urlDecoded(0x02)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
            
            urlDecoded = eddystoneParser.urlDecoded(0x03)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
            
            urlDecoded = eddystoneParser.urlDecoded(0x04)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
            
            urlDecoded = eddystoneParser.urlDecoded(0x05)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
            
            urlDecoded = eddystoneParser.urlDecoded(0x06)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
            
            urlDecoded = eddystoneParser.urlDecoded(0x07)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingCom)
            
            urlDecoded = eddystoneParser.urlDecoded(0x08)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingOrg)
            
            urlDecoded = eddystoneParser.urlDecoded(0x09)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingEdu)
            
            urlDecoded = eddystoneParser.urlDecoded(0x0a)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingNet)
            
            urlDecoded = eddystoneParser.urlDecoded(0x0b)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingInfo)
            
            urlDecoded = eddystoneParser.urlDecoded(0x0c)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingBiz)
            
            urlDecoded = eddystoneParser.urlDecoded(0x0d)
            XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingGov)
            
            urlDecoded = eddystoneParser.urlDecoded(0x0e)
            XCTAssertTrue(urlDecoded == "")
            
            urlDecoded = eddystoneParser.urlDecoded(0x1e)
            XCTAssertTrue(urlDecoded == "")
        }
    }
    
    func testEddystoneUrlFrame() {
        let beaconServiceBytesArray:[UInt8] = [16, 0, 2, 50, 97,  5, 99,  99, 109, 51, 54, 49]
        let beaconServiceData:Data = Data(bytes: beaconServiceBytesArray, count:beaconServiceBytesArray.count)
        if let peripheralId = self.peripheralId,
            let eddystoneProtocolParser = self.eddystoneProtocolParser,
            let rssi = self.rssi {
            
            eddystoneProtocolParser.parse(beaconServiceData,
                                          peripheralId: peripheralId,
                                          rssi: rssi)
            let currentBeacon = ORCEddystoneBeacon(peripheralId: peripheralId,
                                                   requestWaitTime: 30)
            let uid = EddystoneUID(namespace: "636f6b65634063656575", instance: "")
            currentBeacon.uid = uid
            eddystoneProtocolParser.currentBeacon = currentBeacon
            let beaconList:[ORCEddystoneBeacon] = (eddystoneProtocolParser.parseServiceInformation())
            XCTAssert(beaconList.count == 1)
            let beacon:ORCEddystoneBeacon = beaconList[0]
            
            XCTAssertTrue(beacon.peripheralId == self.peripheralId)
            
            if let url:URL = beacon.url {
                XCTAssertTrue(url == URL(string: "http://2a.biz/ccm361"))
            }
        }
    }
    
    func testEddystoneUIDFrame() {
        let beaconServiceBytesArray:[UInt8] = [0, 195, 99, 111, 107,  101, 99,  64, 99, 101, 101, 117, 16, 0, 0, 48, 57, 118, 0, 0]
        
        let beaconServiceData:Data = Data(bytes: beaconServiceBytesArray, count:beaconServiceBytesArray.count)
        if let peripheralId = self.peripheralId,
            let eddystoneProtocolParser = self.eddystoneProtocolParser,
            let rssi = self.rssi {
            eddystoneProtocolParser.parse(beaconServiceData,
                                          peripheralId: peripheralId,
                                          rssi: rssi)
            
            let beaconList:[ORCEddystoneBeacon] = (eddystoneProtocolParser.parseServiceInformation())
            XCTAssert(beaconList.count == 1)
            let beacon:ORCEddystoneBeacon = beaconList[0]
            
            XCTAssertTrue(beacon.peripheralId == self.peripheralId)
            
            if let uid:EddystoneUID = beacon.uid {
                XCTAssertNotNil(uid)
                XCTAssertNotNil(uid.namespace)
                XCTAssertNotNil(uid.instance)
                XCTAssertTrue(uid.namespace == "636f6b65634063656575")
                XCTAssertTrue(uid.instance == "100000303976")
                XCTAssertTrue(uid.uidCompossed == "636f6b65634063656575100000303976")
            }
        }
    }
    
    func testEddystoneTLMFrame() {
        let beaconServiceBytesArray:[UInt8] = [32, 0, 14, 48, 28, 48, 10, 122, 107, 56, 11, 247, 229, 149]
        let beaconServiceData:Data = Data(bytes: beaconServiceBytesArray, count:beaconServiceBytesArray.count)
        if let peripheralId = self.peripheralId,
            let eddystoneProtocolParser = self.eddystoneProtocolParser,
            let rssi = self.rssi {
            let currentBeacon = ORCEddystoneBeacon(peripheralId: peripheralId,
                                                    requestWaitTime: 30)
            let uid = EddystoneUID(namespace: "636f6b65634063656575", instance: "")
            currentBeacon.uid = uid
            eddystoneProtocolParser.currentBeacon = currentBeacon
            eddystoneProtocolParser.parse(beaconServiceData,
                                          peripheralId: peripheralId,
                                          rssi: rssi)

            let beaconList:[ORCEddystoneBeacon] = eddystoneProtocolParser.parseServiceInformation()
            
            XCTAssert(beaconList.count == 1)
            
            let beacon:ORCEddystoneBeacon = beaconList[0]
            
            XCTAssertTrue(beacon.peripheralId == self.peripheralId)
            
            if let telemetry:Telemetry = beacon.telemetry {
                let timeInterval: TimeInterval = 200795392
                XCTAssertNotNil(telemetry)
                XCTAssertNotNil(telemetry.tlmVersion)
                XCTAssertNotNil(telemetry.batteryVoltage)
                XCTAssertNotNil(telemetry.temperature)
                XCTAssertNotNil(telemetry.advertisingPDUcount)
                XCTAssertNotNil(telemetry.uptime)
                XCTAssertTrue(telemetry.tlmVersion == "0")
                XCTAssertTrue(telemetry.batteryVoltage == 3632)
                XCTAssertTrue(telemetry.temperature == 28.1875)
                XCTAssertTrue(telemetry.advertisingPDUcount == "175795000")
                XCTAssertTrue(telemetry.uptime == timeInterval)
            }
        }
    }
}
