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
    var storage: StorageProximity
        
    // MARK: -
    
    convenience init() {
        let locationWrapper = LocationWrapper()
        let storage = StorageProximity()
        self.init(locationWrapper: locationWrapper, storage: storage)
    }
    
    init(locationWrapper: LocationInput, storage: StorageProximity) {
        self.storage = storage
        self.locationWrapper = locationWrapper
        self.locationWrapper.output = self
        _ = self.locationWrapper.enableLocationServices()
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
        
        for region in regions {
            if let geofence = region as? Geofence {
                let geofencesOrx = geofence.convertGeofenceOrx()
                self.storage.saveGeofence(geofence: geofencesOrx)
            }
        }
    }
    
    func startMonitoring() {
        
        DispatchQueue.background(delay: 0, background: {
            self.stopMonitoringAllRegions()
        }) {
            LogInfo("Finish Stop monitoring")

            guard let regions = self.regions else {
                LogWarn("No regions to monitoring")
                return }
            
            if self.locationWrapper.enableLocationServices() {
                self.locationWrapper.monitoring(regions: regions)
            }
            LogInfo("Finish start monitoring")
        }
    }
    
    func stopMonitoringAllRegions() {
        self.locationWrapper.stopAllMonitoredRegions()
    }
}

extension ProximityWrapper: LocationOutput {
    
    func didEnterRegion(code: String, type: RegionType) {
        if let geofence = self.storage.findElement(code: code),
            geofence.staytime > 0 {
            self.handleStayTime(geofence: geofence)
        }
        
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
    
    private func handleStayTime(geofence: GeofenceOrx) {
        if #available(iOS 10.0, *) {
            let timer = Timer.scheduledTimer(withTimeInterval: Double(geofence.staytime), repeats: false, block: { _ in
                let outputDic = self.handleOutputRegion(type: RegionType.geofence, code: geofence.code, event: "stay")
                self.output?.sendTriggerToCoreWithValues(values: outputDic)
            })
            
        } else {
            // Fallback on earlier versions
            
        }
    }
    
    // MARK: - Method to generate output
    
    func handleOutputRegion(type: RegionType, code: String, event: String) -> [String: Any] {
        guard let geofence = self.storage.findElement(code: code) else {
            return ["type": type.rawValue,
                    "value": code,
                    "event": event]
        }
        
        let outputDic: [String : Any] =
            ["type": type.rawValue,
             "value": code,
             "event": event,
             "name": geofence.name ?? "",
             "staytime": geofence.staytime]
        
        return outputDic
    }
}
