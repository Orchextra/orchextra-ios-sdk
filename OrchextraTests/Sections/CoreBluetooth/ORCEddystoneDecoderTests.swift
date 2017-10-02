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
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .eid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithFrameUrl() {
        let frameUrl = UInt8(0x10)
        let frameType = ORCEddystoneDecoder.frameType(frameUrl)
        
        XCTAssertTrue(frameType == .url)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .eid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithFrameTelemetry() {
        let frameTelemetry = UInt8(0x20)
        let frameType = ORCEddystoneDecoder.frameType(frameTelemetry)
        
        XCTAssertTrue(frameType == .telemetry)
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .eid)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithFrameEid() {
        let frameEID = UInt8(0x30)
        let frameType = ORCEddystoneDecoder.frameType(frameEID)
        
        XCTAssertTrue(frameType == .eid)
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithInvalidType() {
        let frameInvalid = UInt8(0x50)
        let frameType = ORCEddystoneDecoder.frameType(frameInvalid)
        
        XCTAssertTrue(frameType == .unknown)
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .eid)
    }
    
    // MARK: Url scheme prefix tests
    func testUrlSchemePrefixTypeHttp_www() {
        let urlPrefixHttp_www = UInt8(0x00)
        let urlPrefix = ORCEddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeHttps_www() {
        let urlPrefixHttp_www = UInt8(0x01)
        let urlPrefix = ORCEddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeHttp() {
        let urlPrefixHttp_www = UInt8(0x02)
        let urlPrefix = ORCEddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeHttps() {
        let urlPrefixHttp_www = UInt8(0x03)
        let urlPrefix = ORCEddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeUnknown() {
        let urlPrefixHttp_www = UInt8(0x04)
        let urlPrefix = ORCEddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == "")
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == ORCEddystoneConstants.urlSchemeTypeHttps)
    }
    
    // MARK: Url scheme prefix tests
    func testDecodeUrlEncodingCom_Slash() {
        let urlEncodingComSlash = UInt8(0x00)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingComSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingOrg_Slash() {
        let urlEncodingOrgSlash = UInt8(0x01)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingOrgSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingEdu_Slash() {
        let urlEncodingEduSlash = UInt8(0x02)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingEduSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingNet_Slash() {
        let urlEncodingNetSlash = UInt8(0x03)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingNetSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingInfo_Slash() {
        let urlEncodingInfoSlash = UInt8(0x04)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingInfoSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingBiz_Slash() {
        let urlEncodingBizSlash = UInt8(0x05)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingBizSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingGov_Slash() {
        let urlEncodingGovSlash = UInt8(0x06)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingGovSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }

    func testDecodeUrlEncodingCom() {
        let urlEncodingCom = UInt8(0x07)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingCom)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingOrg() {
        let urlEncodingOrg = UInt8(0x08)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingOrg)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingEdu() {
        let urlEncodingEduSlash = UInt8(0x09)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingEduSlash)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingNet() {
        let urlEncodingNet = UInt8(0x0a)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingNet)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingInfo() {
        let urlEncodingInfo = UInt8(0x0b)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingInfo)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingBiz() {
        let urlEncodingBiz = UInt8(0x0c)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingBiz)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingGov() {
        let urlEncodingGov = UInt8(0x0d)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingGov)
        
        XCTAssertTrue(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEmptyEncoding() {
        let urlEncodingEmpty = UInt8(0x0e)
        let urlDecoded = ORCEddystoneDecoder.urlDecoded(urlEncodingEmpty)
        
        XCTAssertTrue(urlDecoded == "")
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == ORCEddystoneConstants.urlDecodingBiz)
    }
}
