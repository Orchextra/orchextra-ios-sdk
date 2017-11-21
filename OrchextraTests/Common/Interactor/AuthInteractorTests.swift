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
    
}
