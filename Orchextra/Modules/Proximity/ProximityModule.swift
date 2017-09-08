//
//  ProximityModule.swift
//  Orchextra
//
//  Created by Judith Medina on 05/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class ProximityModule: ModuleInput {
    
    var outputModule: ModuleOutput?
    
    // Attributes
    
    var proximityWrapper: ProximityInput
    
    // MARK: - Init
    
    convenience init() {
        let proximity = ProximityWrapper()
        self.init(proximityWrapper: proximity)
    }
    
    init(proximityWrapper: ProximityInput) {
        self.proximityWrapper = proximityWrapper
        self.proximityWrapper.output = self
    }
    
    // MARK: - ModuleInput methods
    
    // Start monitoring the regions
    func start() {
        self.proximityWrapper.paramsCurrentUserLocation { params in
            self.outputModule?.setConfig(config: params, completion: { config in
                self.parseGeoMarketing(params: config)
            })
        }
    }
    
    /// Finish monitoring services
    ///
    /// - Parameters:
    ///   - action: which has started the finish flow.
    ///   - completionHandler: let know the integrative app that the services is finished.
    func finish(action: Action?, completionHandler: (() -> Void)?) {
        self.proximityWrapper.stopMonitoringAllRegions()
        if let completion = completionHandler {
            completion()
        }
    }
    
    func parseGeoMarketing(params: [String : Any]) {
        guard let geofences = params["geoMarketing"] as? Array<[String: Any]> else {
            LogWarn("There aren't geofence to configure in proximity module")
            return
        }
        
        var geofencesInModule = [Region]()
        for geofence in geofences {
            if let region = RegionFactory.geofences(from: geofence){
                geofencesInModule.append(region)
            }
        }
        self.proximityWrapper.register(regions: geofencesInModule)
        self.proximityWrapper.startMonitoring()

    }
}

extension ProximityModule: ProximityOutput {
    func sendTriggerToCoreWithValues(values: [String: Any]) {
        self.outputModule?.triggerWasFire(with: values, module: self)
    }
}
