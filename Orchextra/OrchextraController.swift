//
//  OrchextraController.swift
//  Orchextra
//
//  Created by Judith Medina on 14/08/2017.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import GIGLibrary

class OrchextraController {
    
    // Attributtes

    static let shared = OrchextraController()
    
    // Private Attributes
    private var session: Session
    private var configInteractor: ConfigInteractorInput
    private var authInteractor: AuthInteractorInput
    internal var moduleOutputWrapper: ModuleOutput
    fileprivate var startCompletion: ((Result<Bool, Error>) -> Void)?
    fileprivate let applicationCenter: ApplicationCenter
    
    internal let wireframe = Wireframe(
        application: Application()
    )

    // Modules
    
    var scanner: ModuleInput?
    var proximity: ModuleInput?
    var eddystone: ModuleInput?
    var enableProximity: Bool = false
    var enableEddystone: Bool = false

    
    // MARK: - Methods Wrapper
    
    convenience init() {
        let session = Session.shared
        let configInteractor = ConfigInteractor()
        let authInteractor = AuthInteractor()
        let moduleOutputWrapper = ModuleOutputWrapper()
        let applicationCenter = ApplicationCenter()
        
        self.init(session: session,
                  configInteractor: configInteractor,
                  authInteractor: authInteractor,
                  moduleOutputWrapper: moduleOutputWrapper,
                  applicationCenter: applicationCenter)
    }
    
