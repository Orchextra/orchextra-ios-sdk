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
        guard let trigger = TriggerFactory.trigger(from: values) else {
            LogWarn("We can't match the trigger fired")
            return
        }
        
        self.module = module
        self.interactor.triggerFired(trigger: trigger)
        LogDebug("Params: \(trigger.urlParams())")
    }
}

// MARK: - TriggerInteractorOutput

extension TriggerManager: TriggerInteractorOutput {
        
    func triggerDidFinishSuccessfully(with actionJSON: JSON, triggerId: String) {
        let action = ActionFactory.action(from: actionJSON)
        self.module?.finish()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            action?.executable()
        }
    }
    
    func triggerDidFinishWithoutAction(triggerId: String) {
        
        if  triggerId == TriggerType.triggerBarcode ||
            triggerId == TriggerType.triggerQR {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.module?.start()
            }
        } else {
            self.module?.start()
        }
    }
}
