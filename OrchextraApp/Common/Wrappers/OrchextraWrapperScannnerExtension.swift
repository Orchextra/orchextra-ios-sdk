//
//  OrchextraWrapperScannnerExtension.swift
//  OrchextraApp
//
//  Created by Carlos Vicente on 13/12/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
@testable import Orchextra

extension OrchextraController {
    func invalidatePreviousScanner() {
        self.scanner?.outputModule = nil
        self.scanner = nil
    }
}
