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
    func orxRequest()
}

struct ScannerInteractor {
    
    // MARK: - Attributes
    
    var output: TriggeringInteractorOutput?
    let orchextraWrapper = OrchextraWrapperApp.shared
}

extension ScannerInteractor: ScannerInteractorInput {
    
    func invalidatePreviousScanner() {
        self.orchextraWrapper.invalidatePreviousScanner()
    }
    
    func openOrchextraScanner() {
        self.orchextraWrapper.invalidatePreviousScanner()
        self.orchextraWrapper.openOrchextraScanner()
    }
    
    func orxRequest() {
        let request = Request (
            method: "GET",
            baseUrl: "https://cm.s.orchextra.io",
            endpoint: "/menus",
            headers: self.headers())
        
        self.orchextraWrapper.sendOCMRequest(request: request) { response in
            switch response.status {
            case .success:
                guard let json = try? response.json() else {
                    print("Error")
                    return
                }
                print("Result: \(json)")
            default:
                let error = response.error
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    private func headers() -> [String: String] {
        let acceptLanguage: String = Locale.currentLanguage()
        
        return [
            "Accept-Language": acceptLanguage,
            "X-ocm-version": "IOS_1.0.1"
        ]
    }

}
