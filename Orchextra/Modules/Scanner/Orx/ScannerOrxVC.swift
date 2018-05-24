//
//  ScannerVC.swift
//  Orchextra
//
//  Created by Judith Medina on 22/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class ScannerOrxVC: GIGScannerVC, ModuleInput, ScannerUI, GIGScannerOutput {
    
    // IBActions
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var infoStatusLabel: UILabel!
    @IBOutlet weak var frameScan: UIImageView!
    @IBOutlet weak var scanningBy: UIImageView!
    @IBOutlet weak var navBarOrx: UINavigationBar!
    @IBOutlet weak var infoLabel: PaddingLabel!
    @IBOutlet weak var titleNav: UINavigationItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    // Private
    
    fileprivate var presenter = ScannerPresenter()
    
    // MARK: - ModuleInput
    
    var outputModule: ModuleOutput?
    
    func start() {
        self.presenter.startModule()
    }
        
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        self.presenter.moduleDidFinish(action: action, completionHandler: completionHandler)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scannerOutput = self
        self.presenter.vc = self
        self.presenter.outputModule = self.outputModule
        self.initializeOrxScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopScanner()
        self.presenter.resetScanner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.isCameraAvailable { granted in
            if !granted {
                self.showCameraPermissionAlert()
            } else {
                self.presenter.startModule()
            }
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
        
        self.viewStatus.alpha = 0
        self.viewStatus.layer.cornerRadius = 5
        self.view.bringSubview(toFront: self.viewStatus)
    }
    
    @IBAction func torchTapped(_ sender: Any) {
        self.presenter.userDidTappedTorch()
    }
    
    @IBAction func closeScannerTapped(_ sender: Any) {
        self.presenter.userDidCloseScanner()
    }
    
    // MARK: - ScannerUI
    
    func showScanner() {
        self.startScanning()
    }
    
    func stopScanner() {
        self.stopScanning()
        // !!! Scanning cancelled, if dummy scanner, return completion with error
    }
    
    func enableTorch(enable: Bool) {
        self.enableTorch(enable)
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
    
    func show(image: String, message: String) {
        self.infoStatusLabel.text = message
        UIView.animate(withDuration: 0.3,
                       delay: 0.5,
                       options: .curveEaseInOut, animations: {
            self.viewStatus.alpha = 0.8
            
        }) { _ in
            self.animateRemoveViewStatus()
        }
    }
    
    func animateRemoveViewStatus() {
        UIView.animate(withDuration: 0.1,
                       delay: 0.6,
                       options: .curveEaseInOut, animations: {
                        self.viewStatus.alpha = 0
        }, completion: nil)
    }

    func hideInfo() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                self.infoLabel.alpha = 0
            }
        }
    }
    
    // MARK: - GIGScannerDelegate
    
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

// MARK: - UINavigationBarDelegate

extension ScannerOrxVC: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}
