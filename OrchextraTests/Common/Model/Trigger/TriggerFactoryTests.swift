//
//  TriggerFactoryTests.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
@testable import Orchextra

class TriggerFactoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_triggerFactory_returnTriggerNil() {
        
        // ARRANGE
        let triggerValues = ["type": "codeIncorrect",
                             "value": "1234567"]
        
        // ACT
        let trigger = TriggerFactory.trigger(from: triggerValues)
        
        // ASSERT
        expect(trigger).to(beNil())
    }
    
    func test_triggerFactory_returnTriggerBarcode() {
        
        // ARRANGE
        let triggerValues = ["type": "barcode",
                             "value": "1234567"]
        
        // ACT
        let trigger = TriggerFactory.trigger(from: triggerValues)
        
        // ASSERT
        expect(trigger?.triggerId).to(equal("barcode"))
        
        let urlParams = trigger?.urlParams()
        expect(urlParams?["type"] as? String).to(equal("barcode"))
        expect(urlParams?["value"] as? String).to(equal("1234567"))
    }
    
    func test_triggerFactory_returnTriggerQR() {
        
        // ARRANGE
        let triggerValues = ["type": "qr",
                             "value": "hello world"]
        
        // ACT
        let trigger = TriggerFactory.trigger(from: triggerValues)
        
        // ASSERT
        expect(trigger?.triggerId).to(equal("qr"))
        
        let urlParams = trigger?.urlParams()
        expect(urlParams?["type"] as? String).to(equal("qr"))
        expect(urlParams?["value"] as? String).to(equal("hello world"))
    }
}
