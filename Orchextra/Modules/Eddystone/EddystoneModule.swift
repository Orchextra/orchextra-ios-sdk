//
//  EddystoneModule.swift
//  Orchextra
//
//  Created by Carlos Vicente on 11/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class EddystoneModule: ModuleInput {
    
    var outputModule: ModuleOutput?
    
    // Attributes
    var eddystoneWrapper: EddystoneInput
    
    // MARK: - Init
    convenience init() {
        let eddystoneWrapper = CBCentralWrapper()
        self.init(eddystoneWrapper: eddystoneWrapper)
    }
    
    init(eddystoneWrapper: CBCentralWrapper) {
        self.eddystoneWrapper = eddystoneWrapper
        self.eddystoneWrapper.output = self
    }
    
    // MARK: - ModuleInput methods
    
    // Start monitoring the regions
    func start() {
        self.eddystoneWrapper.startEddystoneScanner()
    }
    
    /// Finish monitoring services
    ///
    /// - Parameters:
    ///   - action: which has started the finish flow.
    ///   - completionHandler: let know the integrative app that the services is finished.
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        self.eddystoneWrapper.stopEddystoneScanner()
        if let completion = completionHandler {
            completion()
        }
    }
    
    /// Set regions for the eddystone module
    ///
    /// - Parameter config:
    func setConfig(config: [String : Any]) {
        guard let regions = config["eddystoneRegions"] as? Array<[String: Any]> else {
            LogWarn("There aren't regions available to configure in eddystone module")
            return
        }
        
        var eddystoneRegionsInModule = [EddystoneRegion]()
        let requesWaitTime = config["requestWaitTime"] as? Int ?? EddystoneConstants.defaultRequestWaitTime
        for eddystoneRegion in regions {
            if let region = EddystoneRegion(with: eddystoneRegion) {
                eddystoneRegionsInModule.append(region)
            }
        }
        
        self.eddystoneWrapper.register(regions: eddystoneRegionsInModule, with: requesWaitTime)
    }
}

extension EddystoneModule: EddystoneOutput {
    func sendTriggerToCoreWithValues(values: [String: Any]) {
        self.outputModule?.triggerWasFire(with: values, module: self)
    }
}
