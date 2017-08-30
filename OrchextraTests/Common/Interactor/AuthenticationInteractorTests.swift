//
//  AuthenticationInteractorTests.swift
//  OrchextraTests
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import Foundation
import GIGLibrary
import OHHTTPStubs
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
        
        let expectWait = expectation(description: "waitForAccessToken")
        
        let _ = stub(condition: isPath("/v1/security/token"), response: { _ in
            return StubResponse.stubResponse(with: "accesstoken_ok.json")
        })
        
        // ACT
        self.interactor.authWithAccessToken(completion: { result in
            switch result {
                
            case .success(let accesstoken):
                expect(accesstoken).to(equal("1.sZN3vT+995NsQWgJ2uRqQbxTgvVMNZrOp50tR6/JlPVZwH0Tr1kkzpQLquIfUPnOdcSuVmqo2C1zhKXyGlSHq8N7WwfzT8Vc60sLkpWTl1tcjHdWXuK03C5v/PbTLp4bi/t/UptKTfY5PELd5xIfiA=="))
            case .error: break
            }
            expectWait.fulfill()
        })
        // ASSERT
        waitForExpectations(timeout: 10) { error in
            
        }
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
