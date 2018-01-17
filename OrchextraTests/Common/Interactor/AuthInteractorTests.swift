//
//  AuthenticationServicesTests.swift
//  OrchextraTests
//
//  Created by Judith Medina on 20/11/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import OHHTTPStubs
import GIGLibrary
@testable import Orchextra

class AuthInteractorTests: XCTestCase {
    
    var authInteractor: AuthInteractor!
    var service: AuthenticationService!
    var sessionMock: SessionMock!

    override func setUp() {
        super.setUp()
        self.sessionMock = SessionMock(userDefault: UserDefaults())
        self.service = AuthenticationService()
        self.authInteractor = AuthInteractor(service: self.service,
                                             session: self.sessionMock)
        Orchextra.shared.environment = .staging
    }
    
    override func tearDown() {
        super.tearDown()
        self.authInteractor = nil
        OHHTTPStubs.removeAllStubs()
    }
    
    func test_authWithAccessToken_withoutApikeyAndApisecret_returnError() {
        
        // Arrange
        self.sessionMock.apiKey = nil
        self.sessionMock.apiSecret = nil
        
        // Act
        var errorCalled: Bool?
        self.authInteractor.authWithAccessToken { result in
            switch result {
            case .error:
                errorCalled = true
            default:
                errorCalled = false
            }
        }
        // Assert
        expect(errorCalled).toEventually(equal(true))
    }
    
    func test_authWithAccessToken_withApikeyAndApisecret_noAccesstokenStored_returnNewAccesstoken() {
        
        // Arrange
        StubResponse.mockResponse(for: "/token", with: "accesstoken_core_success.json")
        StubResponse.mockResponse(for: "/token/data", with: "bind_user_response.json")
        self.sessionMock.apiKey = "b65b045b56858d745e8a8c35339bd57604fadca5"
        self.sessionMock.apiSecret = "662f9a05f5e05d2cbad756c715c9f9cf0f5fe6a0"
        
        // Act
        var accesstoken: String?
        self.authInteractor.authWithAccessToken { result in
            switch result {
            case .success(let token):
                accesstoken = token
            default:
                accesstoken = ""
            }
        }
    
        // Assert
        expect(accesstoken).toEventually(equal("tokenTest"))
    }
    
    func test_authWithAccessToken_withApikeyAndApisecret_accesstokenStored_returnAccessTokenStored() {
        // Arrange
        self.sessionMock.apiKey = "b65b045b56858d745e8a8c35339bd57604fadca5"
        self.sessionMock.apiSecret = "662f9a05f5e05d2cbad756c715c9f9cf0f5fe6a0"
        self.sessionMock.inputAccesstoken = "tokenTest"
        
        // Act
        var accesstoken: String?
        self.authInteractor.authWithAccessToken { result in
            switch result {
            case .success(let token):
                accesstoken = token
            default:
                accesstoken = ""
            }
        }
        
        // Assert
        expect(accesstoken).toEventually(equal("tokenTest"))
    }
    
    func test_bindUser() {
        StubResponse.mockResponse(for: "/token/data", with: "bind_user_response.json")
        let user = UserOrx(crmId: "Judith.medina", gender: .female, birthday: Date(), tags: [], businessUnits: [], customFields: [])
        
        var completionCalled = false
        let completion = self.expectation(description: "completion called")
        self.authInteractor.bind(user: user, device: nil) { result in
            completionCalled = true
            completion.fulfill()
        }
        expect(completionCalled).toEventually(beTrue())
        expect(self.sessionMock.spyBindUser.user?.crmId).toEventually(equal(user.crmId))
        expect(self.sessionMock.spyBindUser.called).toEventually(beTrue())

        self.waitForExpectations(timeout: 1) { _ in }
    }
    
    func test_sendRequest_withAuthentication() {
        
        // Arrange
        StubResponse.mockResponse(for: "/action", with: "action_browser_notification.json")
        let values: [String: Any] = [ : ]
        
        let request = Request.orchextraRequest(
            method: "POST",
            baseUrl: Config.triggeringEndpoint,
            endpoint: "/action",
            bodyParams: values)
        
        // Act
        var resultJson: JSON?
        self.authInteractor.sendRequest(request: request) { result in
            switch result {
            case .success(let json):
                resultJson = json
            default:
                resultJson = nil
            }
        }
        
        // Assert
        expect(resultJson).toEventually(beAKindOf(JSON.self))
    }
    
}
