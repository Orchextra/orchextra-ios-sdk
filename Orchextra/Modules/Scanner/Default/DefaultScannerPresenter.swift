//
//  DefaultScannerPresenter.swift
//  Orchextra
//
//  Created by Jerilyn Gonçalves on 09/02/2018.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

protocol DefaultScannerInput {
    func startModule()
    func userDidCloseScanner()
    func resetValueScanned()
    func scannerDidFinishCapture(value: String, type: String)
}

class DefaultScannerPresenter: DefaultScannerInput {
    
    var vc: ScannerUI?
    var output: DefaultScannerModuleOutput?
    
    private var enableTorchScanner: Bool = false
    
    // MARK: - DefaultScannerInput
    
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
        self.vc?.dismissScanner(completion: {
            self.output?.scannerDidFinish(result: nil, error: ScannerError.cancelledScan)
        })
    }
    
    func userDidTappedTorch() {
        self.enableTorchScanner = !self.enableTorchScanner
        self.vc?.enableTorch(enable: self.enableTorchScanner)
    }

    func resetValueScanned() {
        self.vc?.hideInfo()
    }

    func scannerDidFinishCapture(value: String, type: String) {
        
        let typeValue = (type == "org.iso.QRCode") ? ScannerType.QR : ScannerType.Barcode

        // Show scanned value in the view
        self.vc?.show(scannedValue: value, message: OrchextraController.shared.translations.scannerMessage)
        
        // Finish after a couple of seconds
        DispatchQueue.background(delay: 1.0, completion: {
            // Stop scanner and return result
            self.vc?.stopScanner()
            self.vc?.dismissScanner(completion: {
                self.output?.scannerDidFinish(result: ScannerResult(value: value, type: typeValue), error: nil)
            })
        })
    }
}
