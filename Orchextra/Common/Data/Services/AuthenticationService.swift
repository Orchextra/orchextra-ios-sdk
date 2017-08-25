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
    func auth(with apikey: String, apisecret: String, crmId: String?,
              completion: @escaping (Result<String, Error>) -> Void)
    func bind(values: [String: Any])
}

class AuthenticationService: AuthenticationServiceInput {
    
    // MARK: - PUBLIC
    
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
    
    
    func bind(values: [String: Any]) {
        
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
        
        let request = Request.OrchextraRequest(
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
                        let error = ErrorService.errorParsingJson(element: "clienToken")
                        completion(.error(error))
                        LogWarn("ClientToken is nil")
                        return }
                    completion(.success(clientToken))
                    
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
        
        let request = Request.OrchextraRequest(
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
                        let error = ErrorService.errorParsingJson(element: "accesstoken")
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