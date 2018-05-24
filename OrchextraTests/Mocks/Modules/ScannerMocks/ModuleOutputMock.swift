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
    
    var completionConfigInput: [String : Any]?
    
    var spyTriggerWasFire = (called: false, values: ["": "" as Any])
    var spyTriggerWasFireModuleInput: ModuleInput?
    var spySetConfig: (called: Bool, config: [String : Any]?) = (called: false, config: nil)
    
    func triggerWasFired(with values: [String: Any], module: ModuleInput) {
        self.spyTriggerWasFire.called = true
        self.spyTriggerWasFire.values = values
        self.spyTriggerWasFireModuleInput = module
    }
    
    func fetchModuleConfig(config: [String : Any]?, completion: @escaping (([String : Any]) -> Void)) {
        self.spySetConfig.called = true
        self.spySetConfig.config = config
        
        guard let input = self.completionConfigInput else {
            return
        }
        completion(input)
    }
}
