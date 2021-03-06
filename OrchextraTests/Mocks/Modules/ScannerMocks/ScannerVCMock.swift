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

class ScannerVCMock: UIViewController, ScannerUI, ModuleInput {
  
    // MARK: - Attributes
    var expectation: XCTestExpectation?
    var spyShowScannerCalled = false
    var spyStopScannerCalled = false
    var spyDismissScanner: (called: Bool, completion: (() -> Void)?) = (called: false, completion: nil)
    var spyHideInfoCalled = false
    var spyShowCameraPermissionAlertCalled = false
    var spyShow = (called: false, scannedValue: "", message: "")
    var spyShowimage = (called: false, image: "", message: "")
    var spyEnableTorch = (called: false, enable: false)

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
        self.spyDismissScanner.called = true
        self.spyDismissScanner.completion = completion
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
    
    func enableTorch(enable: Bool) {
        self.spyEnableTorch.called = true
        self.spyEnableTorch.enable = enable
    }
    
    func hideInfo() {
        self.spyHideInfoCalled = true
    }
    
    func showCameraPermissionAlert() {
        self.spyShowCameraPermissionAlertCalled = true
    }
    
    // MARK: - ModuleInput

    func start() {
        self.showScanner()
    }
    
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        self.finish(action: action, completionHandler: completionHandler)
    }

}
