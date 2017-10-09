//
//  ModuleOutputWrapper.swift
//  Orchextra
//
//  Created by Judith Medina on 11/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

struct ModuleOutputWrapper: ModuleOutput {
    
    var configInteractor: ConfigInteractorInput
    var triggerManager: TriggerManager
    var module: ModuleInput?

    init(triggerManager: TriggerManager, configInteractor: ConfigInteractor) {
        self.triggerManager = triggerManager
        self.configInteractor = configInteractor
    }
    
    init() {
        let triggerManager = TriggerManager()
        let configInteractor = ConfigInteractor()
        self.init(triggerManager: triggerManager, configInteractor: configInteractor)
    }
    
    func triggerWasFire(with values: [String: Any], module: ModuleInput) {
        self.triggerManager.triggerWasFire(with: values, module: module)
    }
    
    func fetchModuleConfig(config: [String: Any]? = nil, completion: @escaping (([String: Any]) -> Void)) {
        
        var configDefault: [String: Any] = ["geoLocation": ""]
        if let configModule = config {
            configDefault = configModule
        }
        self.configInteractor.loadTriggeringList(geolocation: configDefault) { result in
            completion(result)
        }
    }
}
