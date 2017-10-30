//
//  PhoneValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class PhoneValidatorTests: XCTestCase {
    
    var validator: PhoneValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = PhoneValidator(mandatory: true)
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_valid_phones() {
        XCTAssertTrue(self.validator.validate("900123123"))
        XCTAssertTrue(self.validator.validate("+1900123123"))
        XCTAssertTrue(self.validator.validate("+12900123123"))
        XCTAssertTrue(self.validator.validate("+123900123123"))
    }
    
    func test_invalid_phones() {
        XCTAssertFalse(self.validator.validate("1"))
        XCTAssertFalse(self.validator.validate("+413y9743"))
        XCTAssertFalse(self.validator.validate("+1239876543210"))
        XCTAssertFalse(self.validator.validate("98765432"))
        XCTAssertFalse(self.validator.validate("9876543210"))
    }
}
