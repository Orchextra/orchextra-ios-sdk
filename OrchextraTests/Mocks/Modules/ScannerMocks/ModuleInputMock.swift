//
//  ModuleInputMock.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import XCTest
@testable import Orchextra

class ModuleInputMock: ModuleInput {
    
    var outputModule: ModuleOutput?
        
    var spySetConfig = (called: false, values: ["": "" as Any])
    var spyTriggerWasFireModuleInput: ModuleInput?
    var expectation: XCTestExpectation?
    
    func start() {
        
    }
    
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        if let completion = completionHandler {
            completion()
        }
    }
    
    func setConfig(config: [String : Any]) {
        
    }
}
