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
    func loadTriggeringConfig(completion: @escaping (JSON?) -> Void)
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
            case .success(let json):
                let project = Project(from: json)
                self.session.project = project
                completion(.success(true))
                logDebug("Orx has updated core configuration with \(project.projectId ?? "-")")
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func loadTriggeringConfig(completion: @escaping (JSON?) -> Void) {
        self.configService.configTriggering { result in
            switch result {
            case .success(let json):
                completion(json)
            case .error:
                completion(nil)
            }
        }
    }
    
    func loadTriggeringList(geolocation: [String: Any], completion: @escaping (([String: Any]) -> Void)) {
        self.configService.listTriggering(geoLocation: geolocation) { result in
            switch result {
            case .success(let json):
                guard let proximityResult = json.toDictionary() else {
                    completion([ : ])
                    return
                }
                completion(proximityResult)
            case .error:
                logWarn("Triggering list can't be load it.")
                completion([ : ])
            }
        }
    }
 }
