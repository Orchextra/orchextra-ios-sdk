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
    
    @IBOutlet weak var frameScan: UIImageView!
    @IBOutlet weak var scanningBy: UIImageView!
    @IBOutlet weak var navBarOrx: UINavigationBar!
    
    
    var presenter = ScannerPresenter()
    var outputModule: ModuleOutput?
    
    private var enableTorchScanner: Bool = false

    //MARK: - 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scannerOutput = self
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
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - ScannerUI
    
    func showScanner() {
        self.startScanning()
    }
    
    func stopScanner() {
        self.stopScanning()
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

extension ScannerVC: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

