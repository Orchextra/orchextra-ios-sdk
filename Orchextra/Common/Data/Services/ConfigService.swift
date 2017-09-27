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
    func configCore(completion: @escaping (Result<Bool, Error>) -> Void)
    func configProximity(geoLocation: [String: Any], completion: @escaping (Result<JSON, Error>) -> Void)
}

class ConfigService: ConfigServiceInput {
    
    let endpointConfig = "/configuration"
    let authInteractor: AuthInteractorInput
    
    init(auth: AuthInteractorInput) {
        self.authInteractor = auth
    }
    
    convenience init() {
        let auth = AuthInteractor()
        self.init(auth: auth)
    }
    
    func configCore(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let apiKey = Session.shared.apiKey else {
            completion(.error(ErrorService.invalidCredentials))
            return
        }
        
        let endPoint = endpointConfig + "/\(apiKey)"
        
        let request = Request(
            method: "GET",
            baseUrl: Config.coreEndpoint,
            endpoint: endPoint,
            verbose: Orchextra.shared.logLevel == .debug)
     
        request.fetch { response in
            switch response.status {
            case .success:
                do {
                    let json = try response.json()
                    LogDebug(json.description)
                    completion(.success(true))
                    
                } catch {
                    completion(.error(ErrorService.invalidJSON))
                    LogError(ErrorService.invalidJSON as NSError)
                }
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                LogError(response.error)
                completion(.error(error))
                break
            }
        }
    }
    
    func configProximity(geoLocation: [String: Any], completion: @escaping (Result<JSON, Error>) -> Void) {

        let request = Request.orchextraRequest(
            method: "POST",
            baseUrl: Config.coreEndpoint,
            endpoint: endpointConfig,
            bodyParams: geoLocation)
        
        self.authInteractor.sendRequest(request: request) { response in
            switch response {
            case .success(let json):
                completion(.success(json))

            case .error(let error):
                LogError(error as NSError)
                completion(.error(error))
                break
            }

        }
    }
    
    
}
