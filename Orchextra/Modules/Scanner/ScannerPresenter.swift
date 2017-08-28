//
//  ScannerPresenter.swift
//  Orchextra
//
//  Created by Judith Medina on 22/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

protocol ScannerUI {
    func showScanner()
    func stopScanner()
    func dismissScanner()
    func show(scannedValue: String, message: String)
    func hideInfo()
    func showCameraPermissionAlert()
}

protocol ScannerInput {
    func viewDidLoad()
    func userDidCloseScanner()
    func resetValueScanned()
    func scannerDidFinishCapture(value: String, type: String)
}

enum ScannerType: String {
    case Barcode = "barcode"
    case QR = "qr"
}

class ScannerPresenter: ScannerInput {
    
    var vc: (ScannerUI & ModuleInput)?
    var outputModule: ModuleOutput?
    
    private var waitingUntilResponseFromOrx: Bool = false
    
    // MARK: - ScannerInput
    
    func viewDidLoad() {
        self.vc?.showScanner()
    }
    
    func userDidCloseScanner() {
        self.vc?.dismissScanner()
    }
    
    func resetValueScanned() {
        self.waitingUntilResponseFromOrx = false
        self.vc?.hideInfo()
    }

    func scannerDidFinishCapture(value: String, type: String) {
        
        var typeValue = ScannerType.Barcode

        if type == "org.iso.QRCode" {
            typeValue = ScannerType.QR
        }

        if !self.waitingUntilResponseFromOrx {
            self.waitingUntilResponseFromOrx = true
            // Track activity statistics
            
            // Show in the view the scanned value
            self.vc?.show(scannedValue: value, message: kLocaleOrcScanningMessage)
            guard let moduleInput = self.vc else {
                LogWarn("Scanner ")
                return
            }
            self.vc?.stopScanner()
            DispatchQueue.background(delay: 0.8, completion:{
                self.outputModule?.triggerWasFire(with: ["value" : value,
                                                         "type" : typeValue.rawValue],
                                                  module: moduleInput)
                LogDebug("Module Scan - has trigger: \(value) - \(type)")
            })
            
        }
    }
}
