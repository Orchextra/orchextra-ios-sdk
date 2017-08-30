//
//  ScannerVCMock.swift
//  Orchextra
//
//  Created by Judith Medina on 30/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Foundation
@testable import Orchextra

class ScannerVCMock: ScannerUI, ModuleInput {
  
    // MARK: - Attributes
    var expectation: XCTestExpectation?
    var spyShowScannerCalled = false
    var spyStopScannerCalled = false
    var spyDismissScannerCalled = false
    var spyHideInfoCalled = false
    var spyShowCameraPermissionAlertCalled = false
    var spyShow = (called: false, scannedValue: "", message: "")
    var spyShowimage = (called: false, image: "", message: "")
    
    // MARK: - Attributes ModuleInput

    var outputModule: ModuleOutput?

    // MARK: - ScannerUI

    func showScanner() {
        self.spyShowScannerCalled = true
    }
    
    func stopScanner() {
        self.spyStopScannerCalled = true
    }
    
    func dismissScanner(completion: (() -> Void)?) {
        self.spyDismissScannerCalled = true
    }
    
    func show(scannedValue: String, message: String) {
        self.spyShow.called = true
        self.spyShow.scannedValue = scannedValue
        self.spyShow.message = message
    }
    
    func show(image: String, message: String) {
        self.spyShowimage.called = true
        self.spyShowimage.image = image
        self.spyShowimage.message = message
    }
    
    func hideInfo() {
        self.spyHideInfoCalled = true
    }
    
    func showCameraPermissionAlert() {
        self.spyShowCameraPermissionAlertCalled = true
    }
    
    // MARK: - ModuleInput

    func start() {
        self.start()
    }
    
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        self.finish(action: action, completionHandler: completionHandler)
    }

}
