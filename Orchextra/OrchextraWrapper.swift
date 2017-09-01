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
    
    // Attributtes

    static let shared = OrchextraWrapper()
    
    private var session: Session
    private var configInteractor: ConfigInteractorInput
    internal var triggerManager: TriggerManager

    fileprivate var startCompletion: ((Result<Bool, Error>) -> Void)?
    
    internal let wireframe = Wireframe(
        application: Application()
    )

    // Modules
    
    var scanner: ModuleInput?
    
    // MARK: - Methods Wrapper
    
    convenience init() {
        let session = Session.shared
        let configInteractor = ConfigInteractor()
        let triggerManager = TriggerManager()

        self.init(session: session,
                  configInteractor: configInteractor,
                  triggerManager: triggerManager)
    }
    
    init(session: Session,
         configInteractor: ConfigInteractorInput,
         triggerManager: TriggerManager) {
        self.session = session
        self.configInteractor = configInteractor
        self.triggerManager = triggerManager
    }
    
    func start(with apiKey: String, apiSecret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        LogInfo(" ---  ORCHEXTRA --- ")
        LogInfo(" ---  LOADED PROJECT WITH: ---")
        LogInfo(" ---  Apikey: \(apiKey)")
        LogInfo(" ---  Apisecret: \(apiSecret)")

        self.session.apiKey = apiKey
        self.session.apiSecret = apiSecret
        self.startCompletion = completion
        
        completion(.success(true))
        // Start configuration
//        self.configInteractor.loadCoreConfig(completion: completion)
    }
    
    func openScanner() {
        let action = ActionScanner()
        action.executable()
    }
    
    func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        self.scanner = vc
        self.scanner?.outputModule = self.triggerManager
    }
}
