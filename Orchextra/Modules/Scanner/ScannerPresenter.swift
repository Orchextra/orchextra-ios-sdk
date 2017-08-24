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
    func showImage(status: String, message: String)
    func showCameraPermissionAlert()
}

protocol ScannerInput {
    func viewDidLoad()
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
    
    // MARK: -
    
    func viewDidLoad() {
        self.vc?.showScanner()
    }
    
    func userDidCloseScanner() {
        self.vc?.dismissScanner()
    }
    
    func resetValueScanned() {
        self.waitingUntilResponseFromOrx = false
    }

    func scannerDidFinishCapture(value: String, type: String) {
        
        var type = ScannerType.Barcode

        if type.rawValue == "org.iso.QRCode" {
            type = ScannerType.QR
        }

        if !self.waitingUntilResponseFromOrx {
            self.waitingUntilResponseFromOrx = true
            // Track activity statistics
            
            // Show in the view the scanned value
            self.vc?.show(scannedValue: value, message: "<Scanning>")
            guard let moduleInput = self.vc else {
                LogWarn("Scanner ")
                return
            }
            
            self.outputModule?.triggerWasFire(with: ["value" : value,
                                                     "type" : type.rawValue],
                                              module: moduleInput)
            
            LogDebug("Scanned: \(value) - \(type)")
        }
    }
}
