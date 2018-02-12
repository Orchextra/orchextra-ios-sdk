//
//  OrchextraScannerExtension.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 13/12/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
@testable import Orchextra

extension Orchextra {
    /**
     Method to invalidate previous scanner. Only available for demo app and testing
     
     - Since: 3.0
     */
    func invalidatePreviousScanner() {
        OrchextraController.shared.invalidatePreviousScanner()
    }
}
