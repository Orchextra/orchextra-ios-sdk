//
//  ModuleOutputMock.swift
//  Orchextra
//
//  Created by Judith Medina on 30/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import XCTest
import Foundation
@testable import Orchextra

class ModuleOutputMock: ModuleOutput {
    
    var spyTriggerWasFire = (called: false, values: ["": "" as Any])
    var spyTriggerWasFireModuleInput: ModuleInput?
    var expectation: XCTestExpectation?
    
    func triggerWasFire(with values: [String: Any], module: ModuleInput) {
        self.spyTriggerWasFire.called = true
        self.spyTriggerWasFire.values = values
        self.spyTriggerWasFireModuleInput = module
        self.expectation?.fulfill()
    }
    
    func setConfig(config: [String : Any]?, completion: @escaping (([String : Any]) -> Void)) {
        
    }
}
