//
//  AuthenticationInteractorTests.swift
//  OrchextraTests
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Nimble
import GIGLibrary
@testable import Orchextra

class AuthenticationInteractorTests: XCTestCase {
    
    var interactor: AuthInteractor!
    var sessionMock: SessionMock!
    
    override func setUp() {
        super.setUp()
        
        self.sessionMock = SessionMock()
        
        self.interactor = AuthInteractor(
            service: AuthenticationService(),
            session: self.sessionMock)
    }
    
    override func tearDown() {
        self.interactor = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func test_accessToken_whenAPIWhenResponseSuccess() {
        
        // ARRANGE
        self.sessionMock.apiKey = "key"
        self.sessionMock.apiSecret = "secret"
        self.sessionMock.accesstoken = nil
        
        let _ = stub(condition: isPath("/security/token"), response: { _ in
            return StubResponse.stubResponse(with: "accesstoken_ok.json")
        })
        
        // ACT
        waitUntil(timeout: 10) { done in
            self.interactor.accessToken { accesstoken in
                expect(accesstoken).to(equal("1.rgSvvqbebGdJN0lzANM53+YwI7kMgDCeOfMqCQh37cGOZVkI8ewsrXevwm+J9b2Lf0O/xc0+IK9tSGLP4Za3JmWDugFizSIW+ve23UGorB9an87hND9idw5plt4Pa807PvjbA5G8v89ZzNTsBPaEniQSz3f0GUqF/GDLHx5sbd1AKZNkE0th1ca5NvUZJblL"))
                done()
            }
        }
        
        // ASSERT
    }
    
    func test_accessToken_whenAPIWhenResponseBadCredentials() {
        // ARRANGE
        
        // ACT
        
        // ASSERT
    }
    
    func test_accessToken_whenAPIResponseFail() {
        // ARRANGE
        
        // ACT
        
        // ASSERT
    }
    
}
