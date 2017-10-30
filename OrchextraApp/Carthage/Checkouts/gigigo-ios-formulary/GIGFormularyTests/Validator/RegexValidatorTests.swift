//
//  RegexValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class RegexValidatorTests: XCTestCase {
    
    var validator: RegexValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = RegexValidator(mandatory: false)
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_init_with_pattern() {
        let pattern  = ".{3}"
        self.validator = RegexValidator(regexPattern: pattern, mandatory: true)
        
        XCTAssertTrue(self.validator.mandatory)
        XCTAssertNotNil(self.validator.regex)
        XCTAssertTrue(self.validator.regex?.pattern == pattern)
    }
    
    func test_init_with_invalid_pattern() {
        let pattern  = ".{3"
        self.validator = RegexValidator(regexPattern: pattern, mandatory: true)
        
        XCTAssertTrue(self.validator.mandatory)
        XCTAssertNil(self.validator.regex)
    }
    
    func test_init_with_nil_pattern() {
        self.validator = RegexValidator(regexPattern: nil, mandatory: true)
        
        XCTAssertTrue(self.validator.mandatory)
        XCTAssertNil(self.validator.regex)
    }
    
    func test_init_with_empty_pattern() {
        self.validator = RegexValidator(regexPattern: "", mandatory: true)
        
        XCTAssertTrue(self.validator.mandatory)
        XCTAssertNil(self.validator.regex)
    }
    
    func test_init_with_nil_regexp() {
        self.validator = RegexValidator(regexPattern: nil, mandatory: true)
        
        XCTAssertTrue(self.validator.mandatory)
        XCTAssertNil(self.validator.regex)
    }
    
    func test_init_with_regexp() {
        do {
            let regexp = try NSRegularExpression(pattern: ".{3}")
            self.validator = RegexValidator(regex: regexp, mandatory: true)
            
            XCTAssertTrue(self.validator.mandatory)
            XCTAssertTrue(self.validator.regex?.pattern == regexp.pattern)
        } catch {
            
        }
    }
    
    func test_validate_mandatory() {
        self.validator.mandatory = true
        
        XCTAssertFalse(self.validator.validate(nil))
        XCTAssertFalse(self.validator.validate(""))
    }
    
    func test_validate_optional() {
        self.validator.mandatory = false
        
        XCTAssertTrue(self.validator.validate(nil))
        XCTAssertTrue(self.validator.validate(""))
    }
    
    func test_validate_regexp() {
        self.validator = RegexValidator(regexPattern: ".{3}", mandatory: true)
        XCTAssertFalse(self.validator.validate("a"))
        XCTAssertTrue(self.validator.validate("aaa"))
        XCTAssertTrue(self.validator.validate("aaaa"))
    }
}
