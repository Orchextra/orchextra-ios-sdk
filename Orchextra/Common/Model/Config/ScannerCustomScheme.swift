//
//  ScannerCustomScheme.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

struct ScannerCustomScheme: CustomScheme {
    let url: String
    static func scheme(_ url: String) -> CustomScheme? {
        if url == Config.scannerCustomScheme {
            return ScannerCustomScheme(url: url)
        }
        return nil
    }
    
    func execute() {
        OrchextraWrapper.shared.openScanner()
    }
}
