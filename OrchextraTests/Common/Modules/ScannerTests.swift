//
//  ScannerTests.swift
//  Orchextra
//
//  Created by Judith Medina on 29/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Nimble
import Foundation
import GIGLibrary
import OHHTTPStubs
@testable import Orchextra


class ScannerTests: XCTestCase {

    // MARK: - Attributes
    
    var presenter: ScannerPresenter!
    var scannerViewMock: ScannerVCMock!
    var moduleOutputMock: ModuleOutputMock!
    
    // MARK: - Setup methods
    
    override func setUp() {
        super.setUp()
        self.scannerViewMock = ScannerVCMock()
        self.moduleOutputMock = ModuleOutputMock()
        self.presenter = ScannerPresenter()
        self.presenter.vc = self.scannerViewMock
        self.presenter.outputModule = self.moduleOutputMock
    }
    
    override func tearDown() {
        self.scannerViewMock = nil
        self.presenter = nil
        self.moduleOutputMock = nil
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    // MARK: - Test methods
    
    func test_startModule_presenter() {
        
        // ACT
        self.presenter.startModule()
        
        // ASSERT
        expect(self.scannerViewMock.spyHideInfoCalled).toEventually(equal(true))
        expect(self.scannerViewMock.spyShowScannerCalled).toEventually(equal(true))
    }
    
    func test_closeModule() {
        
        // ACT
        self.presenter.userDidCloseScanner()
        
        // ASSERT
        expect(self.scannerViewMock.spyDismissScanner.called).toEventually(equal(true))
    }
    
    func test_moduleDidFinish_withoutAction() {
        
        // ACT
        self.presenter.moduleDidFinish(action: nil, completionHandler: nil)
                
        // ASSERT
        expect(self.scannerViewMock.spyHideInfoCalled).toEventually(equal(true))
        expect(self.scannerViewMock.spyShowimage.called).toEventually(equal(true))
        expect(self.scannerViewMock.spyShowimage.image).toEventually(equal("Fail_cross"))
        expect(self.scannerViewMock.spyShowimage.message).toEventually(equal("Match not found"))
        expect(self.scannerViewMock.spyDismissScanner.completion).toEventually(beNil())

    }
    
    func test_moduleDidFinish_withAction() {
        
        let action = ActionScanner()
        
        // ACT
        self.presenter.moduleDidFinish(action: action) { }

        // ASSERT
        expect(self.scannerViewMock.spyStopScannerCalled).toEventually(equal(true))
        expect(self.scannerViewMock.spyDismissScanner.called).toEventually(equal(true))
        XCTAssertNotNil(self.scannerViewMock.spyDismissScanner.completion)

    }

    func test_resetValueScanned() {
        
        // ACT
        self.presenter.resetValueScanned()
        
        // ASSERT
        expect(self.scannerViewMock.spyHideInfoCalled).toEventually(equal(true))
    }
    
    func test_scannerDidFinishCapture_barcode() {
        
        // ARRANGE
        self.moduleOutputMock.expectation = self.expectation(description: "triggerWasFire_barcode")
        
        // ACT
        self.presenter.scannerDidFinishCapture(value: "97870980", type: "ios.Barcode")
        
        // ASSERT
        expect(self.scannerViewMock.spyShow.called).toEventually(equal(true))
        expect(self.scannerViewMock.spyShow.message).toEventually(equal(kLocaleOrcScanningMessage))
        expect(self.scannerViewMock.spyShow.scannedValue).toEventually(equal("97870980"))
        expect(self.moduleOutputMock.spyTriggerWasFire.called).toEventually(equal(true))
        
        // Values send it to the Orx
        let type = self.moduleOutputMock.spyTriggerWasFire.values["type"] as? String
        expect(type).toEventually(equal("barcode"))
        
        let value = self.moduleOutputMock.spyTriggerWasFire.values["value"] as? String
        expect(value).toEventually(equal("97870980"))
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
    }

    func test_scannerDidFinishCapture_qr() {
        
        // ARRANGE
        self.moduleOutputMock.expectation = self.expectation(description: "triggerWasFire_qr")
        
        // ACT
        self.presenter.scannerDidFinishCapture(value: "Hi world", type: "org.iso.QRCode")
        
        // ASSERT
        expect(self.scannerViewMock.spyShow.called).toEventually(equal(true))
        expect(self.scannerViewMock.spyShow.message).toEventually(equal(kLocaleOrcScanningMessage))
        expect(self.scannerViewMock.spyShow.scannedValue).toEventually(equal("Hi world"))
        expect(self.moduleOutputMock.spyTriggerWasFire.called).toEventually(equal(true))
        
        // Values send it to the Orx
        let type = self.moduleOutputMock.spyTriggerWasFire.values["type"] as? String
        expect(type).toEventually(equal("qr"))
        
        let value = self.moduleOutputMock.spyTriggerWasFire.values["value"] as? String
        expect(value).toEventually(equal("Hi world"))

        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
}
