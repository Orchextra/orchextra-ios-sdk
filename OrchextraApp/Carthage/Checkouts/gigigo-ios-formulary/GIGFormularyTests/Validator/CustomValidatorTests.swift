//
//  CustomValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/4/17.
//  Copyright © 2017 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class CustomValidatorTests: XCTestCase {
    
    var validator: CustomValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = CustomValidator(
            mandatory: true,
            custom: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
        )
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
        self.validator.custom = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
        
        XCTAssertFalse(self.validator.validate(nil))
        XCTAssertTrue(self.validator.validate("edu@gmail.com"))
    }
    
    func test_validate_optional() {
        self.validator.mandatory = false
        
        XCTAssertTrue(self.validator.validate(nil))
        XCTAssertTrue(self.validator.validate(""))
    }
    
    func test_customValidate_whenIncorrectRegex_returnFailt() {
        self.validator.mandatory = true
        self.validator.custom = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
        
        XCTAssertFalse(self.validator.validate(nil))
        XCTAssertFalse(self.validator.validate("edu@gmail"))
    }
}
