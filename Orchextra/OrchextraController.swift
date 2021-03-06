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
    
    // Singleton
    static let shared = OrchextraController()
    
    // Public attributtes

    var translations: Translations

    // Private attributes
    
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
        self.translations = Translations()
    }
    
    func start(with apiKey: String, apiSecret: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        logInfo(" ---  ORCHEXTRA --- ")
        logInfo(" ---  LOADED PROJECT WITH: ---")
        logInfo(" ---  Apikey: \(apiKey)")
        logInfo(" ---  Apisecret: \(apiSecret)")
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
        self.configureModules()
    }
    
    public func enableEddystone(enable: Bool) {
        self.enableEddystone = enable
        self.configureModules()
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
    
    func openEddystone() {
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
    
    func remote(apnsToken: Data?) {
        if let apnsToken = apnsToken {
            let token = apnsToken.reduce("", {$0 + String(format: "%02X", $1)})
            self.session.setPushNotification(token: apnsToken)
            logInfo("Save APNS Token:" + token)
        } else {
            self.session.setPushNotification(token: nil)
            self.bindDevice()
        }
    }
    
    func accesstoken() -> String? {
        return self.session.loadAccesstoken()
    }
    
    func setAnonymous(_ anonymous: Bool) {
        self.session.setAnonymous(anonymous)
        if self.session.apiKey != nil && self.session.apiSecret != nil {
            self.bindAnonymousUser(anonymous: anonymous)
        }
    }
    
    // MARK: - Configuration Modules
    
    func configuration(module: Modules, json: JSON) -> [String: Any]? {
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
    
    /// Start / stop the modules if Orchextra is already started
    private func configureModules() {
        if self.session.apiKey != nil && self.session.apiSecret != nil {
            // disable proximity if it is disabled
            if !self.enableProximity {
                self.proximity?.finish(action: nil, completionHandler: nil)
            }
            // disable eddystones if it is disabled
            if !self.enableEddystone {
                self.eddystone?.finish(action: nil, completionHandler: nil)
            }
            // trigger configuration if any module is enable
            if self.enableEddystone || self.enableProximity {
                self.triggerConfiguration()
            }
        }
    }
    
    // MARK: Public CRM methods
    
    func bindUser(_ user: UserOrx) {
        let currentUser = self.session.currentUser()
        if user != currentUser {
            self.performBindUserOperation(user: user)
        }
    }
    
    func unbindUser() {
        self.session.unbindUser()
        self.performBindUserOperation(user: nil)
    }
    
    func bindAnonymousUser(anonymous: Bool) {
        if let currentUser = self.session.currentUser() {
            currentUser.customFields = [CustomField.analyticsConsent(withValue: !anonymous)]
            self.performBindAnonymousUserOperation(user: currentUser)
        } else {
            self.performBindDeviceOperation()
        }
    }
    
    func currentUser() -> UserOrx? {
        return self.session.currentUser()
    }
    
    func setUserBusinessUnits(_ businessUnits: [BusinessUnit]) {
        guard let currentUser = self.session.currentUser() else { return }
        currentUser.businessUnits = businessUnits
        self.bindUser(currentUser)
    }
    
    func getUserBusinessUnits() -> [BusinessUnit] {
        guard let currentUser = self.currentUser() else { return [BusinessUnit]() }
        return currentUser.businessUnits
    }
    
    func setUserTags(_ tags: [Tag]) {
        guard let currentUser = self.session.currentUser() else { return }
        currentUser.tags = tags
        self.bindUser(currentUser)
    }
    
    func getUserTags() -> [Tag] {
        guard let currentUser = self.currentUser() else { return [Tag]() }
        return currentUser.tags
    }
    
    func setCustomFields(_ customFields: [CustomField]) {
        guard let currentUser = self.session.currentUser() else { return }
        currentUser.customFields = customFields
        self.bindUser(currentUser)
    }
    
    func getCustomFields() -> [CustomField] {
        guard let currentUser = self.currentUser() else { return [CustomField]() }
        return currentUser.customFields
    }
    
    func getAvailableCustomFields() -> [CustomField] {
        guard let availableCustomFields = self.session.project?.customFields else {
            return [CustomField]()
            
        }
        return availableCustomFields
    }
    
    // MARK: Public Device methods
    
    func bindDevice() {
        self.performBindDeviceOperation()
    }
    
    func setDeviceBusinessUnits(_ businessUnits: [BusinessUnit]) {
        self.session.setDeviceBusinessUnits(businessUnits: businessUnits)
    }
    
    func getDeviceBusinessUnits() -> [BusinessUnit] {
        return self.session.deviceBusinessUnits()
    }
    
    func setDeviceTags(_ tags: [Tag]) {
        self.session.setDeviceTags(tags: tags)
    }
    
    func getDeviceTags() -> [Tag] {
        return self.session.deviceTags()
    }
    
    // MARK: Private CRM methods
    
    private func performBindUserOperation(user: UserOrx?) {
        self.authInteractor.bind(user: user, device: nil) { (result) in
            switch result {
            case .success(let json):
                Orchextra.shared.delegate?.userBindDidComplete(result: .success(json.toDictionary() ?? [:]))
                logInfo("Bind user has been successful")
            case .error(let error):
                Orchextra.shared.delegate?.userBindDidComplete(result: .error(error))
                logInfo("Bind user with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func performBindAnonymousUserOperation(user: UserOrx?) {
        let device = Device()
        self.authInteractor.bind(user: user, device: device) { result in
            switch result {
            case .success(let json):
                Orchextra.shared.delegate?.deviceBindDidComplete(result: .success(json.toDictionary() ?? [:]))
                logInfo("Bind device has been successful")
            case .error(let error):
                Orchextra.shared.delegate?.deviceBindDidComplete(result: .error(error))
                logInfo("Bind device with error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Private Device methods
    
    private func performBindDeviceOperation() {
        let device = Device()
        let user = self.session.currentUser()
        self.authInteractor.bind(user: user, device: device) { result in
            switch result {
            case .success(let json):
                Orchextra.shared.delegate?.deviceBindDidComplete(result: .success(json.toDictionary() ?? [:]))
                logInfo("Bind device has been successful")
            case .error(let error):
                Orchextra.shared.delegate?.deviceBindDidComplete(result: .error(error))
                logInfo("Bind device with error: \(error.localizedDescription)")
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
