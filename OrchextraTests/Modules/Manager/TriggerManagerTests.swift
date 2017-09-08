//
//  ActionManagerTests.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import GIGLibrary
@testable import Orchextra

class TriggerManagerTests: XCTestCase {
    
    var triggerManager: TriggerManager!
    var moduleInput: ModuleInputMock!
    
    var actionManager: ActionManager!
    var actionServicesMock: ActionServicesMock!
    var pushorxManagerMock: PushOrxManagerMock!

    override func setUp() {
        super.setUp()
        self.moduleInput = ModuleInputMock()
        
        self.actionServicesMock = ActionServicesMock()
        self.pushorxManagerMock = PushOrxManagerMock()
        self.actionManager = ActionManager(
            service: self.actionServicesMock,
            pushManager: self.pushorxManagerMock)
        
        self.triggerManager = TriggerManager(interactor: TriggerInteractor(),
                                             actionManager: self.actionManager)
        self.triggerManager.module = self.moduleInput
        self.moduleInput.outputModule = self.triggerManager
    }
    
    override func tearDown() {
        super.tearDown()
        self.triggerManager = nil
        self.moduleInput = nil
    }

    func test_triggerDidFinish_withActionScanWithNotification_withSchedule() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_scanner_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        self.triggerManager.triggerDidFinishSuccessfully(with: json, triggerId: "")
        
        // ASSERT
        expect(self.pushorxManagerMock.spyDispatchNotification.called).to(equal(true))
    }
    
    func test_triggerDidFinish_withActionScanWithoutNotification() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_scanner_without_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        self.triggerManager.triggerDidFinishSuccessfully(with: json, triggerId: "")
        
        // ASSERT
        expect(self.actionServicesMock.spyConfirmAction.called).to(equal(true))
        expect(self.actionServicesMock.spyConfirmAction.action.type).to(equal("scan"))
        expect(self.actionServicesMock.spyConfirmAction.action.trackId).to(equal("59a3fcbc53c7c0fc018b4578"))
        expect(self.actionServicesMock.spyConfirmAction.action.id).to(equal("599ea2209c309558028b4567"))
        expect(self.actionServicesMock.spyConfirmAction.action.urlString).to(equal("orchextra://scanner"))
    }
    
    func test_triggerDidFinish_withActionWebviewWithoutNotification() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_webview_without_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        self.triggerManager.triggerDidFinishSuccessfully(with: json, triggerId: "")
        
        // ASSERT
        expect(self.actionServicesMock.spyConfirmAction.called).to(equal(true))
        expect(self.actionServicesMock.spyConfirmAction.action.type).to(equal("webview"))
        expect(self.actionServicesMock.spyConfirmAction.action.trackId).to(equal("59a3fcbc53c7c0fc018b4578"))
        expect(self.actionServicesMock.spyConfirmAction.action.id).to(equal("599ea2209c309558028b4567"))
        expect(self.actionServicesMock.spyConfirmAction.action.urlString).to(equal("www.google.es"))
    }
    
    func test_triggerDidFinish_withActionBrowserWithoutNotification() {
        
        // ARRANGE
        let actionFile = JSONHandler().jsonFrom(filename: "action_browser_without_notification")!
        let jsonData = actionFile["data"]
        let json = JSON(from: jsonData!)
        
        // ACT
        self.triggerManager.triggerDidFinishSuccessfully(with: json, triggerId: "")
        
        // ASSERT
        expect(self.actionServicesMock.spyConfirmAction.called).to(equal(true))
        expect(self.actionServicesMock.spyConfirmAction.action.type).to(equal("browser"))
        expect(self.actionServicesMock.spyConfirmAction.action.trackId).to(equal("59a3fcbc53c7dasc0fc018b4578"))
        expect(self.actionServicesMock.spyConfirmAction.action.id).to(equal("599ea2209c309558028asdfab4567"))
        expect(self.actionServicesMock.spyConfirmAction.action.urlString).to(equal("http://www.google.es"))
    }
}
