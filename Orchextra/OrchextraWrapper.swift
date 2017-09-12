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
        let moduleOutputWrapper = ModuleOutputWrapper()
        
        self.init(session: session,
                  configInteractor: configInteractor,
                  moduleOutputWrapper: moduleOutputWrapper)
    }
    
    init(session: Session,
         configInteractor: ConfigInteractorInput,
         moduleOutputWrapper: ModuleOutputWrapper) {
        self.session = session
        self.configInteractor = configInteractor
        self.moduleOutputWrapper = moduleOutputWrapper
    }
    
    func start(with apiKey: String, apiSecret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        LogInfo(" ---  ORCHEXTRA --- ")
        LogInfo(" ---  LOADED PROJECT WITH: ---")
        LogInfo(" ---  Apikey: \(apiKey)")
        LogInfo(" ---  Apisecret: \(apiSecret)")

        self.session.apiKey = apiKey
        self.session.apiSecret = apiSecret
        self.startCompletion = completion

        //TODO: Handle apikey y apisecret
        self.session.save(accessToken: nil)
        
//        self.openProximity()
        self.openEddystone()
        completion(.success(true))
    
        // Start configuration
        // self.configInteractor.loadCoreConfig(completion: completion)
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

    func openEddystone() {
        if self.eddystone == nil {
            self.eddystone = EddystoneModule()
        }
        self.eddystone?.outputModule = self.moduleOutputWrapper
        self.eddystone?.start()
    }
    
    func setEddystone(eddystoneModule: ModuleInput) {
        self.eddystone = eddystoneModule
        self.eddystone?.outputModule = self.moduleOutputWrapper
    }
    
    
//    func getProximity() -> [String: Any]? {
//        guard let geomarketingFile = self.jsonFrom(
//            filename: "geomarketing")else {
//                return nil
//        }
//        
//        return geomarketingFile
//    }
//    
//    func getEddystone() -> [String: Any]? {
//        guard let eddystoneFile = self.jsonFrom(
//            filename: "eddystone")else {
//                return nil
//        }
//        
//        return eddystoneFile
//    }
    

}
