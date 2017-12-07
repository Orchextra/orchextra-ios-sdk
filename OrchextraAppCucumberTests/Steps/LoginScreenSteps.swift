//
//  LoginScreenSteps.swift
//  OrchextraAppCucumberTests
//
//  Created by Carlos Vicente on 1/12/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

import Foundation
import XCTest
import Cucumberish

class LoginScreenSteps: XCTestCase {
    
    var commonStepDefinitions: CommonStepDefinitions = CommonStepDefinitions(application: XCUIApplication())
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        self.loginScreenSteps()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func givenALoginView() {
        Given("I have a view with ([^\\\"]*)") { (args, userInfo) -> Void in
        }
    }
    
    func whenIinputAnApiKeyToTextfield() {
        When("I input into apikey ([^\\\"]*) textfield ([^\\\"]*)") { (args, userInfo) -> Void in
            guard let identifier = args?[0],
                let apiKey = args?[1] else {
                    assertionFailure("Invalid apiKey textfield")
                    return
            }
            
            let textfield = self.commonStepDefinitions.elementByLabel(identifier, type: "text field")
            textfield.accessibilityElementDidBecomeFocused()
            textfield.typeText(apiKey)
        }
    }
    
    func whenIinputAnApiSecretToTextfield() {
        When("I input into apisecret ([^\\\"]*) textfield ([^\\\"]*)") { (args, userInfo) -> Void in
            guard let identifier = args?[0],
                let apiSecret = args?[1] else {
                    assertionFailure("Invalid apiSecret textfield")
                    return
            }
            
            let textfield = self.commonStepDefinitions.elementByLabel(identifier, type: "text field")
            textfield.accessibilityElementDidBecomeFocused()
            textfield.typeText(apiSecret)
        }
    }
    
    func whenIPressStartButton() {
        When("I press start ([^\\\"]*) button") { (args, userInfo) -> Void in
            guard let identifier = args?[0] else {
                assertionFailure("Invalid start button")
                return
            }
            let button = self.commonStepDefinitions.elementByLabel(identifier, type: "button")
            button.tap()
        }
    }
    
    func thenIshouldSeeAuthError() {
        Then("I should see auth error") { (args, userInfo) -> Void in
            //             CCISAssert(1 == 1, "IMPOSSIBLE")
        }
    }
    
    func loginScreenSteps() {
        self.givenALoginView()
        self.whenIinputAnApiKeyToTextfield()
        self.whenIinputAnApiSecretToTextfield()
        self.whenIPressStartButton()
        self.thenIshouldSeeAuthError()
    }
}

