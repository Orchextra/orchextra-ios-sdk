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
}

public protocol ModuleOutput {
    
    /// Trigger has been fired from module with
    /// a dictionary of values
    ///
    /// - Parameters:
    ///   - values: values to start the trigger against orx
    ///   - module: the own module
    func triggerWasFire(with values: [String: Any], module: ModuleInput)
    
    /// Set Config
    ///
    /// - Parameters:
    ///   - config: params to get the config from the core
    ///   - completion: the configuration response for the module
    func setConfig(completion: @escaping (([String : Any]) -> Void))
    
    /// Set Config
    ///
    /// - Parameters:
    ///   - config: params to get the config from the core
    ///   - completion: the configuration response for the module
    func setConfig(config: [String : Any]?, completion: @escaping (([String : Any]) -> Void))
    
    
    
    func sendRequest(request: URLRequest)
}


extension ModuleOutput {
    
    /// Set Config
    ///
    /// - Parameters:
    ///   - config: params to get the config from the core
    ///   - completion: the configuration response for the module

    func setConfig(completion: @escaping (([String : Any]) -> Void)) {
        self.setConfig(config: nil, completion: completion)
    }

    func setConfig(config: [String : Any]? = nil, completion: @escaping (([String : Any]) -> Void)) { }
    
    func sendRequest(request: URLRequest) {}

}
