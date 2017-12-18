//
//  ScannerScreenSteps.swift
//  OrchextraAppCucumberTests
//
//  Created by Judith Medina on 14/12/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import XCTest
import Cucumberish

class ScannerScreenSteps: XCTestCase {
    
    var commonStepDefinitions: CommonStepDefinitions!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let application = XCUIApplication()
        application.launch()
        self.commonStepDefinitions = CommonStepDefinitions(application: application)        
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func givenIinputAnApiKeyToTextfield() {
        
        Given("I have logged") { (args, userInfo) -> Void in
            
            let app = XCUIApplication()
            let scrollViewsQuery = app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"LoginView\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            let elementsQuery = scrollViewsQuery.otherElements
            
            
//            if !elementsQuery.textFields["apiKey"].isHittable {
//                let app = XCUIApplication()
//                app.navigationBars["Camera"].buttons["config"].tap()
//                app.buttons["Log out"].tap()
//            }
            self.resetCredentials()
            
            let apikeyTextField = elementsQuery/*@START_MENU_TOKEN@*/.textFields["apiKey"]/*[[".textFields[\"Api key\"]",".textFields[\"apiKey\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            apikeyTextField.tap()
            apikeyTextField.clearAndEnterText(text: "b65b045b56858d745e8a8c35339bd57604fadca5")
            
            let logoOrchextraElement = scrollViewsQuery.otherElements.containing(.image, identifier:"logo_orchextra").element
            logoOrchextraElement.tap()
            
            let apisecretTextField = elementsQuery/*@START_MENU_TOKEN@*/.textFields["apiSecret"]/*[[".textFields[\"Api Secret\"]",".textFields[\"apiSecret\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            apisecretTextField.tap()
            apisecretTextField.clearAndEnterText(text: "662f9a05f5e05d2cbad756c715c9f9cf0f5fe6a0")
            logoOrchextraElement.tap()
            elementsQuery/*@START_MENU_TOKEN@*/.buttons["start"]/*[[".buttons[\"START\"]",".buttons[\"start\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        }
        
    }
    
    func resetCredentials() {
        let triggeringView = self.commonStepDefinitions.elementByLabel("TriggeringVC", type: "view")
        
        XCTAssert(triggeringView.exists == true)
        let settingsButton = self.commonStepDefinitions.elementByLabel("settingsButton", type: "navigationBarButton")
        settingsButton.tap()
        
        let settingsView = self.commonStepDefinitions.elementByLabel("SettingsVC", type: "view")
        XCTAssert(settingsView.exists == true)
        
        let logOutButton = self.commonStepDefinitions.elementByLabel("logOutButton", type: "button")
        logOutButton.tap()
    }
        
    func scannedBarcode() {
        MatchAll("I scanned barcode with value 981234567890") { (args, userInfo) -> Void in
            
            let app = XCUIApplication()
            let scannedValueTextField = app.textFields["scanned value"]
            scannedValueTextField.tap()
            scannedValueTextField.typeText("value")
            
            let switch2 = app.switches["1"]
            switch2.swipeLeft()
            app.buttons["Send scan value"].tap()
            
        }
    }

    func loginScreenWithInvalidCredentials() {
        self.setUp()
        self.givenIinputAnApiKeyToTextfield()
        self.scannedBarcode()
        self.thenISeeAWebViewIsOpenWithURl()

    }
    
    func thenISeeAWebViewIsOpenWithURl() {
        Then("I see a webview is open with \(CommonRegularExpression.anyString)") { (args, userInfo) -> Void in
//            let triggeringView = self.commonStepDefinitions.elementByLabel("TriggeringVC", type: "view")
//            let exists = NSPredicate(format: "exists == 1")
//            self.expectation(for: exists, evaluatedWith: triggeringView) {
//                return true
//            }
            // TODO: check webVC identifier and webVC url
        }

    }
    
}
