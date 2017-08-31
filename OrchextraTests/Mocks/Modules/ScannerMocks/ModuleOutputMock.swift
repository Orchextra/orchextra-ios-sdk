//
//  ModuleOutputMock.swift
//  Orchextra
//
//  Created by Judith Medina on 30/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
@testable import Orchextra

class ModuleOutputMock: ModuleOutput {
    
    var spyTriggerWasFire: (called: Bool, values: [String: Any], module: ModuleInput)?

    func triggerWasFire(with values: [String: Any], module: ModuleInput) {
        self.spyTriggerWasFire?.called = true
        self.spyTriggerWasFire?.values = values
        self.spyTriggerWasFire?.module = module
    }
}
