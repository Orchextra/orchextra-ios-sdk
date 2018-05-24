//
//  OldDataMigrationManagerTests.swift
//  OrchextraTests
//
//  Created by José Estela on 16/4/18.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import XCTest
import Nimble
@testable import Orchextra

class OldDataMigrationManagerTests: XCTestCase {
    
    // MARK: - Attributes
    
    var migrationManager: OldDataMigrationManager!
    var userDefaultsFake: UserDefaults!
    var sessionMock: SessionMock!
    
    // MARK: - Tests life cycle
    
    override func setUp() {
        super.setUp()
        self.userDefaultsFake = UserDefaults(suiteName: "MigrationManagerUserDefaults")
        self.sessionMock = SessionMock()
        self.migrationManager = OldDataMigrationManager(userDefaults: self.userDefaultsFake, session: self.sessionMock)
    }
    
    override func tearDown() {
        self.userDefaultsFake = nil
        self.sessionMock = nil
        self.migrationManager = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_migrationManager_migratesUserDataCorrectly() {
        // ARRANGE
        let user = ORCUser()
        user.crmID = "Test_CRMID"
        user.gender = ORCUserGender.genderFemale
        user.birthday = Date()
        let tag1 = ORCTag(prefix: "PREFIX_1", name: "NAME")!
        let tag2 = ORCTag(prefix: "PREFIX_2")!
        user.tags = [tag1, tag2]
        let bu1 = ORCBusinessUnit(name: "BU1")!
        let bu2 = ORCBusinessUnit(name: "BU2")!
        user.businessUnits = [bu1, bu2]
        let customField1 = ORCCustomField(key: "CustomField1", label: "Test 1", type: ORCCustomFieldType.string, value: "1234")!
        let customField2 = ORCCustomField(key: "CustomField2", label: "Test 2", type: ORCCustomFieldType.boolean, value: true)!
        let customField3 = ORCCustomField(key: "CustomField3", label: "Test 3", type: ORCCustomFieldType.dateTime, value: user.birthday)!
        let customField4 = ORCCustomField(key: "CustomField4", label: "Test 4", type: ORCCustomFieldType.float, value: 12.5)!
        let customField5 = ORCCustomField(key: "CustomField5", label: "Test 5", type: ORCCustomFieldType.integer, value: 1234)!
        user.customFields = [customField1, customField2, customField3, customField4, customField5]
        // Save the user
        self.userDefaultsFake.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: OldOrchextraKeys.user.rawValue)
        
        // ACT
        self.migrationManager.migrateData()
        
        // ASSERT
        expect(self.sessionMock.spyBindUser.called) == true
        expect(self.sessionMock.spyBindUser.user) == UserOrx(
            crmId: "Test_CRMID",
            gender: .female,
            birthday: user.birthday,
            tags: [
                Tag(prefix: "PREFIX_1", name: "NAME"),
                Tag(prefix: "PREFIX_2")
            ],
            businessUnits: [
                BusinessUnit(name: "BU1"),
                BusinessUnit(name: "BU2")
            ],
            customFields: [
                CustomField(key: "CustomField1", label: "Test 1", type: .string, value: "1234"),
                CustomField(key: "CustomField2", label: "Test 2", type: .boolean, value: "1"),
                CustomField(key: "CustomField3", label: "Test 3", type: .datetime, value: "\(user.birthday.timeIntervalSince1970)"),
                CustomField(key: "CustomField4", label: "Test 4", type: .float, value: "12.5"),
                CustomField(key: "CustomField5", label: "Test 5", type: .integer, value: "1234")
            ]
        )
        expect(self.userDefaultsFake.object(forKey: OldOrchextraKeys.user.rawValue)).to(beNil())
    }
    
    func test_migrationManager_migratesDeviceBusinessUnitsCorrectly() {
        // ARRANGE
        let bu1 = ORCBusinessUnit(name: "BU1")!
        let bu2 = ORCBusinessUnit(name: "BU2")!
        self.userDefaultsFake.set([bu1.archived(), bu2.archived()], forKey: OldOrchextraKeys.deviceBusinessUnits.rawValue)
        
        // ACT
        self.migrationManager.migrateData()
        
        // ASSERT
        expect(self.sessionMock.spySetDeviceBusinessUnits.called) == true
        expect(self.sessionMock.spySetDeviceBusinessUnits.bunits) == [BusinessUnit(name: "BU1"), BusinessUnit(name: "BU2")]
        expect(self.userDefaultsFake.object(forKey: OldOrchextraKeys.deviceBusinessUnits.rawValue)).to(beNil())
    }
    
    func test_migrationManager_migrateDeviceTagsCorrectly() {
        // ARRANGE
        let tag1 = ORCTag(prefix: "PREFIX_1", name: "NAME")!
        let tag2 = ORCTag(prefix: "PREFIX_2")!
        self.userDefaultsFake.set([tag1.archived(), tag2.archived()], forKey: OldOrchextraKeys.deviceTags.rawValue)
        
        // ACT
        self.migrationManager.migrateData()
        
        // ASSERT
        expect(self.sessionMock.spySetDeviceTags.called) == true
        expect(self.sessionMock.spySetDeviceTags.tags) == [Tag(prefix: "PREFIX_1", name: "NAME"), Tag(prefix: "PREFIX_2")]
        expect(self.userDefaultsFake.object(forKey: OldOrchextraKeys.deviceTags.rawValue)).to(beNil())
    }
}

private extension NSObject {
    
    func archived() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
