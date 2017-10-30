//
//  DNINIEValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class DNINIEValidatorTests: XCTestCase {
    
    var validator: DNINIEValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = DNINIEValidator(mandatory: true)
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_verify_mandatory() {
        XCTAssertFalse(self.validator.validate(""))
        XCTAssertFalse(self.validator.validate(nil))
    }
    
    func test_correct_dni_mandatory() {
        //-- NIFs --
        XCTAssertTrue(self.validator.validate("50756778x"))
        XCTAssertTrue(self.validator.validate("48206795Z"))
        XCTAssertTrue(self.validator.validate("18056396Q"))
        XCTAssertTrue(self.validator.validate("42669453Z"))
        XCTAssertTrue(self.validator.validate("90254243N"))
        XCTAssertTrue(self.validator.validate("04566186L"))
        XCTAssertTrue(self.validator.validate("09564232G"))
    }
    
    func test_correct_nie_mandatory() {
        //-- NIEs --
        XCTAssertTrue(self.validator.validate("Z7238334D"))
        XCTAssertTrue(self.validator.validate("X5041537Y"))
        XCTAssertTrue(self.validator.validate("X6423966C"))
        XCTAssertTrue(self.validator.validate("Y5942178G"))
        XCTAssertTrue(self.validator.validate("X8104930Y"))
    }
    
    func test_incorrect_dni_mandatory() {
        XCTAssertFalse(self.validator.validate("50756778"))
        XCTAssertFalse(self.validator.validate("507567y"))
        XCTAssertFalse(self.validator.validate("5sx"))
        XCTAssertFalse(self.validator.validate(""))
    }
    
    func test_incorrect_nie_mandatory() {
        XCTAssertFalse(self.validator.validate("X2258819J"))
        XCTAssertFalse(self.validator.validate("X225819J"))
        XCTAssertFalse(self.validator.validate("X2258819"))
        XCTAssertFalse(self.validator.validate("2258819J"))
        XCTAssertFalse(self.validator.validate("X225568819J"))
    }
    
    func test_verify_optional() {
        self.validator.mandatory = false
        XCTAssertTrue(self.validator.validate(""))
        XCTAssertTrue(self.validator.validate(nil))
        XCTAssertFalse(self.validator.validate("5sx"))
        XCTAssertTrue(self.validator.validate("50756778x"))
    }
}
