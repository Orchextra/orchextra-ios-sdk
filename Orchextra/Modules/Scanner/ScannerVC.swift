//
//  ScannerVC.swift
//  Orchextra
//
//  Created by Judith Medina on 22/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class ScannerVC: GIGScannerVC, ScannerUI, GIGScannerOutput {
    
    @IBOutlet weak var frameScan: UIImageView!
    @IBOutlet weak var scanningBy: UIImageView!
    @IBOutlet weak var navBarOrx: UINavigationBar!
    
    // Protocol
    var outputModule: ModuleOutput?
    
    // Private
    fileprivate var presenter = ScannerPresenter()
    private var enableTorchScanner: Bool = false

    //MARK: - 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scannerOutput = self
        self.presenter.vc = self
        self.presenter.outputModule = self.outputModule
        self.presenter.viewDidLoad()
        
        self.initializeOrxScanner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func initializeOrxScanner() {
        self.view.bringSubview(toFront: self.frameScan)
        self.view.bringSubview(toFront: self.scanningBy)
        self.view.bringSubview(toFront: self.navBarOrx)
    }
    
    @IBAction func torchTapped(_ sender: Any) {
        self.enableTorchScanner = !self.enableTorchScanner
        self.enableTorch(self.enableTorchScanner)
    }
    
    @IBAction func closeScannerTapped(_ sender: Any) {
        self.dismissScanner()
    }
    
    //MARK: - ScannerUI
    
    func showScanner() {
        self.startScanning()
    }
    
    func stopScanner() {
        self.stopScanning()
    }
    
    func dismissScanner() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func show(scannedValue: String, message: String) {
    }
    
    func showImage(status: String, message: String) {
        
    }
    
    func showCameraPermissionAlert() {
        
    }
    
    //MARK: - GIGScannerDelegate
    
    func didSuccessfullyScan(_ scannedValue: String, type: String) {
        self.presenter.scannerDidFinishCapture(value: scannedValue, type: type)
    }
}

// MARK: - ModuleInput

extension ScannerVC: ModuleInput {
    
    func start() {
        self.showScanner()
    }
    
    func setConfig(config: [String : Any]) {
        
    }
    
    func finish() {
        self.stopScanner()
        self.presenter.resetValueScanned()
        self.dismissScanner()
    }
}

// MARK: - UINavigationBarDelegate

extension ScannerVC: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

