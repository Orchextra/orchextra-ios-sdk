//
//  AuthenticationServiceTests.swift
//  OrchextraTests
//
//  Created by Judith Medina on 11/01/2018.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import OHHTTPStubs
@testable import Orchextra


class AuthenticationServiceTests: XCTestCase {
    
    var authServices: AuthenticationService!

    override func setUp() {
        super.setUp()
        self.authServices = AuthenticationService()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_newToken_returnToken() {
        // Arrange
        StubResponse.mockResponse(for: "/token", with: "accesstoken_core_success.json")

        // Act
        var accesstoken: String?
        self.authServices.newToken(with: "apikey", apisecret: "apisecret") { result in
            switch result {
            case .success(let token):
                accesstoken = token
            default:
                accesstoken = nil
            }
        }
        
        // Assert
        expect(accesstoken).toEventually(equal("tokenTest"))
    }
    
    
    func test_newToken_returnErrorService() {
        // Arrange
        StubResponse.mockResponse(for: "/token", with: "accesstoken_fail_credential.json")
        
        // Act
        var error: Error?
        self.authServices.newToken(with: "apikey", apisecret: "apisecret") { result in
            switch result {
            case .error(let errorService):
                error = errorService
            default:
                error = nil
            }
        }
        
        // Assert
        expect(error).toEventually(matchError(ErrorService.invalidCredentials.self))
    }
    
    func test_newToken_returnErrorJsonFormat() {
        // Arrange
        StubResponse.mockResponse(for: "/token", with: "accesstoken_fail_jsonError.json")
        
        // Act
        var error: Error?
        self.authServices.newToken(with: "apikey", apisecret: "apisecret") { result in
            switch result {
            case .error(let errorService):
                error = errorService
            default:
                error = nil
            }
        }
        
        // Assert
        expect(error).toEventually(matchError(ErrorService.invalidJSON.self))
    }
    
    func test_newToken_returnUnknownError() {
        // Arrange
        StubResponse.mockResponse(for: "/token", with: "accesstoken_fail_unexpected.json")
        
        // Act
        var error: Error?
        self.authServices.newToken(with: "apikey", apisecret: "apisecret") { result in
            switch result {
            case .error(let errorService):
                error = errorService
            default:
                error = nil
            }
        }
        
        // Assert
        expect(error).toEventually(matchError(ErrorService.unknown.self))
    }
    
    func test_bind() {
        // Arrange
        StubResponse.mockResponse(for: "/token/data", with: "accesstoken_fail_unexpected.json")
        
        // Act
    }
}
