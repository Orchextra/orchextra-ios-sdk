//
//  LocationWrapper.swift
//  Orchextra
//
//  Created by Judith Medina on 05/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import CoreLocation
import GIGLibrary

protocol LocationInput {
    
    var output: LocationOutput? {get set}

    func needRequestAuthorization() -> Bool
    func monitoring(regions: [Region])
    func stopAllMonitoredRegions()
    func showLocationPermissionAlert()
}

protocol LocationOutput {
    func didChangeAuthorization(status: CLAuthorizationStatus)
    func didEnterRegion(code: String, type: RegionType)
    func didExitRegion(code: String, type: RegionType)
}

class LocationWrapper: NSObject, LocationInput {
    
    var locationManager: CLLocationManager
    var output: LocationOutput?
    
    fileprivate var authorizationStatus: CLAuthorizationStatus
    
    override convenience init() {
        let locationManager = CLLocationManager()
        self.init(locationManager: locationManager)
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.authorizationStatus = CLLocationManager.authorizationStatus()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10
        self.locationManager.activityType = CLActivityType.other
    }
    
    func needRequestAuthorization() -> Bool {
        let status = self.authorizationStatus
        switch status {
        case .authorizedAlways:
            return false
        case .authorizedWhenInUse, .denied:
            self.showLocationPermissionAlert()
            return true
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
            return false
        case .restricted:
            return false
        }
    }
    
    func monitoring(regions: [Region]) {
        for region in regions {
            self.startMonitoring(region: region)
            LogDebug("start: \(region.code)")
        }
        
    }
    
    // MARK: - Private monitoring methods
    
    private func startMonitoring(region: Region) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            if let clRegion = region.prepareCLRegion() {
                
                let monitored = self.locationManager.monitoredRegions.contains(clRegion)
                let monitoringAvailable = CLLocationManager.isMonitoringAvailable(for: type(of: clRegion))
                
                if  monitoringAvailable && !monitored {
                    self.locationManager.startMonitoring(for: clRegion)
                }
            }
        }
    }
    
    func stopAllMonitoredRegions() {
        
        let monitoredRegions = self.locationManager.monitoredRegions
        for monitoredRegion in monitoredRegions {
            self.locationManager.stopMonitoring(for: monitoredRegion)
            LogDebug("stop: \(monitoredRegion.identifier)")
        }
    }
    
    // MARK: - Private 
    
    func showLocationPermissionAlert() {
        let alert = Alert(
            title: kLocaleOrcLocationServiceOffAlertTitle,
            message: kLocaleOrcBackgroundLocationAlertMessage)
        
        alert.addCancelButton(kLocaleOrcGlobalCancelButton, usingAction: nil)
        alert.addDefaultButton(kLocaleOrcGlobalSettingsButton) { _ in
            self.settingTapped()
        }
        alert.show()
    }

    func settingTapped() {
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
            else {return}
        UIApplication.shared.openURL(settingsURL)
    }
}

extension LocationWrapper: CLLocationManagerDelegate {
    
    /// Start monitoring
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        LogDebug("for : \(region.identifier)")
    }
    
    /// Enter Region
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
       
        self.output?.didEnterRegion(
            code: region.identifier,
            type: self.typeRegion(region: region))
        
        LogDebug("for: \(region.identifier)")
    }
    
    /// Exit Region
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        self.output?.didExitRegion(
            code: region.identifier,
            type: self.typeRegion(region: region))
        
        LogDebug("for : \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        LogError(error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LogError(error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if self.authorizationStatus != status {
            self.authorizationStatus = status
            self.output?.didChangeAuthorization(status: status)
        }
    }
    
    // MARK: - Helpers
    
    func typeRegion(region: CLRegion) -> RegionType {
        var type: RegionType = .none
        if region is CLCircularRegion {
            type = .geofence
        } else if region is CLBeaconRegion {
            type = .beacon_region
        }
        return type
    }
}
