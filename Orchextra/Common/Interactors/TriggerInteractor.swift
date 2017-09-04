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
    func triggerDidFinishSuccessfully(with actionJSON: JSON)
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
                self.output?.triggerDidFinishSuccessfully(with: json)
                LogDebug("Found action: \(json.description)")
                break
            case .error (let error):
                self.output?.triggerDidFinishWithoutAction(triggerId: trigger.triggerId)
                print("Trigger error: \(error.localizedDescription)")
                break
            }
        }
    }
}
