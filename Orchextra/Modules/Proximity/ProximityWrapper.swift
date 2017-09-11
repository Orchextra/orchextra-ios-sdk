//
//  ProximityWrapper.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

protocol ProximityInput {

    var output: ProximityOutput? {get set}

    func paramsCurrentUserLocation(completion: @escaping ([String: Any]) -> Void)
    func register(regions: [Region])
    func startMonitoring()
    func stopMonitoringAllRegions()
}

protocol ProximityOutput {
    func sendTriggerToCoreWithValues(values: [String: Any])
}

class ProximityWrapper: ProximityInput {
    
    var output: ProximityOutput?
    
    // Attributes module
    
    var regions: [Region]?
    var locationWrapper: LocationInput
    
    // MARK: - 
    
    convenience init() {
        let locationWrapper = LocationWrapper()
        self.init(locationWrapper: locationWrapper)
    }
    
    init(locationWrapper: LocationInput) {
        self.locationWrapper = locationWrapper
        self.locationWrapper.output = self
        _ = self.locationWrapper.needRequestAuthorization()
    }
    
    // MARK: - Public
    
    func paramsCurrentUserLocation(completion: @escaping ([String : Any]) -> Void) {
        self.locationWrapper.currentUserLocation { location, placemark in
            let geoLocation = GeoLocation(location: location, placemark: placemark)
            let params = geoLocation.paramsGeoLocation()
            completion(params)
            LogDebug("\(params)")
        }
    }
    
    func register(regions: [Region]) {
        self.regions = regions
        self.stopMonitoringAllRegions()
    }
    
    func startMonitoring() {
        
        DispatchQueue.background(delay: 0, background: {
            self.stopMonitoringAllRegions()
        }) {
            LogDebug("Finish Stop monitoring")

            guard let regions = self.regions else {
                LogWarn("No regions to monitoring")
                return }
            
            if !self.locationWrapper.needRequestAuthorization() {
                self.locationWrapper.monitoring(regions: regions)
            }
            LogDebug("Finish start monitoring")
        }
    }
    
    func stopMonitoringAllRegions() {
        self.locationWrapper.stopAllMonitoredRegions()
    }
}

extension ProximityWrapper: LocationOutput {
    
    func didEnterRegion(code: String, type: RegionType) {
        let outputDic = handleOutputRegion(type: type, code: code, event: "enter")
        self.output?.sendTriggerToCoreWithValues(values: outputDic)
    }
    
    func didExitRegion(code: String, type: RegionType) {
        let outputDic = handleOutputRegion(type: type, code: code, event: "exit")
        self.output?.sendTriggerToCoreWithValues(values: outputDic)
    }
    
    func didChangeAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            self.startMonitoring()
        case .denied:
            self.locationWrapper.showLocationPermissionAlert()
        default:
            break
        }
    }
    
    // MARK: - Method to generate output
    
    func handleOutputRegion(type: RegionType, code: String, event: String) -> [String: Any]{
        let outputDic = ["type" : type.rawValue,
                         "value" : code,
                         "event": event]
        
        return outputDic
    }
}
