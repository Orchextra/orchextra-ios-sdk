//
//  ConfigurationInteractor.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol ConfigInteractorInput {
    func loadCoreConfig(completion: @escaping (Result<Bool, Error>) -> Void)
    func loadTriggeringList(geolocation: [String: Any], completion: @escaping (([String: Any]) -> Void))
}

class ConfigInteractor: ConfigInteractorInput {
    
    private let session: Session
    private let configService: ConfigServiceInput
    
    // MARK: - INIT 
    
    init(session: Session, service: ConfigServiceInput) {
        self.session = session
        self.configService = service
    }
    
    convenience init() {
        let session = Session.shared
        let configService = ConfigService()
        self.init(session: session, service: configService)
    }
    
    // MARK: - PUBLIC

    func loadCoreConfig(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.configService.configCore { result in
            switch result {
            case .success:
                completion(.success(true))
                LogDebug("Orx has updated core configuration")
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func loadTriggeringList(geolocation: [String: Any], completion: @escaping (([String: Any]) -> Void)) {
        self.configService.configTriggering(geoLocation: geolocation) { result in
            switch result {
            case .success(let json):
                guard let proximityResult = json.toDictionary() else {
                    completion([ : ])
                    return
                }
                completion(proximityResult)
            case .error:
                LogWarn("Triggering list can't be load it.")
                completion([ : ])
            }
        }
    }
 }
