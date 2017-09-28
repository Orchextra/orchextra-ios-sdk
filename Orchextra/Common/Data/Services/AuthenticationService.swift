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
              completion: @escaping (Result<Bool, Error>) -> Void)
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
                        LogWarn("AccessToken is nil")
                        return }
                    completion(.success(accesstoken))
                    
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
    
    func bind(params: [String: Any], completion: @escaping (Result<Bool, Error>) -> Void) {
        
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
                    LogDebug("\(json)")
                    completion(.success(true))
                } catch {
                    completion(.error(ErrorService.invalidJSON))
                }
            default:
                var error = ErrorServiceHandler.parseErrorService(with: response)
                if (error as? ErrorService) == ErrorService.unknown { error = ErrorService.ErrorBinding}
                LogError(response.error)
                completion(.error(error))
            }
        }
    }
}
