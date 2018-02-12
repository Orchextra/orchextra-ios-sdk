//
//  DefaultScannerModule.swift
//  Orchextra
//
//  Created by Jerilyn Goncalves on 09/02/2018.
//  Copyright © 2018 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol DefaultScannerModuleInput {
    var moduleOutput: DefaultScannerModuleOutput? { get set }
    func start()
}

protocol DefaultScannerModuleOutput {
    func scannerDidFinish(result: ScannerResult?, error: ScannerError?)
}

class DefaultScannerModule: DefaultScannerModuleOutput {
    
    private var completionHandler: ((Result<ScannerResult, ScannerError>) -> Void)
    
    // MARK: - Initializer
    
    init(completion: @escaping (Result<ScannerResult, ScannerError>) -> Void) {
        self.completionHandler = completion
    }
    
    func start() {
        
        let wireframe = OrchextraController.shared.wireframe
        var scanner = wireframe.defaultScanner()
        
        guard let scannerVC = scanner as? UIViewController else {
            return
        }
        scanner?.moduleOutput = self
        wireframe.openScanner(scanner: scannerVC)
        scanner?.start()
    }
    
    // MARK: - DefaultScannerOutput
    
    func scannerDidFinish(result: ScannerResult?, error: ScannerError?) {
        if let result = result {
            self.completionHandler(.success(result))
        } else {
            self.completionHandler(.error(error ?? .unknown))
        }
    }
}
