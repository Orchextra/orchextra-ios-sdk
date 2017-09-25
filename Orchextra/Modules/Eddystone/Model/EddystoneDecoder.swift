//
//  EddystoneDecoder.swift
//  Orchextra
//
//  Created by Carlos Vicente on 18/7/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

enum FrameType {
    case unknown
    case uid
    case url
    case telemetry
    case eid
}

struct EddystoneDecoder {
    
    // MARK: Public (FrameType)
    static func frameType(_ fromBytes: UInt8) -> FrameType {
        var frameType: FrameType = .unknown
        switch fromBytes {
        case EddystoneConstants.frameUID:
            frameType = .uid
        case EddystoneConstants.frameURL:
            frameType = .url
        case EddystoneConstants.frameTelemetry:
            frameType = .telemetry
        case EddystoneConstants.frameEID:
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
        case EddystoneConstants.urlSchemePrefixHttp_www:
            urlScheme = EddystoneConstants.urlSchemeTypeHttp_www
        case EddystoneConstants.urlSchemePrefixHttps_www:
            urlScheme = EddystoneConstants.urlSchemeTypeHttps_www
        case EddystoneConstants.urlSchemePrefixHttp:
            urlScheme = EddystoneConstants.urlSchemeTypeHttp
        case EddystoneConstants.urlSchemePrefixHttps:
            urlScheme = EddystoneConstants.urlSchemeTypeHttps
        default:
            urlScheme = ""
        }
        
        return urlScheme
    }
    
    // MARK: Public (Url Decoded)
    static func urlDecoded(_ fromBytes: UInt8) -> String {
        var urlDecoded = ""
        
        switch fromBytes {
        case EddystoneConstants.urlEncodingCom_Slash:
            urlDecoded = EddystoneConstants.urlDecodingCom_Slash
        case EddystoneConstants.urlEncodingOrg_Slash:
            urlDecoded = EddystoneConstants.urlDecodingOrg_Slash
        case EddystoneConstants.urlEncodingEdu_Slash:
            urlDecoded = EddystoneConstants.urlDecodingEdu_Slash
        case EddystoneConstants.urlEncodingNet_Slash:
            urlDecoded = EddystoneConstants.urlDecodingNet_Slash
        case EddystoneConstants.urlEncodingInfo_Slash:
            urlDecoded = EddystoneConstants.urlDecodingInfo_Slash
        case EddystoneConstants.urlEncodingBiz_Slash:
            urlDecoded = EddystoneConstants.urlDecodingBiz_Slash
        case EddystoneConstants.urlEncodingGov_Slash:
            urlDecoded = EddystoneConstants.urlDecodingGov_Slash
        case EddystoneConstants.urlEncodingCom:
            urlDecoded = EddystoneConstants.urlDecodingCom
        case EddystoneConstants.urlEncodingOrg:
            urlDecoded = EddystoneConstants.urlDecodingOrg
        case EddystoneConstants.urlEncodingEdu:
            urlDecoded = EddystoneConstants.urlDecodingEdu
        case EddystoneConstants.urlEncodingNet:
            urlDecoded = EddystoneConstants.urlDecodingNet
        case EddystoneConstants.urlEncodingInfo:
            urlDecoded = EddystoneConstants.urlDecodingInfo
        case EddystoneConstants.urlEncodingBiz:
            urlDecoded = EddystoneConstants.urlDecodingBiz
        case EddystoneConstants.urlEncodingGov:
            urlDecoded = EddystoneConstants.urlDecodingGov
        default:
            urlDecoded = ""
        }
        
        return urlDecoded
    }

}
