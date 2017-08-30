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
    @IBOutlet weak var infoLabel: PaddingLabel!
    @IBOutlet weak var titleNav: UINavigationItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isCameraAvailable() {
            self.showCameraPermissionAlert()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func initializeOrxScanner() {
        
        self.titleNav.title = kLocaleOrcScannerTitle
        self.cancelBarButton.title = kLocaleOrcGlobalCancelButton
        
        self.infoLabel.layer.cornerRadius = 5
        self.infoLabel.contentInset = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)

        self.view.bringSubview(toFront: self.frameScan)
        self.view.bringSubview(toFront: self.scanningBy)
        self.view.bringSubview(toFront: self.navBarOrx)
        
        self.infoLabel.alpha = 0
        self.view.bringSubview(toFront: self.infoLabel)
    }
    
    @IBAction func torchTapped(_ sender: Any) {
        self.enableTorchScanner = !self.enableTorchScanner
        self.enableTorch(self.enableTorchScanner)
    }
    
    @IBAction func closeScannerTapped(_ sender: Any) {
        self.dismissScanner(completion: nil)
    }
    
    //MARK: - ScannerUI
    
    func showScanner() {
        if self.isCameraAvailable() {
            self.startScanning()
        }
    }
    
    func stopScanner() {
        self.stopScanning()
    }
    
    func dismissScanner(completion: (() -> Void)?) {
        self.dismiss(animated: true) { 
            if let completion = completion {
                completion()
            }
        }
    }
    
    func show(scannedValue: String, message: String) {
        self.infoLabel.text = "\(message)  \n  \(scannedValue)"
        UIView.animate(withDuration: 0.05) {
            self.infoLabel.alpha = 0.8
        }
    }
    
    func hideInfo() {
        UIView.animate(withDuration: 0.1) {
            self.infoLabel.alpha = 0
        }
    }
    
    //MARK: - GIGScannerDelegate
    
    func didSuccessfullyScan(_ scannedValue: String, type: String) {
        self.presenter.scannerDidFinishCapture(value: scannedValue, type: type)
    }
    
    // MARK: - Private
    
    internal func showCameraPermissionAlert() {
        let alert = Alert(
            title: kLocaleOrcCameraPermissionOffTitle,
            message: kLocaleOrcCameraPermissionOffMessage)
        
        alert.addCancelButton(kLocaleOrcGlobalCancelButton, usingAction: nil)
        alert.addDefaultButton(kLocaleOrcGlobalSettingsButton) { _ in
            self.settingTapped()
        }
        alert.show()
    }
    
    private func settingTapped() {
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
            else {return}
        UIApplication.shared.openURL(settingsURL)
    }
}

// MARK: - ModuleInput

extension ScannerVC: ModuleInput {
    
    func start() {
        self.presenter.resetValueScanned()
        self.showScanner()
    }
    
    func finish(action: Action?, completionHandler: @escaping () -> Void) {
        if let _ = action {
            self.stopScanner()
            self.dismissScanner {
                completionHandler()
            }
        } else {
            self.show(scannedValue: "", message: "NOT MATCH")
            DispatchQueue.background(delay: 0.8, completion:{
                completionHandler()
            })
        }
    }
}

// MARK: - UINavigationBarDelegate

extension ScannerVC: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

