//
//  BoolValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class BoolValidatorTests: XCTestCase {
    
    var validator: BoolValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = BoolValidator()
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_validate_booleans() {
        XCTAssertTrue(self.validator.validate(true))
        self.validator.mandatory = false
        XCTAssertTrue(self.validator.validate(false))
        self.validator.mandatory = true
        XCTAssertFalse(self.validator.validate(false))
    }
}
