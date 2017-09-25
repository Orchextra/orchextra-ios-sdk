//
//  Dictionary+ExtensionTests.swift
//  Orchextra
//
//  Created by Judith Medina on 17/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Orchextra

class DictionaryExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_addNewDictionaryToAnotherDictionary_resultCombinationOfTwoDictionary() {
        
        // ARRANGE
        let headers =  [
            "X-app-sdk": "IOS_3.0.0",
            "Accept-Language": "es",
            "user-agent": "iOS_App"]
        
        let authHeaders = ["Authorization" : "Bearer accesstoken"]
        
        // ACT
        let combination = headers + authHeaders
        
        // ASSERT
        expect(combination["Authorization"]).to(equal("Bearer accesstoken"))
        expect(combination["X-app-sdk"]).to(equal("IOS_3.0.0"))
        expect(combination["Accept-Language"]).to(equal("es"))
        expect(combination["user-agent"]).to(equal("iOS_App"))
    }
    
    func test_combineThreeDictionaries() {

        // ARRANGE
        let dicOne = ["1" : 1]
        let dicTwo = ["2" : 2]
        let dicThree = ["3" : 3]

        // ACT
        let result = dicOne + dicTwo + dicThree
        
        // ASSERT
        expect(result["1"]).to(equal(1))
        expect(result["2"]).to(equal(2))
        expect(result["3"]).to(equal(3))
    }
}
