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
    func bind(user: UserOrx?, device: Device?, completion: @escaping(Result<Bool, Error>) -> Void)
    func sendRequestOrx(request: Request, completionHandler: @escaping (Response) -> Void)
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
    
    
    /// Method to return an accesstoken to authenticate
    /// the app with a specific project from Orchextra.
    ///
    /// - Parameter completion: return accesstoken, the sdk will return
    ///     the accesstoken that we have stored in the system otherwise
    ///     will connect with the server to
    func authWithAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let apikey = self.session.apiKey,
            let apisecret = self.session.apiSecret else {
                completion(.error(ErrorService.invalidCredentials))
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
                    let currentUser = self.currentOrNewEmptyUser()
                    let device = Device()
                    self.bind(user: currentUser,
                              device: device,
                              completion: { result in
                        switch result {
                        case .success:
                            completion(.success(accesstoken))
                        case .error(let error):
                            _ = self.session.credentials(apiKey: "", apiSecret: "")
                            completion(.error(error))
                        }
                    })
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
    
    
    /// Method to bind device and user
    ///
    /// - Parameters:
    ///   - user: user object to bind
    ///   - device: device object to bind
    ///   - completion: response from server after binding user, device or both.
    ///     <bool> true if the binding process has been successfully completed and false if there has occurred an error.
    func bind(user: UserOrx?, device: Device?, completion: @escaping(Result<Bool, Error>) -> Void) {
        let deviceParams = device?.deviceParams()
        let userParams = user?.userParams()
       
        var params = [String: Any]()
        userParams?.forEach { (key, value) in
            params[key] = value
        }
        
        deviceParams?.forEach { (key, value) in
            params[key] = value
        }
        
        self.service.bind(params: params) { result in
            switch result {
            case .success(let json):
                let user = UserOrx(json: json)
                let device = Device()
                device.parse(json: json)
                self.session.bindUser(user)
                self.newBindHasBeenCompleted(json: json)
                completion(.success(true))
            case .error(let error):
                self.errorBindHasBeenCompleted(error: error)
                completion(.error(error))
            }
        }
    }
    
    func newBindHasBeenCompleted(json: JSON) {
        guard let jsonDic = json.toDictionary() else {
            Orchextra.shared.delegate?.bindDidCompleted(result: Result.error(BindingError.invalidJson))
            LogWarn("json from bind is not well formatted")
            return }
        LogInfo("A new bind has been made")
        Orchextra.shared.delegate?.bindDidCompleted(result: Result.success(jsonDic)) 
    }
    
    func errorBindHasBeenCompleted(error: Error) {
        Orchextra.shared.delegate?.bindDidCompleted(result: Result.error(error))
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
                    default:
                        completion(.error(error))
                    }
                }
            }
        }
    }
    
    func sendRequestOrx(request: Request, completionHandler: @escaping (Response) -> Void) {
        var orxRequest = request
        
        // Add headers
        if request.headers?["Authorization"] == nil {
            orxRequest = request.addORXHeader()
        }
        
        orxRequest.fetch { response in
            switch response.status {
            case .success:
                completionHandler(response)
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                switch error {
                case ErrorService.unauthorized:
                    self.refreshAcessToken(completion: { result in
                        switch result {
                        case .success:
                            self.sendRequestOrx(request: request, completionHandler: completionHandler)
                        case .error:
                            completionHandler(response)
                        }
                    })
                    
                default:
                    completionHandler(response)
                }
            }
        }
    }
    
    // MARK: - PRIVATE
    
    
    /// Method to refresh token
    ///
    /// - Parameter completion:
    private func refreshAccessToken(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.session.save(accessToken: nil)
        self.authWithAccessToken { result in
            switch result {
            case .success:
                let currentUser = self.session.currentUser()
                let device = Device()
                self.bind(user: currentUser, device: device, completion: completion)
            case .error(let error):
                completion(.error(error))
            }
        }        
    }
    
    private func currentOrNewEmptyUser() -> UserOrx? {
        let currentUser = self.session.currentUser()
        if currentUser == nil {
            return nil
        }
        return self.session.currentUser()
    }
    
    // MARK: - Authentication Request
    
    private func handleRefreshAccessToken(request: Request,
                                          completion: @escaping (Result<JSON, Error>) -> Void) {
        self.refreshAccessToken(completion: { result in
            switch result {
            case .success:
                request.headers = Request.headers(endpoint: request.endpoint)
                self.sendRequest(request: request, completion: completion)
            case .error (let error):
                completion(.error(error))
            }
        })
    }
    
    private func refreshAcessToken(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.refreshAccessToken { result in
            switch result {
            case .success:
                completion(.success(true))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
