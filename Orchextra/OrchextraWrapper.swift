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
    var proximity: ModuleInput?
    
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

        self.openProximity()

        completion(.success(true))
    
        // Start configuration
        // self.configInteractor.loadCoreConfig(completion: completion)
    }
    
    func openScanner() {
        let action = ActionScanner()
        action.executable()
    }
    
    func openProximity() {
        if self.proximity == nil {
            self.proximity = ProximityModule()
        }
        self.proximity?.outputModule = self.triggerManager
        
        let proximityConfig = self.getProximity()
        self.proximity?.setConfig(config: proximityConfig)
        self.proximity?.start()
    }
    
    func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        self.scanner = vc
        self.scanner?.outputModule = self.triggerManager
    }
    
    func setProximity(proximityModule: ModuleInput) {
        self.proximity = proximityModule
        self.proximity?.outputModule = self.triggerManager
    }
    
    func getProximity() -> [String: Any] {
        let geomarketingFile = self.jsonFrom(
            filename: "geomarketing")!
        return geomarketingFile as! [String: Any]
    }
}

extension OrchextraWrapper {
    
    func jsonFrom(filename: String) -> [String: Any]? {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json") else {
            LogWarn("\(filename) not found")
            return nil
        }
        
        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
            LogWarn("Unable to convert \(filename) to String")
            return nil
        }
        
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            LogWarn("Unable to convert \(filename) to NSData")
            return nil
        }
        
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            LogWarn("Unable to convert \(filename) to JSON dictionary")
            return nil
        }
        return jsonDictionary
    }
}
