//
//  LoginScreenSteps.swift
//  OrchextraAppCucumberTests
//
//  Created by Carlos Vicente on 1/12/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import XCTest
import Cucumberish

class LoginScreenSteps: XCTestCase {
    
    var commonStepDefinitions: CommonStepDefinitions!
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.app.launch()

        self.commonStepDefinitions = CommonStepDefinitions(application: self.app)
    }
    
    func interactSystemAlert() {
        addUIInterruptionMonitor(withDescription: "Location Dialog") { (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
        
        self.app.tap()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func givenALoginView() {
        Given("I have a login view") { (args, userInfo) -> Void in
        }
    }
    
    func whenIinputAnApiKeyToTextfield() {
        When("I input apiKey \(CommonRegularExpression.anyString)") { (args, userInfo) -> Void in
            guard let apiKey = args?[0] else {
                    assertionFailure("Invalid apiKey textfield value")
                    return
            }
            
            let textfield = self.commonStepDefinitions.elementByLabel("apiKey", type: "text field")
            textfield.clearAndEnterText(text: apiKey)
        }
    }
    
    func whenIinputAnApiSecretToTextfield() {
        When("I input apiSecret \(CommonRegularExpression.anyString)") { (args, userInfo) -> Void in
            guard let apiSecret = args?[0] else {
                    assertionFailure("Invalid apiSecret textfield value")
                    return
            }
            
            let textfield = self.commonStepDefinitions.elementByLabel("apiSecret", type: "text field")
            textfield.clearAndEnterText(text: apiSecret)
        }
    }
    
    func whenIPressStartButton() {
        When("I press start button") { (args, userInfo) -> Void in
            let button = self.commonStepDefinitions.elementByLabel("start", type: "button")
            button.tap()
        }
    }
    
    func thenIshouldSeeAuthError() {
        Then("I should see auth error") { (args, userInfo) -> Void in
         let alert = self.commonStepDefinitions.elementByLabel("error_alert", type: "alert")
         let exists = NSPredicate(format: "exists == 1")
            self.expectation(for: exists, evaluatedWith: alert) {
                return true
            }
        }
    }
    
    func testLoginScreenWithInvalidCredentials() {
        self.setUp()
        self.givenALoginView()
        self.whenIinputAnApiKeyToTextfield()
        self.whenIinputAnApiSecretToTextfield()
        self.whenIPressStartButton()
        self.thenIshouldSeeAuthError()
    }
}

