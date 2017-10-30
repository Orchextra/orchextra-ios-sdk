//
//  MailValidatorTests.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 11/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import XCTest
@testable import GIGFormulary

class MailValidatorTests: XCTestCase {
    
    var validator: MailValidator!
    
    override func setUp() {
        super.setUp()
        
        self.validator = MailValidator(mandatory: true)
    }
    
    override func tearDown() {
        self.validator = nil
        
        super.tearDown()
    }
    
    // MARK: TESTS
    
    func test_validate_invalid_mails() {
        XCTAssertFalse(self.validator.validate("324324"))
        XCTAssertFalse(self.validator.validate("asdas"))
        XCTAssertFalse(self.validator.validate("asdas@asd"))
        XCTAssertFalse(self.validator.validate("asd.com"))
        XCTAssertFalse(self.validator.validate("@asd.com"))
    }
    
    func test_validate_valid_mails() {
        XCTAssertTrue(self.validator.validate("edu@mail.com"))
        XCTAssertTrue(self.validator.validate("edu.lala@mail.com"))
        XCTAssertTrue(self.validator.validate("edu.lala@a.aa"))
    }
}
