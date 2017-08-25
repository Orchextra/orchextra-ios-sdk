//
//  ScannerInteractor.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Orchextra

protocol ScannerInteractorInput {
    func openOrchextraScanner()
    func openCustomScanner()
    func openImageRecognition()
}

protocol ScannerInteractorOutput {
    
}

struct ScannerInteractor {
    
    // MARK: - Attributes
    
    var output: TriggeringInteractorOutput?
    let orchextra = Orchextra.shared
}

extension ScannerInteractor: ScannerInteractorInput {
    
    func openOrchextraScanner() {
        self.orchextra.openScanner()
    }
    
    func openCustomScanner() {
        // TODO: Implement
    }
    
    func openImageRecognition() {
        self.orchextra.openImageRecognition()
    }

}
