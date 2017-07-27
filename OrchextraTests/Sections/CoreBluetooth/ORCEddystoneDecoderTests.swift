//
//  ORCEddystoneDecoderTests.swift
//  Orchextra
//
//  Created by Carlos Vicente on 27/7/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import XCTest
@testable import Orchextra

class ORCEddystoneDecoderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Frame type tests
    func testDecodeFrameTypeWithFrameUID() {
        let frameUID = UInt8(0x00)
        let frameType = ORCEddystoneDecoder.frameType(frameUID)
        
        XCTAssertTrue(frameType == .uid)
    }
    
    func testDecodeFrameTypeWithFrameUrl() {
        let frameUrl = UInt8(0x10)
        let frameType = ORCEddystoneDecoder.frameType(frameUrl)
        
        XCTAssertTrue(frameType == .url)
    }
    
    func testDecodeFrameTypeWithFrameTelemetry() {
        let frameTelemetry = UInt8(0x20)
        let frameType = ORCEddystoneDecoder.frameType(frameTelemetry)
        
        XCTAssertTrue(frameType == .telemetry)
    }
    
    func testDecodeFrameTypeWithFrameEid() {
        let frameEID = UInt8(0x30)
        let frameType = ORCEddystoneDecoder.frameType(frameEID)
        
        XCTAssertTrue(frameType == .eid)
    }
    
    func testDecodeFrameTypeWithInvalidType() {
        let frameInvalid = UInt8(0x50)
        let frameType = ORCEddystoneDecoder.frameType(frameInvalid)
        
        XCTAssertTrue(frameType == .unknown)
    }
}
