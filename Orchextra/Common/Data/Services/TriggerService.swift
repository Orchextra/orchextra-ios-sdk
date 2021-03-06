//
//  TriggerService.swift
//  Orchextra
//
//  Created by Judith Medina on 21/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class TriggerService {
    
    let endpointTrigger = "/action"
    let authInteractor: AuthInteractorInput
    
    init(auth: AuthInteractorInput) {
        self.authInteractor = auth
    }

    convenience init() {
        let auth = AuthInteractor()
        self.init(auth: auth)
    }
    
    func launchTrigger(values: [String: Any], completion: @escaping (Result<JSON, Error>) -> Void) {
        let request = Request.orchextraRequest(
            method: "POST",
            baseUrl: Config.triggeringEndpoint,
            endpoint: endpointTrigger,
            bodyParams: values)
        
        self.authInteractor.sendRequest(request: request, completion: completion)
    }    
}
