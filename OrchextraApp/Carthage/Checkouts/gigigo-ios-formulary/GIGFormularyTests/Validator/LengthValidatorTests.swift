//
//  LengthValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class LengthValidatorTests: XCTestCase {
    
    var validator: LengthValidator!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_length_mandatory() {
        self.validator = LengthValidator(mandatory: true)
        
        XCTAssertFalse(self.validator.validate(""))
        XCTAssertFalse(self.validator.validate(nil))
    }
    
    func test_length_optional() {
        self.validator = LengthValidator(mandatory: false)
        
        XCTAssertTrue(self.validator.validate(""))
        XCTAssertTrue(self.validator.validate(nil))
    }
    
    func test_mandatory_with_max_length() {
        self.validator = LengthValidator(minLength: nil, maxLength: 2)
        self.validator.mandatory = true
        
        XCTAssertFalse(self.validator.validate(""))
        XCTAssertTrue(self.validator.validate("1"))
        XCTAssertTrue(self.validator.validate("12"))
        XCTAssertFalse(self.validator.validate("123"))
    }
    
    func test_optional_with_max_length() {
        self.validator = LengthValidator(minLength: nil, maxLength: 2)
        self.validator.mandatory = false
        
        XCTAssertTrue(self.validator.validate(""))
        XCTAssertTrue(self.validator.validate("1"))
        XCTAssertTrue(self.validator.validate("12"))
        XCTAssertFalse(self.validator.validate("123"))
    }
    
    func test_mandatory_with_min_length() {
        self.validator = LengthValidator(minLength: 2, maxLength: nil)
        self.validator.mandatory = true
        
        XCTAssertFalse(self.validator.validate(""))
        XCTAssertFalse(self.validator.validate("1"))
        XCTAssertTrue(self.validator.validate("12"))
        XCTAssertTrue(self.validator.validate("123"))
    }
    
    func test_optional_with_min_length() {
        self.validator = LengthValidator(minLength: 2, maxLength: nil)
        self.validator.mandatory = false
        
        XCTAssertTrue(self.validator.validate(""))
        XCTAssertFalse(self.validator.validate("1"))
        XCTAssertTrue(self.validator.validate("12"))
        XCTAssertTrue(self.validator.validate("123"))
    }
    
    func test_mandatory_with_min_length_and_max_length() {
        self.validator = LengthValidator(minLength: 2, maxLength: 3)
        self.validator.mandatory = true
        
        XCTAssertFalse(self.validator.validate(""))
        XCTAssertFalse(self.validator.validate("1"))
        XCTAssertTrue(self.validator.validate("12"))
        XCTAssertTrue(self.validator.validate("123"))
        XCTAssertFalse(self.validator.validate("1234"))
    }
    
    func test_optional_with_min_length_and_max_length() {
        self.validator = LengthValidator(minLength: 2, maxLength: 3)
        self.validator.mandatory = false
        
        XCTAssertTrue(self.validator.validate(""))
        XCTAssertFalse(self.validator.validate("1"))
        XCTAssertTrue(self.validator.validate("12"))
        XCTAssertTrue(self.validator.validate("123"))
        XCTAssertFalse(self.validator.validate("1234"))
    }
    
    func test_lengthValidator_whenControlCharecter_returnSuccess() {
        self.validator = LengthValidator(minLength: 2, maxLength: 6)
        self.validator.mandatory = false
        
        XCTAssertTrue(self.validator.controlCharacters("casa"))
    }
    
    func test_lengthValidator_whenControlCharecterIsMandatory_returnSuccess() {
        self.validator = LengthValidator(minLength: 2, maxLength: 6)
        self.validator.mandatory = true
        
        XCTAssertTrue(self.validator.controlCharacters("casa"))
    }
    
    func test_lengthValidator_whenControlCharecterIsMandatory_returnError() {
        self.validator = LengthValidator(minLength: 2, maxLength: 3)
        self.validator.mandatory = true
        
        XCTAssertFalse(self.validator.controlCharacters("casa"))
    }

}
