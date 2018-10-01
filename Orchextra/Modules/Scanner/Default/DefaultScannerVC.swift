//
//  DefaultScannerVC.swift
//  Orchextra
//
//  Created by Jerilyn Gonçalves on 09/02/2018.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class DefaultScannerVC: GIGScannerVC, DefaultScannerModuleInput {
    
    // Outlets
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var infoStatusLabel: UILabel!
    @IBOutlet weak var frameScan: UIImageView!
    @IBOutlet weak var scanningBy: UIImageView!
    @IBOutlet weak var navBarOrx: UINavigationBar!
    @IBOutlet weak var infoLabel: PaddingLabel!
    @IBOutlet weak var titleNav: UINavigationItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    // Private
    
    fileprivate var presenter = DefaultScannerPresenter()
    
    // MARK: - DefaultScannerModuleInput
    
    var moduleOutput: DefaultScannerModuleOutput?
    
    func start() {
        self.presenter.startModule()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scannerOutput = self
        self.presenter.vc = self
        self.presenter.output = self.moduleOutput
        self.initializeScanner()
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
    
    // MARK: - User interaction

    @IBAction func torchTapped(_ sender: Any) {
        self.presenter.userDidTappedTorch()
    }
    
    @IBAction func closeScannerTapped(_ sender: Any) {
        self.presenter.userDidCloseScanner()
    }
    
    // MARK: - Private
    
    private func initializeScanner() {
        
        self.titleNav.title = OrchextraController.shared.translations.scannerTitle
        self.cancelBarButton.title = OrchextraController.shared.translations.cancelButtonTitle
        
        self.infoLabel.layer.cornerRadius = 5
        self.infoLabel.contentInset = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        
        self.view.bringSubviewToFront(self.frameScan)
        self.view.bringSubviewToFront(self.scanningBy)
        self.view.bringSubviewToFront(self.navBarOrx)
        
        self.infoLabel.alpha = 0
        self.view.bringSubviewToFront(self.infoLabel)
        
        self.viewStatus.alpha = 0
        self.viewStatus.layer.cornerRadius = 5
        self.view.bringSubviewToFront(self.viewStatus)
    }
    
    internal func showCameraPermissionAlert() {
        let alert = Alert(
            title: OrchextraController.shared.translations.cameraPermissionDeniedTitle,
            message: OrchextraController.shared.translations.cameraPermissionDeniedMessage
        )
        alert.addCancelButton(OrchextraController.shared.translations.cancelButtonTitle, usingAction: nil)
        alert.addDefaultButton(OrchextraController.shared.translations.settingsButtonTitle) { _ in
            self.settingTapped()
        }
        alert.show()
    }
    
    private func settingTapped() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
            else {return}
        UIApplication.shared.openURL(settingsURL)
    }
}

// MARK: - ScannerUI

extension DefaultScannerVC: ScannerUI {
    
    func showScanner() {
        self.startScanning()
    }
    
    func stopScanner() {
        self.stopScanning()
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
    
    private func animateRemoveViewStatus() {
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

}

// MARK: - GIGScannerOutput

extension DefaultScannerVC: GIGScannerOutput {
    
    func didSuccessfullyScan(_ scannedValue: String, type: String) {
        self.presenter.scannerDidFinishCapture(value: scannedValue, type: type)
    }
}

// MARK: - UINavigationBarDelegate

extension DefaultScannerVC: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}
