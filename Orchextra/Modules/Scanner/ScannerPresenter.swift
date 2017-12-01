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
    func enableTorch(enable: Bool)
    func dismissScanner(completion: (() -> Void)?)
    func show(scannedValue: String, message: String)
    func show(image: String, message: String)
    func hideInfo()
    func showCameraPermissionAlert()
}

protocol ScannerInput {
    func startModule()
    func userDidCloseScanner()
    func resetValueScanned()
    func scannerDidFinishCapture(value: String, type: String)
    func moduleDidFinish(action: Action?, completionHandler: (() -> Void)?)
}

enum ScannerType: String {
    case Barcode = "barcode"
    case QR = "qr"
}

class ScannerPresenter: ScannerInput {
    
    var vc: (ScannerUI & ModuleInput)?
    var outputModule: ModuleOutput?
    
    private var waitingUntilResponseFromOrx: Bool = false
    private var enableTorchScanner: Bool = false

    
    // MARK: - ScannerInput
    
    func startModule() {
        self.resetValueScanned()
        self.vc?.showScanner()
    }
    
    func resetScanner() {
        self.enableTorchScanner = false
        self.vc?.enableTorch(enable: self.enableTorchScanner)
    }
    
    func userDidCloseScanner() {
        self.enableTorchScanner = false
        self.vc?.enableTorch(enable: self.enableTorchScanner)
        self.vc?.dismissScanner(completion: nil)
    }
    
    func userDidTappedTorch() {
        self.enableTorchScanner = !self.enableTorchScanner
        self.vc?.enableTorch(enable: self.enableTorchScanner)
    }
    
    func moduleDidFinish(action: Action?, completionHandler: (() -> Void)?) {
        if action != nil {
            self.vc?.stopScanner()
            self.vc?.dismissScanner {
                if let completion = completionHandler {
                    completion()
                }
            }
        } else {
            self.vc?.hideInfo()
            self.vc?.show(image: "Fail_cross", message: kLocaleOrcMatchNotFoundMessage)
            DispatchQueue.background(delay: 1.5, completion: {
                if let completion = completionHandler {
                    completion()
                }
            })
        }
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
            DispatchQueue.background(delay: 0.8, completion: {
                self.outputModule?.triggerWasFire(with: ["value": value,
                                                         "type": typeValue.rawValue],
                                                  module: moduleInput)
                LogInfo("Module Scan - has trigger: \(value) - \(type)")
            })
            
        }
    }
}
