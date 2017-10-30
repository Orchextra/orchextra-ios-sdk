//
//  AgeValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 19/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class AgeValidatorTests: XCTestCase {
    
    var validator: AgeValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = AgeValidator(mandatory: true)
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_verify_mandatory() {
        XCTAssertFalse(self.validator.validate(nil))
    }
    
    func test_correct_age_mandatory() {
        self.validator.minAge = 18
        
        let date = Date(timeIntervalSince1970: 411523200)
        XCTAssertTrue(self.validator.validate(date))
        
        let date18Age = Date(timeIntervalSince1970: 883612800)
        XCTAssertTrue(self.validator.validate(date18Age))
    }
    
    func test_incorrect_age_mandatory() {
        self.validator.minAge = 12
        
        let date = Date(timeIntervalSince1970: 1262304000)
        XCTAssertFalse(self.validator.validate(date))
    }
    
    func test_verify_optional() {
        self.validator.mandatory = false
        XCTAssertTrue(self.validator.validate(nil))
    }
}
