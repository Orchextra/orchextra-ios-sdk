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
    func scannerDidFinishCapture(value: String, type: String)
}

class ScannerPresenter: ScannerInput {
    
    var vc: ScannerUI?
    
    // MARK: -
    
    func viewDidLoad() {
        self.vc?.showScanner()
    }
 
    
    func scannerDidFinishCapture(value: String, type: String) {
        LogInfo("Scanned: \(value) - \(type)")
    }
    
}
