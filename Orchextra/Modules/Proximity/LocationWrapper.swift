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
    func monitoring(regions: [Region])
}

protocol LocationOutput {
    func didChangeAuthorization(status: CLAuthorizationStatus)
}

class LocationWrapper: NSObject, LocationInput {
    
    var locationManager: CLLocationManager
    var output: LocationOutput?
    
    override convenience init() {
        let locationManager = CLLocationManager()
        self.init(locationManager: locationManager)
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10
        self.locationManager.activityType = CLActivityType.other
    }
    
    func needRequestAuthorization() -> Bool {
        let status = CLLocationManager.authorizationStatus()
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
    
    // MARK: - Private 
    
    private func showLocationPermissionAlert() {
        let alert = Alert(
            title: kLocaleOrcLocationServiceOffAlertTitle,
            message: kLocaleOrcBackgroundLocationAlertMessage)
        
        alert.addCancelButton(kLocaleOrcGlobalCancelButton, usingAction: nil)
        alert.addDefaultButton(kLocaleOrcGlobalSettingsButton) { _ in
            self.settingTapped()
        }
        alert.show()
    }

    private func settingTapped() {
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
            else {return}
        UIApplication.shared.openURL(settingsURL)
    }
}

extension LocationWrapper: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        LogDebug("didStartMonitoringFor: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        LogDebug("didEnterRegion: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LogError(error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.output?.didChangeAuthorization(status: status)
        LogDebug("didChangeAuthorization: \(status.rawValue)")
    }
}
