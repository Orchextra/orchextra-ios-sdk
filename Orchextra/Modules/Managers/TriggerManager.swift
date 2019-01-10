//
//  TriggerManager.swift
//  Orchextra
//
//  Created by Judith Medina on 24/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import GIGLibrary

protocol TriggerInput {
    func triggerWasFire(with values: [String: Any], module: ModuleInput)
}

class TriggerManager: TriggerInput {
    var interactor: TriggerInteractor
    var actionManager: ActionManager
    var module: ModuleInput?
    
    convenience init() {
        let interactor = TriggerInteractor()
        let actionManager = ActionManager()
        self.init(interactor: interactor, actionManager: actionManager)
    }
    
    init(interactor: TriggerInteractor, actionManager: ActionManager) {
        self.actionManager = actionManager
        self.interactor = interactor
        self.interactor.output = self
    }
    
    // MARK: - PRIVATE
    
    // MARK: - ModuleOutput
    
    func triggerWasFire(with values: [String: Any], module: ModuleInput) {
        
        guard let trigger = TriggerFactory.trigger(from: values) else {
            logWarn("We can't match the trigger fired")
            return
        }
        
        self.module = module
        self.interactor.triggerFired(trigger: trigger)
        
        // Inform the integrative app about the trigger
        Orchextra.shared.delegate?.triggerFired(trigger)

        logDebug("Params: \(trigger.urlParams())")
    }

}

// MARK: - TriggerInteractorOutput

extension TriggerManager: TriggerInteractorOutput {
        
    func triggerDidFinishSuccessfully(with actionJSON: JSON, triggerId: String) {
        
        guard let action = ActionFactory.action(from: actionJSON) else {
            logWarn("Action can't be created")
            return
        }
        
        if  triggerId == TriggerType.triggerBarcode ||
            triggerId == TriggerType.triggerQR {
            self.module?.finish(action: action, completionHandler: {
                self.actionManager.handler(action: action)
            })
        } else {
            self.actionManager.handler(action: action)
        }
    }
    
    func triggerDidFinishWithoutAction(triggerId: String) {
        
        if  triggerId == TriggerType.triggerBarcode ||
            triggerId == TriggerType.triggerQR {
            self.module?.finish(action: nil, completionHandler: {
                self.module?.start()
            })
        } else {
            
        }
    }
}
