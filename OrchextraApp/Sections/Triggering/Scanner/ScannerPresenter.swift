//
//  ScannerPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import UIKit

protocol ScannerPresenterInput {
    func userDidTapOrchextraScanner()
    func userDidTapCustomScanner()
    func userTappedScannedValue(value: String, qr: Bool)
}

protocol ScannerUI: class {
    
}

struct ScannerPresenter {
    // MARK: - Public attributes
    
    weak var view: ScannerUI?
    let wireframe: ScannerWireframe
    
    // MARK: - Interactors
    
    let interactor: ScannerInteractorInput
}

extension ScannerPresenter: ScannerPresenterInput {
    func userDidTapOrchextraScanner() {
        self.interactor.openOrchextraScanner()
    }
    
    func userDidTapCustomScanner() {
        self.interactor.invalidatePreviousScanner()
        self.wireframe.openCustomScanner()
    }
    
    func userTappedScannedValue(value: String, qr: Bool) {
        let scannerModuleMock = ModuleMock()
        let type = qr ? "qr" : "barcode"
        
        OrchextraWrapperApp.shared.setScanner(vc: scannerModuleMock)
        scannerModuleMock.outputModule?.triggerWasFire(with: ["value": value,
                                                 "type": type],
                                          module: scannerModuleMock)
    }
}
