//
//  ModuleOutputWrapperMock.swift
//  OrchextraTests
//
//  Created by Judith Medina on 20/11/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
@testable import Orchextra

class ModuleOutputWrapperMock: ModuleOutput {
    
    func triggerWasFire(with values: [String: Any], module: ModuleInput) {
    }
    
    func fetchModuleConfig(config: [String: Any]? = nil, completion: @escaping (([String: Any]) -> Void)) {
    }
}
