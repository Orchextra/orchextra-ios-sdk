//
//  CustomScannerVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 6/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary
import Orchextra

class CustomScannerVC: GIGLibrary.GIGScannerVC {
    // MARK: - IBOutlets
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var infoStatusLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var scannerFrameImageView: UIImageView!
    @IBOutlet weak var scannedByImageView: UIImageView!
    
    // MARK: - Attributtes
    var presenter: CustomScannerPresenterInput?
    
    // MARK: - Module Output
    var outputModule: ModuleOutput?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    fileprivate func settingTapped() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
            else {return}
        UIApplication.shared.openURL(settingsURL)
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        self.presenter?.userDidTapCloseScanner()
    }
}

extension CustomScannerVC: GIGLibrary.GIGScannerOutput {
    func didSuccessfullyScan(_ scannedValue: String, type: String) {
        self.presenter?.scannerDidFinishCapture(value: scannedValue, type: type)
    }
}

extension CustomScannerVC: CustomScannerUI {
    func initializeSubviews() {
        self.title = "Custom scanner"
        self.view.bringSubviewToFront(self.scannerFrameImageView)
        self.view.bringSubviewToFront(self.scannedByImageView)
        
        self.infoLabel.layer.cornerRadius = 5
        self.infoLabel.alpha = 0
        self.view.bringSubviewToFront(self.infoLabel)
        
        self.viewStatus.alpha = 0
        self.viewStatus.layer.cornerRadius = 5
        self.view.bringSubviewToFront(self.viewStatus)
        
        guard let outputModule = self.outputModule else { return }
        self.scannerOutput = self
        self.presenter?.setOutputModule(outputModule: outputModule)
        self.presenter?.startModule()
    }
    
    func showScanner() {
        self.startScanning()
    }
    
    func stopScanner() {
        self.stopScanning()
    }
    
    func showCameraPermissionAlert() {
        let alert = Alert(
            title: "Camera use not allowed",
            message: "You have not permission to use device camera. You must to enable it from 'Settings'"
        )
        
        alert.addCancelButton("Cancel", usingAction: nil)
        alert.addDefaultButton("Settings") { _ in
            self.settingTapped()
        }
        alert.show()
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
            UIView.animate(withDuration: 0.1,
                           delay: 0.6,
                           options: .curveEaseInOut, animations: {
                            self.viewStatus.alpha = 0
            }, completion: nil)
        }
    }
    
    func hideInfo() {
        UIView.animate(withDuration: 0.1) {
            self.infoLabel.alpha = 0
        }
    }
}

extension CustomScannerVC: ModuleInput {
    
    func start() {
        self.presenter?.startModule()
    }
    
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        self.presenter?.moduleDidFinish(action: action, completionHandler: completionHandler)
    }
}

extension CustomScannerVC: Instantiable {
    
    // MARK: - Instantiable
    
    static var storyboard = "Scanner"
    static var identifier = "CustomScannerVC"

}
