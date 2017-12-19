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
import XCFit

class ScannerScreenSteps: XCTestCase {
    
    var commonStepDefinitions: CommonStepDefinitions!
    let app = XCUIApplication()
    let xcfit = XCFit()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        self.commonStepDefinitions = CommonStepDefinitions(application: app)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func givenIinputAnApiKeyToTextfield() {
        
        Given("The app logged") { (args, userInfo) -> Void in
            
            let scrollViewsQuery = self.app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"LoginView\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            let elementsQuery = scrollViewsQuery.otherElements

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
        
    func thenScannedBarcode() {
        MatchAll("I scanned barcode with value \(CommonRegularExpression.anyString)") { (args, userInfo) -> Void in
           
            guard let value = args?[0] else {
                assertionFailure("Barcode value invalid")
                return
            }
            
            let scannedValueTextField = self.app.textFields["scanned value"]
            scannedValueTextField.tap()
            scannedValueTextField.typeText(value)
            
            let switch2 = self.app.switches["1"]
            switch2.swipeLeft()
            self.app.buttons["Send scan value"].tap()
            
        }
    }
    
    func thenScannedQR() {
        MatchAll("I scanned qr with value \(CommonRegularExpression.anyString)") { (args, userInfo) -> Void in
            
            guard let value = args?[0] else {
                assertionFailure("QR value invalid")
                return
            }
            
            let scannedValueTextField = self.app.textFields["scanned value"]
            scannedValueTextField.tap()
            scannedValueTextField.typeText(value)
            self.app.buttons["Send scan value"].tap()
            
        }
    }
    
    func thenISeeANotification() {
        MatchAll("I should see notification with title: \(CommonRegularExpression.anyString) and body: \(CommonRegularExpression.anyString)") { (args, userInfo) -> Void in
            
            guard let title = args?[0] else {
                assertionFailure("Title empty")
                return
            }
            let alert = self.app.alerts[title]
            self.xcfit.waitUntilElementActive(element: alert)
            alert.buttons["OK"].tap()
        }
    }
    
    func thenIShouldSeeAWebView() {
        MatchAll("I should see webview") { (args, userInfo) -> Void in
        let webview = self.app.descendants(matching: .webView)
        XCTAssertNotNil(webview)
        }
    }
    
    func thenIShouldSeeABrowser() {
        MatchAll("I should see browser") { (args, userInfo) -> Void in
            let browser = self.app.descendants(matching: .browser)
            XCTAssertNotNil(browser)
        }
    }

    func scannerScreenSteps() {
        self.setUp()
        self.givenIinputAnApiKeyToTextfield()
        self.thenScannedBarcode()
        self.thenScannedQR()
        self.thenISeeANotification()
        self.thenIShouldSeeAWebView()
        self.thenIShouldSeeABrowser()
    }
}
