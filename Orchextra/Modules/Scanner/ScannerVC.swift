//
//  ScannerVC.swift
//  Orchextra
//
//  Created by Judith Medina on 22/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class ScannerVC: GIGScannerVC, ScannerUI, ModuleInput, GIGScannerOutput {
    
    var presenter = ScannerPresenter()
    
    //MARK: - 
    
    override func viewDidLoad() {
        
        self.outputModule
        super.viewDidLoad()
        self.scannerOutput = self
        self.presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - ScannerUI
    
    func showScanner() {
        self.startScanning()
    }
    
    func stopScanner() {
        
    }
    
    func dismissScanner() {
    }
    
    func show(scannedValue: String, message: String) {
    }
    
    func showImage(status: String, message: String) {
        
    }
    
    func showCameraPermissionAlert() {
        
    }
    
    // MARK: - ModuleInput
    
    func start() {
        self.startScanning()
    }
    
    func setConfig(config: [String : Any]) {
        
    }
    
    func finish() {
        self.stopScanner()
    }

    //MARK: - GIGScannerDelegate
    
    func didSuccessfullyScan(_ scannedValue: String, type: String) {
        self.presenter.scannerDidFinishCapture(value: scannedValue, type: type)
    }
    

}


