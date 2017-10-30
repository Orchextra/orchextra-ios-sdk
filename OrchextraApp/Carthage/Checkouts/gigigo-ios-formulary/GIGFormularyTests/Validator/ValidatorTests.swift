//
//  ValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class ValidatorTests: XCTestCase {
    
    var validator: Validator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = Validator()
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_not_nil() {
        XCTAssertNotNil(self.validator)
    }
    
    func test_validate_mandatory() {
        self.validator.mandatory = true
        
        XCTAssertFalse(self.validator.validate(nil))
        XCTAssertTrue(self.validator.validate(""))
    }
    
    func test_validate_optional() {
        self.validator.mandatory = false
        
        XCTAssertTrue(self.validator.validate(nil))
        XCTAssertTrue(self.validator.validate(""))
    }
}
