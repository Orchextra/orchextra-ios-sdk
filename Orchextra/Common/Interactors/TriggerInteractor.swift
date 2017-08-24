//
//  TriggerInteractor.swift
//  Orchextra
//
//  Created by Judith Medina on 21/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

class TriggerInteractor {
    
    let service: TriggerService
    
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
                print("Trigger launched")
                break
            case .error (let error):
                print("Trigger error: \(error.localizedDescription)")

                break
            }
        }
    }
}
