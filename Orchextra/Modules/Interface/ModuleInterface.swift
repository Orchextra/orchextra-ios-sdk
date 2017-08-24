//
//  ModuleInterface.swift
//  Orchextra
//
//  Created by Judith Medina on 21/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

public protocol ModuleInput {
    
    var outputModule: ModuleOutput? { get set }
    
    func start()
    func setConfig(config: [String: Any])
    func finish()
}

public protocol ModuleOutput {
    func triggerWasFire(with values: [String: Any])
}
