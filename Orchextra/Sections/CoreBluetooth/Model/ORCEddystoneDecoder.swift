//
//  EddystoneDecoder.swift
//  Orchextra
//
//  Created by Carlos Vicente on 18/7/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

enum frameType {
    case unknown
    case uid
    case url
    case telemetry
    case eid
}

struct ORCEddystoneDecoder {
    
    // MARK: Public (FrameType)
    static func frameType(_ fromBytes: UInt8) -> frameType {
        var frameType: frameType = .unknown
        switch fromBytes {
        case ORCEddystoneConstants.frameUID:
            frameType = .uid
        case ORCEddystoneConstants.frameURL:
            frameType = .url
        case ORCEddystoneConstants.frameTelemetry:
            frameType = .telemetry
        case ORCEddystoneConstants.frameEID:
            frameType = .eid
        default:
            frameType = .unknown
        }
        
        return frameType
    }
    
    // MARK: Public (Url Scheme Prefix)
    static func urlSchemePrefix(_ fromBytes: UInt8) -> String {
        var urlScheme: String = ""
        switch fromBytes {
        case ORCEddystoneConstants.urlSchemePrefixHttp_www:
            urlScheme = ORCEddystoneConstants.urlSchemeTypeHttp_www
        case ORCEddystoneConstants.urlSchemePrefixHttps_www:
            urlScheme = ORCEddystoneConstants.urlSchemeTypeHttps_www
        case ORCEddystoneConstants.urlSchemePrefixHttp:
            urlScheme = ORCEddystoneConstants.urlSchemeTypeHttp
        case ORCEddystoneConstants.urlSchemePrefixHttps:
            urlScheme = ORCEddystoneConstants.urlSchemeTypeHttps
        default:
            urlScheme = ""
        }
        
        return urlScheme
    }
    
    // MARK: Public (Url Decoded)
    static func urlDecoded(_ fromBytes: UInt8) -> String {
        var urlDecoded = ""
        
        switch fromBytes {
        case ORCEddystoneConstants.urlEncodingCom_Slash:
            urlDecoded = ORCEddystoneConstants.urlDecodingCom_Slash
        case ORCEddystoneConstants.urlEncodingOrg_Slash:
            urlDecoded = ORCEddystoneConstants.urlDecodingOrg_Slash
        case ORCEddystoneConstants.urlEncodingEdu_Slash:
            urlDecoded = ORCEddystoneConstants.urlDecodingEdu_Slash
        case ORCEddystoneConstants.urlEncodingNet_Slash:
            urlDecoded = ORCEddystoneConstants.urlDecodingNet_Slash
        case ORCEddystoneConstants.urlEncodingInfo_Slash:
            urlDecoded = ORCEddystoneConstants.urlDecodingInfo_Slash
        case ORCEddystoneConstants.urlEncodingBiz_Slash:
            urlDecoded = ORCEddystoneConstants.urlDecodingBiz_Slash
        case ORCEddystoneConstants.urlEncodingGov_Slash:
            urlDecoded = ORCEddystoneConstants.urlDecodingGov_Slash
        case ORCEddystoneConstants.urlEncodingCom:
            urlDecoded = ORCEddystoneConstants.urlDecodingCom
        case ORCEddystoneConstants.urlEncodingOrg:
            urlDecoded = ORCEddystoneConstants.urlDecodingOrg
        case ORCEddystoneConstants.urlEncodingEdu:
            urlDecoded = ORCEddystoneConstants.urlDecodingEdu
        case ORCEddystoneConstants.urlEncodingNet:
            urlDecoded = ORCEddystoneConstants.urlDecodingNet
        case ORCEddystoneConstants.urlEncodingInfo:
            urlDecoded = ORCEddystoneConstants.urlDecodingInfo
        case ORCEddystoneConstants.urlEncodingBiz:
            urlDecoded = ORCEddystoneConstants.urlDecodingBiz
        case ORCEddystoneConstants.urlEncodingGov:
            urlDecoded = ORCEddystoneConstants.urlDecodingGov
        default:
            urlDecoded = ""
        }
        
        return urlDecoded
    }

}
