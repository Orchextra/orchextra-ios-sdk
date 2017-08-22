//
//  OrchextraWrapper.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import GIGLibrary

class OrchextraWrapper {
    
    static let shared = OrchextraWrapper()
    
    private var session: Session
    private var configInteractor: ConfigInteractorInput
    private let triggerInteractor = TriggerInteractor()
    fileprivate var startCompletion: ((Result<Bool, Error>) -> Void)?
    
    convenience init() {
        let session = Session.shared
        let configInteractor = ConfigInteractor()
        self.init(session: session,
                  configInteractor: configInteractor)

    }
    
    init(session: Session, configInteractor: ConfigInteractorInput) {
        self.session = session
        self.configInteractor = configInteractor
    }
    
    func start(with apiKey: String, apiSecret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        LogInfo(" ---  ORCHEXTRA --- ")
        LogInfo(" ---  LOADED PROJECT WITH: ---")
        LogInfo(" ---  Apikey: \(apiKey)")
        LogInfo(" ---  Apisecret: \(apiSecret)")

        self.session.apiKey = apiKey
        self.session.apiSecret = apiSecret
        self.startCompletion = completion
                
        // Start configuration
        self.configInteractor.loadCoreConfig(completion: completion)
        
        self.triggerInteractor.trigger()
    }
}
