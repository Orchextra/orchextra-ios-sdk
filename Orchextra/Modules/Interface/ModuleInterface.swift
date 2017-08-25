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
    
    /// Start module
    func start()
    
    /// Set config
    ///
    /// - Parameter config: dictionary with all configuration settings
    func setConfig(config: [String: Any])
    
    /// Finish module
    func finish()
}

public protocol ModuleOutput {
    
    /// Trigger has been fired from module with
    /// a dictionary of values
    ///
    /// - Parameters:
    ///   - values: values to start the trigger against orx
    ///   - module: the own module
    func triggerWasFire(with values: [String: Any], module: ModuleInput)
}
