//
//  StubResponse.swift
//  Orchextra
//
//  Created by Judith Medina on 16/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import OHHTTPStubs

class StubResponse {
    
    class func stubResponse(with json: String) -> OHHTTPStubsResponse {
        return OHHTTPStubsResponse(
            fileAtPath: OHPathForFile(json, StubResponse.self)!,
            statusCode: 200,
            headers: ["Content-Type": "application/json"])
    }
}
