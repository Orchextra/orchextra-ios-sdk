//
//  EddystoneDecoderTests.swift
//  Orchextra
//
//  Created by Carlos Vicente on 27/7/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import XCTest
@testable import Orchextra

class EddystoneDecoderTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Frame type tests
    func testDecodeFrameTypeWithFrameUID() {
        let frameUID = UInt8(0x00)
        let frameType = EddystoneDecoder.frameType(frameUID)
        
        XCTAssertTrue(frameType == .uid)
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .eid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithFrameUrl() {
        let frameUrl = UInt8(0x10)
        let frameType = EddystoneDecoder.frameType(frameUrl)
        
        XCTAssertTrue(frameType == .url)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .eid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithFrameTelemetry() {
        let frameTelemetry = UInt8(0x20)
        let frameType = EddystoneDecoder.frameType(frameTelemetry)
        
        XCTAssertTrue(frameType == .telemetry)
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .eid)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithFrameEid() {
        let frameEID = UInt8(0x30)
        let frameType = EddystoneDecoder.frameType(frameEID)
        
        XCTAssertTrue(frameType == .eid)
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .unknown)
    }
    
    func testDecodeFrameTypeWithInvalidType() {
        let frameInvalid = UInt8(0x50)
        let frameType = EddystoneDecoder.frameType(frameInvalid)
        
        XCTAssertTrue(frameType == .unknown)
        XCTAssertFalse(frameType == .url)
        XCTAssertFalse(frameType == .uid)
        XCTAssertFalse(frameType == .telemetry)
        XCTAssertFalse(frameType == .eid)
    }
    
    // MARK: Url scheme prefix tests
    func testUrlSchemePrefixTypeHttp_www() {
        let urlPrefixHttp_www = UInt8(0x00)
        let urlPrefix = EddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == EddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeHttps_www() {
        let urlPrefixHttp_www = UInt8(0x01)
        let urlPrefix = EddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == EddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeHttp() {
        let urlPrefixHttp_www = UInt8(0x02)
        let urlPrefix = EddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == EddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeHttps() {
        let urlPrefixHttp_www = UInt8(0x03)
        let urlPrefix = EddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == EddystoneConstants.urlSchemeTypeHttps)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == "")
    }
    
    func testUrlSchemePrefixTypeUnknown() {
        let urlPrefixHttp_www = UInt8(0x04)
        let urlPrefix = EddystoneDecoder.urlSchemePrefix(urlPrefixHttp_www)
        
        XCTAssertTrue(urlPrefix == "")
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttp_www)
        XCTAssertFalse(urlPrefix == EddystoneConstants.urlSchemeTypeHttps)
    }
    
    // MARK: Url scheme prefix tests
    func testDecodeUrlEncodingCom_Slash() {
        let urlEncodingComSlash = UInt8(0x00)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingComSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingOrg_Slash() {
        let urlEncodingOrgSlash = UInt8(0x01)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingOrgSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingEdu_Slash() {
        let urlEncodingEduSlash = UInt8(0x02)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingEduSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingNet_Slash() {
        let urlEncodingNetSlash = UInt8(0x03)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingNetSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingInfo_Slash() {
        let urlEncodingInfoSlash = UInt8(0x04)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingInfoSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingBiz_Slash() {
        let urlEncodingBizSlash = UInt8(0x05)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingBizSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingGov_Slash() {
        let urlEncodingGovSlash = UInt8(0x06)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingGovSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }

    func testDecodeUrlEncodingCom() {
        let urlEncodingCom = UInt8(0x07)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingCom)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingOrg() {
        let urlEncodingOrg = UInt8(0x08)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingOrg)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingEdu() {
        let urlEncodingEduSlash = UInt8(0x09)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingEduSlash)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingNet() {
        let urlEncodingNet = UInt8(0x0a)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingNet)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingInfo() {
        let urlEncodingInfo = UInt8(0x0b)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingInfo)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingBiz() {
        let urlEncodingBiz = UInt8(0x0c)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingBiz)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEncodingGov() {
        let urlEncodingGov = UInt8(0x0d)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingGov)
        
        XCTAssertTrue(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
        XCTAssertFalse(urlDecoded == "")
    }
    
    func testDecodeUrlEmptyEncoding() {
        let urlEncodingEmpty = UInt8(0x0e)
        let urlDecoded = EddystoneDecoder.urlDecoded(urlEncodingEmpty)
        
        XCTAssertTrue(urlDecoded == "")
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingGov_Slash)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingCom)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingOrg)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingEdu)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingNet)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingInfo)
        XCTAssertFalse(urlDecoded == EddystoneConstants.urlDecodingBiz)
    }
}
