//
//  File.swift
//  Orchextra
//
//  Created by Carlos Vicente on 22/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol CustomScheme {
    func execute()
    static func scheme(_ url: String) -> CustomScheme?
}

class CustomSchemeFactory {
    class func customScheme(from url: String) -> CustomScheme? {
        let customSchemes = [
            ScannerCustomScheme.scheme(url)
        ]
        return customSchemes.reduce(nil) { $1 ?? $0 }
    }
}
