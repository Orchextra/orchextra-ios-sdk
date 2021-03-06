//
//  TriggerInteractor.swift
//  Orchextra
//
//  Created by Judith Medina on 21/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol TriggerInteractorOutput {
    func triggerDidFinishWithoutAction(triggerId: String)
    func triggerDidFinishSuccessfully(with actionJSON: JSON, triggerId: String)
}

class TriggerInteractor {
    
    let service: TriggerService
    var output: TriggerInteractorOutput?
    
    init(service: TriggerService) {
        self.service = service
    }
    
    convenience init() {
        let service = TriggerService()
        self.init(service: service)
    }

    func triggerFired(trigger: Trigger) {
    let values = trigger.urlParams()
        self.service.launchTrigger(values: values) { response in
            switch response {
            case .success(let json):
                self.output?.triggerDidFinishSuccessfully(with: json,
                                                          triggerId: trigger.triggerId)
                logDebug("Found action: \(json.description)")
            case .error (let error):
                switch error {
                case ErrorService.actionNotMatched:
                    logDebug("Action not matched")
                    self.output?.triggerDidFinishWithoutAction(triggerId: trigger.triggerId)
                default:
                    logDebug("Trigger error: \(error.localizedDescription)")
                }
            }
        }
    }
}
