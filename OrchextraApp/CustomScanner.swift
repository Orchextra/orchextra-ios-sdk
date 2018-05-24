//
//  CustomScanner.swift
//  Orchextra
//
//  Created by Judith Medina on 24/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import Orchextra

class CustomScanner: GIGScannerVC, ModuleInput, GIGScannerOutput {
    
    var outputModule: ModuleOutput?

    override func viewDidLoad() {
        self.scannerOutput = self
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func start() {
        self.startScanning()
    }
    
    func finish() {
        self.stopScanning()
    }
    
    func setConfig(config: [String: Any]) {
        
    }
    
    func didSuccessfullyScan(_ scannedValue: String, type: String) {
        self.outputModule?.triggerWasFire(with: ["value": scannedValue,
                                                 "type": type],
                                          module: self)
    }

}
