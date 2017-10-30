//
//  StringValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class StringValidatorTests: XCTestCase {
    
    var validator: StringValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = StringValidator(mandatory: false)
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_validate_mandatory() {
        self.validator.mandatory = true
        
        XCTAssertFalse(self.validator.validate(nil))
        XCTAssertFalse(self.validator.validate(""))
        XCTAssertTrue(self.validator.validate("Hola"))
        let dic = [String: String]()
        XCTAssertFalse(self.validator.validate(dic))
    }
    
    func test_validate_optional() {
        self.validator.mandatory = false
    
        XCTAssertTrue(self.validator.validate(nil))
        XCTAssertTrue(self.validator.validate(""))
        let dic = [String: String]()
        XCTAssertFalse(self.validator.validate(dic))
    }
}
