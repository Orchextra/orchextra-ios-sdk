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
        let actionInterface = ORCACtionInterfaceMock()
        let uid = EddystoneUID(namespace: "636f6b65634063656575", instance: "")
        let eddystoneRegion: ORCEddystoneRegion = ORCEddystoneRegion(
            uid: uid,
            code: "59631d973570a131308b4570",
            notifyOnEntry: true,
            notifyOnExit: true
        )
        
        let availableRegions = [eddystoneRegion]
        self.eddystoneProtocolParser = ORCEddystoneProtocolParser(
            requestWaitTime: 120,
            validatorInteractor: validatorActionInteractor,
            availableRegions: availableRegions,
            actionInterface: actionInterface
        )
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
        var frameType:frameType = ORCEddystoneDecoder.frameType(0x00)
        XCTAssertTrue(frameType == .uid)
        
        frameType = ORCEddystoneDecoder.frameType(0x10)
        XCTAssertTrue(frameType == .url)
        
        frameType = ORCEddystoneDecoder.frameType(0x20)
        XCTAssertTrue(frameType == .telemetry)
        
        frameType = ORCEddystoneDecoder.frameType(0x30)
        XCTAssertTrue(frameType == .eid)
        
        frameType = ORCEddystoneDecoder.frameType(0x50)
        XCTAssertTrue(frameType == .unknown)
    }
    
    func testUrlSchemePrefixParser() {
        var urlSchemePrefix: String = ORCEddystoneDecoder.urlSchemePrefix(0x00)
        XCTAssertTrue(urlSchemePrefix == ORCEddystoneConstants.urlSchemeTypeHttp_www)
        
        urlSchemePrefix = ORCEddystoneDecoder.urlSchemePrefix(0x01)
        XCTAssertTrue(urlSchemePrefix == ORCEddystoneConstants.urlSchemeTypeHttps_www)
        
        urlSchemePrefix = ORCEddystoneDecoder.urlSchemePrefix(0x02)
        XCTAssertTrue(urlSchemePrefix == ORCEddystoneConstants.urlSchemeTypeHttp)
        
        urlSchemePrefix = ORCEddystoneDecoder.urlSchemePrefix(0x03)
        XCTAssertTrue(urlSchemePrefix == ORCEddystoneConstants.urlSchemeTypeHttps)
        
        urlSchemePrefix = ORCEddystoneDecoder.urlSchemePrefix(0x04)
        XCTAssertTrue(urlSchemePrefix == "")
    }
    
    func testUrlEncodingParser() {
        var urlDecoded: String = ORCEddystoneDecoder.urlDecoded(0x00)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x01)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x02)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x03)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x04)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x05)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x06)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x07)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x08)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x09)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x0a)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x0b)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x0c)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x0d)
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x0e)
        XCTAssertTrue(urlDecoded == "")
        
        urlDecoded = ORCEddystoneDecoder.urlDecoded(0x1e)
        XCTAssertTrue(urlDecoded == "")
    }
    
    func testEddystoneUrlFrame() {
        let beaconServiceBytesArray:[UInt8] = [16, 0, 2, 50, 97,  5, 99,  99, 109, 51, 54, 49]
        let beaconServiceData:Data = Data(bytes: beaconServiceBytesArray, count:beaconServiceBytesArray.count)
        guard let peripheralId = self.peripheralId,
            let eddystoneProtocolParser = self.eddystoneProtocolParser,
            let rssi = self.rssi else {
                 XCTAssertNotNil("Some information is nil")
                return
        }
        
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
        
        guard let url:URL = beacon.url else {
            XCTAssertNotNil("Url information is nil")
            return
        }
        XCTAssertTrue(url == URL(string: "http://2a.biz/ccm361"))
    }
    
    func testEddystoneUIDFrame() {
        let beaconServiceBytesArray:[UInt8] = [0, 195, 99, 111, 107,  101, 99,  64, 99, 101, 101, 117, 16, 0, 0, 48, 57, 118, 0, 0]
        
        let beaconServiceData:Data = Data(bytes: beaconServiceBytesArray, count:beaconServiceBytesArray.count)
        guard let peripheralId = self.peripheralId,
            let eddystoneProtocolParser = self.eddystoneProtocolParser,
            let rssi = self.rssi else {
                 XCTAssertNotNil("Some information is nil")
                return
        }
        eddystoneProtocolParser.parse(beaconServiceData,
                                      peripheralId: peripheralId,
                                      rssi: rssi)
        
        let beaconList:[ORCEddystoneBeacon] = (eddystoneProtocolParser.parseServiceInformation())
        XCTAssert(beaconList.count == 1)
        let beacon:ORCEddystoneBeacon = beaconList[0]
        
        XCTAssertTrue(beacon.peripheralId == self.peripheralId)
        
        guard let uid = beacon.uid else {
            XCTAssertNotNil("Uid information is nil")
            return
        }
        XCTAssertNotNil(uid)
        XCTAssertNotNil(uid.namespace)
        XCTAssertNotNil(uid.instance)
        XCTAssertTrue(uid.namespace == "636f6b65634063656575")
        XCTAssertTrue(uid.instance == "100000303976")
        XCTAssertTrue(uid.uidCompossed == "636f6b65634063656575100000303976")
    }
    
    func testEddystoneTLMFrame() {
        let beaconServiceBytesArray:[UInt8] = [32, 0, 14, 48, 28, 48, 10, 122, 107, 56, 11, 247, 229, 149]
        let beaconServiceData:Data = Data(bytes: beaconServiceBytesArray, count:beaconServiceBytesArray.count)
        guard let peripheralId = self.peripheralId,
            let eddystoneProtocolParser = self.eddystoneProtocolParser,
            let rssi = self.rssi else {
                XCTAssertNotNil("Some information is nil")
                return
        }
        
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
        
        guard let telemetry:Telemetry = beacon.telemetry else {
            XCTAssertNotNil("Telemetry is nil")
            return
        }
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
        XCTAssertNotNil(telemetry.uptime)
    }
}
