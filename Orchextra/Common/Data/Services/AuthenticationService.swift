//
//  AuthenticationService.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol AuthenticationServiceInput {
    func newToken(with apikey: String, apisecret: String,
                  completion: @escaping (Result<String, Error>) -> Void)
    func bind(params: [String: Any],
              completion: @escaping(Result<JSON, Error>) -> Void)
}

class AuthenticationService: AuthenticationServiceInput {
    
    // MARK: - PUBLIC

    /// New token from Orx to enable request
    /// that need authentication
    /// - Parameters:
    ///   - apikey: apikey from orchextra settings
    ///   - apisecret: apisecret from orchextra settings
    ///   - completion: return .success(accesstoken) .error(error)
    func newToken(with apikey: String, apisecret: String,
                  completion: @escaping (Result<String, Error>) -> Void) {
        
        let params: [String: Any] = ["apiKey": apikey,
                                     "apiSecret": apisecret]
        
        let request = Request(
            method: "POST",
            baseUrl: Config.coreEndpoint,
            endpoint: "/token",
            bodyParams: params,
            verbose: Orchextra.shared.logLevel == .debug)
        
        request.fetch { response in
            switch response.status {
            case .success:
                do {
                    let json = try response.json()
                    guard let accesstoken = json["token"]?.toString() else {
                        let error = ErrorService.invalidJSON
                        completion(.error(error))
                        logWarn("AccessToken is nil")
                        return }
                    completion(.success(accesstoken))
                    
                } catch {
                    let error = ErrorService.unknown
                    logError(error as NSError)
                    completion(.error(error))
                }
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                logError(response.error)
                completion(.error(error))
            }
        }
    }
    
    
    /// Method to bind the user
    ///
    /// - Parameters:
    ///   - params:
    ///   - completion:
    func bind(params: [String: Any], completion:@escaping (Result<JSON, Error>) -> Void) {
        
        let request = Request.orchextraRequest(
            method: "PUT",
            baseUrl: Config.coreEndpoint,
            endpoint: "/token/data",
            bodyParams: params)
        
        request.fetch { response in
            switch response.status {
            case .success:
                do {
                    let json = try response.json()
                    completion(.success(json))
                } catch {
                    completion(.error(ErrorService.invalidJSON))
                }
            default:
                var error = ErrorServiceHandler.parseErrorService(with: response)
                if (error as? ErrorService) == ErrorService.unknown { error = ErrorService.ErrorBinding}
                logError(response.error)
                completion(.error(error))
            }
        }
    }
}
