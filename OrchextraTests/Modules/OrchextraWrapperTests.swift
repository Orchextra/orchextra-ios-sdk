//
//  OrchextraWrapperTests.swift
//  OrchextraTests
//
//  Created by Judith Medina on 20/11/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import OHHTTPStubs
@testable import Orchextra

class OrchextraControllerTests: XCTestCase {
    
    var orchextraController: OrchextraController!
    var sessionMock: SessionMock!
    var configInteractor: ConfigInteractor!
    var authInteractor: AuthInteractor!
    var moduleOutputMock: ModuleOutput!
    var applicationCenter: ApplicationCenter!
    
    override func setUp() {
        super.setUp()
        self.sessionMock = SessionMock()
        self.authInteractor = AuthInteractor()
        self.configInteractor = ConfigInteractor(session: self.sessionMock,
                                                 service: ConfigService(auth: self.authInteractor))
        self.moduleOutputMock = ModuleOutputMock()
        self.applicationCenter = ApplicationCenter()
        self.orchextraController = OrchextraController(session: self.sessionMock,
                                                 configInteractor: self.configInteractor,
                                                 authInteractor: self.authInteractor,
                                                 moduleOutputWrapper: ModuleOutputWrapper(),
                                                 applicationCenter: self.applicationCenter)
    }
    
    override func tearDown() {
        super.tearDown()
        self.orchextraController = nil
        self.sessionMock = nil
        self.configInteractor = nil
        self.authInteractor = nil
        self.moduleOutputMock = nil
        self.applicationCenter = nil
    }
    
    func test_remotePushNotification() {
        let input = "c9d4c07c fbbc26d6 ef87a44d 53e16983 1096a5d5 fd825475 56659ddd f715defc"
        let data = input.data(using: .utf8)!
        self.orchextraController.remote(apnsToken: data)
    }
    
    func test_bindUser() {
        StubResponse.mockResponse(for: "/token/data", with: "bind_user_response.json")
        let user = UserOrx(crmId: "judith.medina", gender: .female, birthday: Date(), tags: [], businessUnits: [], customFields: [])
        self.orchextraController.bindUser(user)
        
        expect(self.sessionMock.spyCurrentUserCalled).toEventually(beTrue())
    }
    
    
}
