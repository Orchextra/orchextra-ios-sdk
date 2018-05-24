//
//  ActionFactory.swift
//  Orchextra
//
//  Created by Judith Medina on 31/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import Foundation
import GIGLibrary
@testable import Orchextra

class ActionFactoryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_actionFactory_returnActionscanner() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_scanner_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        let action = ActionFactory.action(from: json)
        
        // ASSERT
        expect(action?.type).to(equal("scan"))
    }
    
    func test_actionFactory_returnActionBrowser() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_browser_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        let action = ActionFactory.action(from: json)
        
        // ASSERT
        expect(action?.type).to(equal("browser"))
    }
    
    
    func test_actionFactory_returnActionWebview() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_webview_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        let action = ActionFactory.action(from: json)
        
        // ASSERT
        expect(action?.type).to(equal("webview"))
    }
    
    func test_actionFactory_returnActionExternalBrowser() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_external_browser_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        let action = ActionFactory.action(from: json)
        
        // ASSERT
        expect(action?.type).to(equal("browser_external"))
    }
}
