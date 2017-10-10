//
//  ScannerVC.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class ScannerVC: UIViewController, ScannerUI {
    // MARK: - IBOutlets
    @IBOutlet weak var orchextraScannerButton: UIButton!
    @IBOutlet weak var customScannerButton: UIButton!
    @IBOutlet weak var imageRecognitionButton: UIButton!
    
    // MARK: - Attributtes    
    var presenter: ScannerPresenterInput?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeSubViews()
        //TODO: Show or hide image recognition using Vuforia if it is not available
    }
    
    // MARK: Utils
    
    private func initializeSubViews() {
        self.orchextraScannerButton.layer.cornerRadius = 6.0
        self.customScannerButton.layer.cornerRadius = 6.0
        self.imageRecognitionButton.layer.cornerRadius = 6.0
    }
    
    // MARK: - Actions
    
    @IBAction func orchextraScannerTapped(_sender: Any) {
        self.presenter?.userDidTapOrchextraScanner()
    }
    
    @IBAction func customScannerTapped(_sender: Any) {
        self.presenter?.userDidTapCustomScanner()
    }
    
    @IBAction func imageRecognitionTapped(_sender: Any) {
        self.presenter?.userDidTapImageRecognition()
    }
}

extension ScannerVC: Instantiable {
    
    // MARK: - Instantiable
    
    static var storyboard = "Triggering"
    static var identifier = "ScannerVC"
    
}
