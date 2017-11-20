//
//  UserOrx.swift
//  OrchextraTests
//
//  Created by Judith Medina on 13/11/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import GIGLibrary
@testable import Orchextra

class UserOrxTests: XCTestCase {
    
    let session = Session.shared
    
    override func setUp() {
        super.setUp()
        let configurationJSON = JSONHandler().jsonFrom(filename: "core_configuration")!
        let jsonData = configurationJSON["data"]
        let json = JSON(from: jsonData!)
        let project = Project(from: json)
        session.project = project
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_initUser_byDefault() {
        // ARRANGE
        let user = UserOrx()
        
        // ASSERT
        expect(user.crmId).to(beNil())
        expect(user.gender).to(equal(Gender.none))
        expect(user.tags).to(equal([]))
        expect(user.businessUnits).to(equal([]))
        
    }
    
    func test_initUser_withSomeParams_returnUserOrx() {
        // ARRANGE
        let user = UserOrx(crmId: "judith.medina",
        gender: Gender.female,
        birthday: Date(),
        tags: [], businessUnits: [], customFields: [])
        
        // ASSERT
        expect(user.crmId).to(equal("judith.medina"))
        
    }
    
    func test_initUser_fromJSON_returnUserORX() {
        // ARRANGE
        let userJSON = JSONHandler().jsonFrom(filename: "bind_user_response")!
        let jsonData = userJSON["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        let user = UserOrx(json: json)
        
        // ASSERT
        expect(user.crmId).to(equal("Judith.medina"))
        expect(user.gender).to(equal(Gender.male))
        
        let businessUnit = BusinessUnit(name: "it")
        expect(user.businessUnits).to(equal([businessUnit]))
        
        let tag = Tag(prefix: "ios")
        expect(user.tags).to(equal([tag]))
        
        expect(user.customFields[0].value).to(equal("Medina"))
        expect(user.customFields[1].value).to(equal("Judith"))
    }
    
    func test_userParams_whenCRMIdIsNil_returnNil() {
        // ARRANGE
        let userJSON = JSONHandler().jsonFrom(filename: "bind_user_response")!
        let jsonData = userJSON["data"]
        let json = JSON(from: jsonData!)
        let user = UserOrx(json: json)
        user.crmId = nil
        
        // ACT
        let userParams = user.userParams()
        
        // ASSERT
        expect(userParams).to(beNil())
    }
    
    func test_userParams_returnParams () {
        // ARRANGE
        let userJSON = JSONHandler().jsonFrom(filename: "bind_user_response")!
        let jsonData = userJSON["data"]
        let json = JSON(from: jsonData!)
        let user = UserOrx(json: json)
        
        // ACT
        let userParams = user.userParams()
        let crm = userParams?["crm"] as! [String: Any]
        
        // ASSERT
        expect(crm["gender"] as? String).to(equal("m"))
    }
}
