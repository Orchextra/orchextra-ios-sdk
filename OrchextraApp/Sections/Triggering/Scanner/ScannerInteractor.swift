//
//  ScannerInteractor.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

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
    let orchextraWrapper = OrchextraWrapper.shared
}

extension ScannerInteractor: ScannerInteractorInput {
    
    func openOrchextraScanner() {
        self.orchextraWrapper.openOrchextraScanner()
    }
    
    func openCustomScanner() {
        // TODO: Implement
    }
    
    func openImageRecognition() {
        self.orchextraWrapper.openImageRecognition()
    }

}
