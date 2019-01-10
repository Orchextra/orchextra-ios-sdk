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
    func configCore(completion: @escaping (Result<JSON, Error>) -> Void)
    func configTriggering(completion: @escaping (Result<JSON, Error>) -> Void)
    func listTriggering(geoLocation: [String: Any], completion: @escaping (Result<JSON, Error>) -> Void)
}

class ConfigService: ConfigServiceInput {
    
    let endpointConfig = "/configuration"
    let endpointList = "/list"
    
    let authInteractor: AuthInteractorInput
    
    init(auth: AuthInteractorInput) {
        self.authInteractor = auth
    }
    
    convenience init() {
        let auth = AuthInteractor()
        self.init(auth: auth)
    }
    
    func configCore(completion: @escaping (Result<JSON, Error>) -> Void) {
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
                    logDebug(json.description)
                    completion(.success(json))
                    
                } catch {
                    completion(.error(ErrorService.invalidJSON))
                    logError(ErrorService.invalidJSON as NSError)
                }
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                logError(response.error)
                completion(.error(error))
            }
        }
    }
    
    func configTriggering(completion: @escaping (Result<JSON, Error>) -> Void) {
        guard let apiKey = Session.shared.apiKey else {
            completion(.error(ErrorService.invalidCredentials))
            return
        }
        
        let endPoint = endpointConfig + "/\(apiKey)"
        
        let request = Request(
            method: "GET",
            baseUrl: Config.triggeringEndpoint,
            endpoint: endPoint,
            verbose: Orchextra.shared.logLevel == .debug)
        
        request.fetch { response in
            switch response.status {
            case .success:
                do {
                    let json = try response.json()
                    completion(.success(json))
                } catch {
                    completion(.error(ErrorService.invalidJSON))
                    logError(ErrorService.invalidJSON as NSError)
                }
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                logError(response.error)
                completion(.error(error))
            }
        }
    }
    
    func listTriggering(geoLocation: [String: Any], completion: @escaping (Result<JSON, Error>) -> Void) {

        let request = Request.orchextraRequest(
            method: "POST",
            baseUrl: Config.triggeringEndpoint,
            endpoint: endpointList,
            bodyParams: geoLocation)
        
        self.authInteractor.sendRequest(request: request, completion: completion)
    }
}
