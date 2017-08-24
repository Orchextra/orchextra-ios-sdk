//
//  TriggerInteractor.swift
//  Orchextra
//
//  Created by Judith Medina on 21/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation


protocol TriggerInteractorOutput {
//    func triggerDidFinishSuccessfully(action: Action)
    func triggerDidFinishSuccessfully()
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
    
    func trigger(values: [String: Any]) {
        self.service.launchTrigger(values: values) { result in
            switch result {
            case .success:
                self.output?.triggerDidFinishSuccessfully()
                print("Trigger launched")
                break
            case .error (let error):
                print("Trigger error: \(error.localizedDescription)")

                break
            }
        }
    }
}
