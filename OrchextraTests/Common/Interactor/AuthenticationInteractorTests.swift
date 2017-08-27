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
        
        let expectWait = expectation(description: "waitForAccessToken")
        
        let _ = stub(condition: isPath("/v1/security/token"), response: { _ in
            return StubResponse.stubResponse(with: "accesstoken_ok.json")
        })
        
        // ACT
        self.interactor.authWithAccessToken(completion: { result in
            switch result {
            case .success(let accesstoken):            expect(accesstoken).to(equal("1.YxoLHTGQP6yG80tPl1eGg61mFTX5XZGbMjpKms5Yk4xYN4iRaa1s4vMmuBDYvdzkMyAtbsUI0FmuTcxD0mVV3wWcVeq6S88kPZ6lWJzAI97wAHx/+nStelKQ23PPSaA0DAiN4PYIICRWujZoaSlUQnOE86WUgWtTQBdkhphOlKcdjsySJyQVp2lVTvb5I7YM"))
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
