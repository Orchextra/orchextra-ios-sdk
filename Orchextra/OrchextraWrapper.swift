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
    
    // Private Attributes
    private var session: Session
    private var configInteractor: ConfigInteractorInput
    private var authInteractor: AuthInteractorInput
    internal var moduleOutputWrapper: ModuleOutputWrapper
    fileprivate var startCompletion: ((Result<Bool, Error>) -> Void)?
    
    
    internal let wireframe = Wireframe(
        application: Application()
    )

    // Modules
    
    var scanner: ModuleInput?
    var proximity: ModuleInput?
    var eddystone: ModuleInput?
    
    // MARK: - Methods Wrapper
    
    convenience init() {
        let session = Session.shared
        let configInteractor = ConfigInteractor()
        let authInteractor = AuthInteractor()
        let moduleOutputWrapper = ModuleOutputWrapper()
        
        self.init(session: session,
                  configInteractor: configInteractor,
                  authInteractor: authInteractor,
                  moduleOutputWrapper: moduleOutputWrapper)
    }
    
    init(session: Session,
         configInteractor: ConfigInteractorInput,
         authInteractor: AuthInteractorInput,
         moduleOutputWrapper: ModuleOutputWrapper) {
        self.session = session
        self.configInteractor = configInteractor
        self.authInteractor = authInteractor
        self.moduleOutputWrapper = moduleOutputWrapper
    }
    
    func start(with apiKey: String, apiSecret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        LogInfo(" ---  ORCHEXTRA --- ")
        LogInfo(" ---  LOADED PROJECT WITH: ---")
        LogInfo(" ---  Apikey: \(apiKey)")
        LogInfo(" ---  Apisecret: \(apiSecret)")
        self.startCompletion = completion
        
        if apiKey.isEmpty || apiSecret.isEmpty {
            completion(.error(ErrorService.invalidCredentials))
            return
        }
        
        if self.session.credentials(
            apiKey: apiKey,
            apiSecret: apiSecret) {
            self.authInteractor.authWithAccessToken(completion: { result in
                switch result {
                case .success:
                    self.coreConfiguration(completion: completion)
                case .error(let error):
                    completion(.error(error))
                }
            })
        } else {
            self.configInteractor.loadCoreConfig(completion: completion)
        }
        
        self.openProximity()
//        self.openEddystone()
    }
    
    // MARK: - Modules
    
    // MARK: - Scan
    
    func openScanner() {
        let action = ActionScanner()
        action.executable()
    }
    
    func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        self.scanner = vc
        self.scanner?.outputModule = self.moduleOutputWrapper
    }
    
    // MARK: - Proximity
    
    func openProximity() {
        if self.proximity == nil {
            self.proximity = ProximityModule()
        }
        self.proximity?.outputModule = self.moduleOutputWrapper
        self.proximity?.start()
    }
    
    func setProximity(proximityModule: ModuleInput) {
        self.proximity = proximityModule
        self.proximity?.outputModule = self.moduleOutputWrapper
    }
    
    // MARK: - Eddystone
    public func openEddystone() {
        if self.eddystone == nil {
            self.eddystone = EddystoneModule()
        }
        self.eddystone?.outputModule = self.moduleOutputWrapper
        self.eddystone?.start()
    }
    
    public func setEddystone(eddystoneModule: ModuleInput) {
        self.eddystone = eddystoneModule
        self.eddystone?.outputModule = self.moduleOutputWrapper
    }
    
    public func openEddystone(with completionHandler: (UIBackgroundFetchResult) -> Void) {
        self.openEddystone()
        completionHandler(.newData)
    }
    
    // MARK: - Device & User
    
    public func remote(apnsToken: Data) {
        let token = apnsToken.reduce("", {$0 + String(format: "%02X", $1)})
        LogDebug("APNS Token:" + token)
    }
}

extension OrchextraWrapper {
    
    func coreConfiguration(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.configInteractor.loadCoreConfig(completion: completion)
    }
}
