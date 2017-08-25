//
//  TriggerManager.swift
//  Orchextra
//
//  Created by Judith Medina on 24/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

class TriggerManager: ModuleOutput {
    
    var interactor: TriggerInteractor
    var module: ModuleInput?
    
    convenience init() {
        let interactor = TriggerInteractor()
        self.init(interactor: interactor)
    }
    
    init(interactor: TriggerInteractor) {
        self.interactor = interactor
        self.interactor.output = self
    }
    
    // MARK: - PRIVATE
    
    // MARK: - ModuleOutput
    
    func triggerWasFire(with values: [String : Any], module: ModuleInput) {
        self.module = module
        let params = ["type" : "barcode",
                         "value" : values["value"]!]
        
        self.interactor.trigger(values: params)
        LogDebug("TRIGGER WAS FIRE: \(params)")
    }

}

// MARK: - TriggerInteractorOutput

extension TriggerManager: TriggerInteractorOutput {
    
    func triggerDidFinishSuccessfully() {
        self.module?.finish()
    }
}
