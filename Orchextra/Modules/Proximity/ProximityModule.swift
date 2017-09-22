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

    /**
     Start monitoring the regions
     
     Proximity module requires location permission being enable by
     the user to get the geomarketing triggers
     
     To enable location your app must include
     NSLocationWhenInUseUsageDescription & NSLocationAlwaysAndWhenInUsageDescription keys in your app's Info.plist
     
     If your app supports iOS 10 and earlier, the NSLocationAlwaysUsageDescription key is also required
     */
    func start() {
        self.proximityWrapper.paramsCurrentUserLocation { params in
            self.outputModule?.setConfig(config: params, completion: { config in
                self.parseProximity(params: config)
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
    
    // MARK: - Private
    
    private func parseProximity(params: [String : Any]) { 
        guard
            let geofences = params["geoMarketing"] as? Array<[String: Any]>,
            let beacons = params["proximity"] as? Array<[String: Any]> else {
            LogWarn("There aren't beacons or geofences to configure in proximity module")
            return
        }
        
        var regionsInModule = [Region]()
        let geofencesModule = self.parseGeoMarketing(geofences: geofences)
        let beaconsModule = self.parseBeacons(beacons: beacons)

        regionsInModule.append(contentsOf: geofencesModule)
        regionsInModule.append(contentsOf: beaconsModule)

        self.proximityWrapper.register(regions: regionsInModule)
        self.proximityWrapper.startMonitoring()
    }
   
    private func parseGeoMarketing(geofences: Array<[String: Any]>) ->  [Region] {
        
        var geofencesInModule = [Region]()
        for geofence in geofences {
            if let region = RegionFactory.geofences(from: geofence){
                geofencesInModule.append(region)
            }
        }
        return geofencesInModule
    }
    
    private func parseBeacons(beacons: Array<[String: Any]>) ->  [Region]  {

        var beaconsInModule = [Region]()
        for beacon in beacons {
            if let region = RegionFactory.beacon(from: beacon){
                beaconsInModule.append(region)
            }
        }
        return beaconsInModule
    }
}

extension ProximityModule: ProximityOutput {
    func sendTriggerToCoreWithValues(values: [String: Any]) {
        self.outputModule?.triggerWasFire(with: values, module: self)
    }
}
