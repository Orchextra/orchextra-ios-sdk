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
    
    func triggerWasFire(with values: [String : Any], module: ModuleInput) {
        
        guard let trigger = TriggerFactory.trigger(from: values) else {
            LogWarn("We can't match the trigger fired")
            return
        }
        
        self.module = module
        self.interactor.triggerFired(trigger: trigger)
        
        // Inform the integrative app about the trigger
        Orchextra.shared.delegate?.triggerFired(trigger)
        
        LogDebug("Params: \(trigger.urlParams())")
    }
    
    func setConfig(config: [String : Any], completion: (([String : Any]) -> Void)) {
        guard let proximity = self.getProximity() else { return }
        completion(proximity)
    }

    // TODO: REMOVE
    func getProximity() -> [String: Any]? {
        guard let geomarketingFile = self.jsonFrom(
            filename: "geomarketing")else {
                return nil
        }
        
        return geomarketingFile
    }

}

// TODO: REMOVE
extension TriggerManager {
    
    func jsonFrom(filename: String) -> [String: Any]? {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json") else {
            LogWarn("\(filename) not found")
            return nil
        }
        
        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
            LogWarn("Unable to convert \(filename) to String")
            return nil
        }
        
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            LogWarn("Unable to convert \(filename) to NSData")
            return nil
        }
        
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            LogWarn("Unable to convert \(filename) to JSON dictionary")
            return nil
        }
        return jsonDictionary
    }
}

// MARK: - TriggerInteractorOutput

extension TriggerManager: TriggerInteractorOutput {
        
    func triggerDidFinishSuccessfully(with actionJSON: JSON, triggerId: String) {
        
        guard let action = ActionFactory.action(from: actionJSON) else {
            LogWarn("Action can't be created")
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
