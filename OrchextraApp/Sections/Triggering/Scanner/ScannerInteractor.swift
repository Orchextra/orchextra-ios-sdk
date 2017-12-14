//
//  ScannerInteractor.swift
//  Orchextra
//
//  Created by Carlos Vicente on 24/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol ScannerInteractorInput {
    func invalidatePreviousScanner()
    func openOrchextraScanner()
}

struct ScannerInteractor {
    
    // MARK: - Attributes
    
    var output: TriggeringInteractorOutput?
    let orchextraWrapper = OrchextraWrapper.shared
}

extension ScannerInteractor: ScannerInteractorInput {
    
    func invalidatePreviousScanner() {
//        self.orchextraWrapper.invalidatePreviousScanner()
    }
    
    func openOrchextraScanner() {
//        self.orchextraWrapper.invalidatePreviousScanner()
        self.orchextraWrapper.openOrchextraScanner()
    }
}
