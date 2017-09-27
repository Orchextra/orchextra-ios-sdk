//
//  AuthInteractor.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol AuthInteractorInput {
    func authWithAccessToken(completion: @escaping (Result<String, Error>) -> Void)
    func sendRequest(request: Request, completion: @escaping (Result<JSON, Error>) -> Void)
}

class AuthInteractor: AuthInteractorInput {
    
    let service: AuthenticationServiceInput
    let session: Session
    
    // MARK: - INIT

    init(service: AuthenticationServiceInput,
         session: Session) {
        self.service = service
        self.session = session
    }
    
    convenience init() {
        let service = AuthenticationService()
        let session = Session.shared
        self.init(service: service, session: session)
    }
    
    // MARK: - PUBLIC
    
    func authWithAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let apikey = self.session.apiKey,
            let apisecret = self.session.apiSecret else {
                LogWarn("Can't get accesstoken - Apikey/Apisecret are nil")
                return
        }
        
        let accesstokenLoaded = self.session.loadAccesstoken()
        
        if let accesstoken = accesstokenLoaded {
            completion(.success(accesstoken))
            
        } else {
            self.service.newToken(with: apikey, apisecret: apisecret, completion: { result in
                switch result {
                case .success(let accesstoken):
                    self.session.save(accessToken: accesstoken)
                    self.bind(user: nil)
                    completion(.success(accesstoken))
                    
                case .error(let error):
                    switch error {
                    case ErrorService.unauthorized:
                        self.session.save(accessToken: nil)
                        completion(.error(ErrorService.unauthorized))
                    case ErrorService.invalidCredentials:
                        _ = self.session.credentials(apiKey: "", apiSecret: "")
                        completion(.error(error))
                    default:
                        break
                    }
                }
            })
        }
    }
    
    func bind(user: User?) {
        let device = Device()
        let params = device.deviceParams()
        self.service.bind(params: params) { result in
            
        }
    }
    
    /// Method to authenticate the request
    ///
    /// - Parameters:
    ///   - request: request that needs to be authenticated
    ///   - completion: return the completion for the request
    func sendRequest(request: Request, completion: @escaping (Result<JSON, Error>) -> Void) {
        
        if request.headers?["Authorization"] == nil {
            self.handleRefreshAccessToken(request: request, completion: completion)
        } else {
            request.fetch { response in
                
                switch response.status {
                case .success:
                    do {
                        let json = try response.json()
                        LogDebug(json.description)
                        completion(.success(json))
                        
                    } catch {
                        let error = ErrorService.unknown
                        LogWarn("There is not data with the response for request: \(request.endpoint)")
                        completion(.error(error))
                    }
                    
                default:
                    let error = ErrorServiceHandler.parseErrorService(with: response)
                    switch error {
                    case ErrorService.unauthorized:
                        self.handleRefreshAccessToken(request: request, completion: completion)
                        break
                    default:
                        completion(.error(error))
                        break
                    }
                }
            }
        }
    }
    
    // MARK: - PRIVATE
    
    private func refreshAccessToken(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.session.save(accessToken: nil)
        self.authWithAccessToken { result in
            switch result {
            case .success:
                // TODO: Bind device and user
                completion(.success(true))
                break
                
            case .error(let error):
                completion(.error(error))
                break
            }
        }        
    }

    private func bind(device: Device) {
        
    }
    
    // MARK: - Authentication Request
    
    private func handleRefreshAccessToken(request: Request,
                                          completion: @escaping (Result<JSON, Error>) -> Void) {
        let authInteractor = AuthInteractor()
        authInteractor.refreshAccessToken(completion: { result in
            switch result {
            case .success:
                request.headers = Request.headers(endpoint: request.endpoint)
                self.sendRequest(request: request, completion: completion)
                break
            case .error (let error):
                completion(.error(error))
                break
            }
        })
    }

}
