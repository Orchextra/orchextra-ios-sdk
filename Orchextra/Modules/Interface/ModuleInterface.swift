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
    
    /// Finish module
    ///
    /// - Parameters:
    ///   - action: send action if ORX found it
    ///   - completionHandler: wait until module finish
    func finish(action: Action?, completionHandler: (() -> Void)?)
    
    /// Set Configuration for an specific module
    ///
    /// - Parameter params:
    func setConfig(params: [String: Any])
}

public extension ModuleInput {
    
    /// Set config is optional only will get configuration if the module need it.
    ///
    /// - Parameter params: config details
    func setConfig(params: [String: Any]) {}
}

public protocol ModuleOutput {
    
    /// Trigger has been fired from module with
    /// a dictionary of values
    ///
    /// - Parameters:
    ///   - values: values to start the trigger against orx
    ///   - module: the own module
    func triggerWasFire(with values: [String: Any], module: ModuleInput)
    
    /// Fetch Module Configuration without params
    ///
    /// - Parameters:
    ///   - config: params to get the config from the core
    ///   - completion: the configuration response for the module
    func fetchModuleConfig(completion: @escaping (([String: Any]) -> Void))
    
    /// Fetch Module Configuration with params from module
    ///
    /// - Parameters:
    ///   - config: params to get the config from the core
    ///   - completion: the configuration response for the module
    func fetchModuleConfig(config: [String: Any]?, completion: @escaping (([String: Any]) -> Void))
}

public extension ModuleOutput {
    
    /// Set Config
    ///
    /// - Parameters:
    ///   - config: params to get the config from the core
    ///   - completion: the configuration response for the module
    func fetchModuleConfig(completion: @escaping (([String: Any]) -> Void)) {
        self.fetchModuleConfig(config: nil, completion: completion)
    }

    func fetchModuleConfig(config: [String: Any]? = nil, completion: @escaping (([String: Any]) -> Void)) { }

}
