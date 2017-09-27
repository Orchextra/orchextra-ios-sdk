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
    
    
    /// Method to get Accesstoken to auth against Orchextra
    ///
    /// - Parameters:
    ///   - apikey: apikey from orchextra settings
    ///   - apisecret: apisecret from orchextra settings
    ///   - completion: return .success(accesstoken) .error(error)
    
    func auth(with apikey: String, apisecret: String, crmId: String?,
              completion: @escaping (Result<String, Error>) -> Void) {
        
        self.clientToken(with: apikey, apisecret: apisecret) { result in
            switch result {
            case .success(let clientToken):
                self.accessToken(with: clientToken,
                                 crmId: crmId,
                                 completion: completion)
                break
            case .error(let error):
                completion(.error(error))
                break
            }
        }
    }

 
    // MARK: - PRIVATE
    
    /// Auth Service to get the client token
    ///
    /// - Parameters:
    ///   - apikey: apikey from orchextra settings
    ///   - apisecret: apisecret from orchextra settings
    ///   - completion: return clientToken or error service
    
    private func clientToken(with apikey: String, apisecret: String,
                             completion: @escaping (Result<String, Error>) -> Void) {
        
        let params: [String: Any] = ["grantType": "auth_sdk",
                      "credentials": [
                        "apiKey": apikey,
                        "apiSecret": apisecret] ]
        
        let request = Request.orchextraRequest(
            method: "POST",
            baseUrl: Config.coreEndpoint,
            endpoint: "/security/token",
            bodyParams: params)
        
        request.fetch { response in
            switch response.status {
            case .success:
                do {
                    let json = try response.json()
                    guard let clientToken = json["value"]?.toString() else {
                        let error = ErrorService.invalidJSON
                        completion(.error(error))
                        LogWarn("ClientToken is nil")
                        return
                    }
                    completion(.success(clientToken))
                    
                } catch {
                    let error = ErrorService.unknown
                    completion(.error(error))
                    LogError(error as NSError)
                }
            default:
                let error = ErrorServiceHandler.parseErrorService(with: response)
                completion(.error(error))
                LogError(response.error)
            }
        }
    }
    
    
    /// Method to get the access token provide by Orchextra
    ///
    /// - Parameters:
    ///   - clientToken: client token that we got from clientToken()
    ///   - crmId: crmId provided by the integration side
    ///   - completion: return accesstoken
    
    private func accessToken(with clientToken: String, crmId: String?,
                             completion: @escaping (Result<String, Error>) -> Void) {

        let device = Device()
        var params: [String: Any] = ["grantType": "auth_user",
                                     "credentials": [
                                        "clientToken": clientToken,
                                        "advertiserId": device.advertiserId,
                                        "vendorId": device.vendorId]]
        
        var credentials = params["credentials"] as? [String: Any]
        if let crm = crmId {
            credentials?["crmId"] = crm
            params["credentials"] = credentials
        }
        
        let request = Request.orchextraRequest(
            method: "POST",
            baseUrl: Config.coreEndpoint,
            endpoint: "/security/token",
            bodyParams: params)
        
        request.fetch { response in
            switch response.status {
            case .success:
                do {
                    let json = try response.json()
                    guard let accesstoken = json["value"]?.toString() else {
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
}