    init(session: Session,
         configInteractor: ConfigInteractorInput,
         authInteractor: AuthInteractorInput,
         moduleOutputWrapper: ModuleOutput,
         applicationCenter: ApplicationCenter) {
        self.session = session
        self.configInteractor = configInteractor
        self.authInteractor = authInteractor
        self.moduleOutputWrapper = moduleOutputWrapper
        self.applicationCenter = applicationCenter
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
                    self.triggerConfiguration()
                case .error(let error):
                    completion(.error(error))
                }
            })
        } else {
            self.coreConfiguration(completion: completion)
            self.triggerConfiguration()
        }
        
        self.applicationCenter.observeAppDelegateEvents()
    }
    
    func sendOrxRequest(request: Request, completionHandler: @escaping (Response) -> Void) {
        self.authInteractor.sendRequestOrx(request: request, completionHandler: completionHandler)
    }
    
    // MARK: - MODULES
    
    // MARK: - Scan
    
    func openScanner() {
        let action = ActionScanner()
        action.executable()
    }
    
    func scan(completion: @escaping(Result<ScannerResult, ScannerError>) -> Void) {
        // !!!
        let defaultScannerModule =  DefaultScannerModule(completion: completion)
        defaultScannerModule.start()
    }
    
    func setScanner<T: UIViewController>(vc: T) where T: ModuleInput {
        self.scanner = vc
        self.scanner?.outputModule = self.moduleOutputWrapper
    }
    
    // MARK: - Proximity
    
    public func enableProximity(enable: Bool) {
      self.enableProximity = enable
    }
    
    public func enableEddystone(enable: Bool) {
        self.enableEddystone = enable
        
    }
    
    func openProximity(config: [String: Any]) {
        if self.proximity == nil {
            self.proximity = ProximityModule()
        }
        self.proximity?.outputModule = self.moduleOutputWrapper
        self.proximity?.start()
        self.proximity?.setConfig(params: config)
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
        self.session.setPushNotification(token: apnsToken)
        LogInfo("Save APNS Token:" + token)
    }
    
    public func accesstoken() -> String? {
        return self.session.loadAccesstoken()
    }
    
    // MARK: - Configuration Modules
    
    public func configuration(module: Modules, json: JSON) -> [String: Any]? {
        switch module {
        case .proximity:
            if let requestWaitTime = json["requestWaitTime"]?.toInt() {
                return ["requestWaitTime": requestWaitTime]
            }
        default:
            break
        }
        return nil
    }
    
    func stop() {
        self.applicationCenter.removeAppDelegateEvents()
        self.proximity?.finish(action: nil, completionHandler: nil)
        self.eddystone?.finish(action: nil, completionHandler: nil)
    }
    
    // MARK: Public CRM methods
    public func bindUser(_ user: UserOrx) {
        let currentUser = self.session.currentUser()
        if user != currentUser {
            self.performBindUserOperation(user: user)
        }
    }
    
    public func unbindUser() {
        self.session.unbindUser()
        self.performBindUserOperation(user: nil)
    }
    
    public func currentUser() -> UserOrx? {
        return self.session.currentUser()
    }
    
    public func setUserBusinessUnits(_ businessUnits: [BusinessUnit]) {
        guard let currentUser = self.session.currentUser() else { return }
        currentUser.businessUnits = businessUnits
        self.bindUser(currentUser)
    }
    
    public func getUserBusinessUnits() -> [BusinessUnit] {
        guard let currentUser = self.currentUser() else { return [BusinessUnit]() }
        return currentUser.businessUnits
    }
    
    public func setUserTags(_ tags: [Tag]) {
        guard let currentUser = self.session.currentUser() else { return }
        currentUser.tags = tags
        self.bindUser(currentUser)
    }
    
    public func getUserTags() -> [Tag] {
        guard let currentUser = self.currentUser() else { return [Tag]() }
        return currentUser.tags
    }
    
    public func setCustomFields(_ customFields: [CustomField]) {
        guard let currentUser = self.session.currentUser() else { return }
        currentUser.customFields = customFields
        self.bindUser(currentUser)
    }
    
    public func getCustomFields() -> [CustomField] {
        guard let currentUser = self.currentUser() else { return [CustomField]() }
        return currentUser.customFields
    }
    
    public func getAvailableCustomFields() -> [CustomField] {
        guard let availableCustomFields = self.session.project?.customFields else {
            return [CustomField]()
            
        }
        return availableCustomFields
    }
    
    // MARK: Public Device methods
    public func bindDevice() {
        self.performBindDeviceOperation()
    }
    
    public func setDeviceBusinessUnits(_ businessUnits: [BusinessUnit]) {
        self.session.setDeviceBusinessUnits(businessUnits: businessUnits)
    }
    
    public func getDeviceBusinessUnits() -> [BusinessUnit] {
        return self.session.deviceBusinessUnits()
    }
    
    public func setDeviceTags(_ tags: [Tag]) {
        self.session.setDeviceTags(tags: tags)
    }
    
    public func getDeviceTags() -> [Tag] {
        return self.session.deviceTags()
    }
    
    // MARK: Private CRM methods
    private func performBindUserOperation(user: UserOrx?) {
        self.authInteractor.bind(user: user, device: nil) { (result) in
            switch result {
            case .success:
                LogInfo("Bind user has been successful")
            case .error(let error):
                LogInfo("Bind user with error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Private Device methods
    private func performBindDeviceOperation() {
        let device = Device()
        let user = self.session.currentUser()
        self.authInteractor.bind(user: user, device: device) { (result) in
            switch result {
            case .success:
                LogInfo("Bind device has been successful")
            case .error(let error):
                LogInfo("Bind device with error: \(error.localizedDescription)")
            }
        }
    }
}

extension OrchextraController {
    
    func coreConfiguration(completion: @escaping (Result<Bool, Error>) -> Void) {
        // Core configuration
        self.configInteractor.loadCoreConfig(completion: completion)
    }
    
    func triggerConfiguration() {
        
        if self.enableProximity {
            // Gets list of triggers to configure proximity module
            self.configInteractor.loadTriggeringConfig { jsonConfig in
                if  let json = jsonConfig,
                    let proximityConfig = self.configuration(module: .proximity, json: json) {
                    self.openProximity(config: proximityConfig)
                }
            }
        }
        
        if self.enableEddystone {
            self.openEddystone()
        }
    }
}
