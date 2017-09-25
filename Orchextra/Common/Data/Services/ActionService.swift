//
//  ActionService.swift
//  Orchextra
//
//  Created by Judith Medina on 01/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol ActionServicesInput {
    func confirmAction(action: Action, completion: @escaping (Result<Bool, Error>) -> Void)
}

class ActionService: ActionServicesInput {

    let endpointConfirmAction = "/action/confirm/"
    
    func confirmAction(action: Action, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let trackId = action.trackId else {
            LogWarn("Can't confirm action there is not id associated")
            return
        }
        
        let endPoint = endpointConfirmAction + trackId
        
        let request = Request.orchextraRequest(
            method: "POST",
            baseUrl: Config.coreEndpoint,
            endpoint: endPoint)
        
        request.fetch { response in
            switch response.status {
            case .success:
                completion(.success(true))
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                completion(.error(error))
                LogError(response.error)
            }
        }
    }
}
