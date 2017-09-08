//
//  ConfigService.swift
//  Orchextra
//
//  Created by Judith Medina on 17/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol ConfigServiceInput {
    func configCore(completion: @escaping (Result<String, Error>) -> Void)
}

class ConfigService: ConfigServiceInput {
    
    let endpointConfig = "/configuration"

    func configCore(completion: @escaping (Result<String, Error>) -> Void) {
        
        let geoPosition = [
            "geoLocation" : [
                "country" : "España",
                "countryCode" : "ES",
                "locality" : "Getafe",
                "zip": 28027,
                "street" : "Calle Doctor Zamehoff",
                "point" :   [
                "lat" : "43.445811",
                "lng" : "-6.627472"]
            ]
        ]
        
        let request = Request.OrchextraRequest(
            method: "POST",
            baseUrl: Config.coreEndpoint,
            endpoint: endpointConfig,
            bodyParams: geoPosition)
     
        request.fetch { response in
            switch response.status {
            case .success:
                do {
                    let json = try response.json()
                    LogDebug(json.description)
                    completion(.success(""))
                    
                } catch {
                    let error = ErrorService.unknown
                    LogError(error as NSError)
                    completion(.error(error))
                }
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                LogError(response.error)
                completion(.error(error))
                break
                
            }
        }
    }
}
