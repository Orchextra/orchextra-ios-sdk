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
import UserNotifications

typealias CompletionCurrentLocation = ((_ location: CLLocation, _ placemark: CLPlacemark?) -> Void)

// LocationInput

protocol LocationInput {
    
    var output: LocationOutput? {get set}

    func enableLocationServices() -> Bool
    func monitoring(regions: [Region])
    func stopAllMonitoredRegions()
    func showLocationPermissionAlert()
    func currentUserLocation(completion: @escaping CompletionCurrentLocation)
}

// LocationOutput

protocol LocationOutput {
    func didChangeAuthorization(status: CLAuthorizationStatus)
    func didEnterRegion(code: String, type: RegionType)
    func didExitRegion(code: String, type: RegionType)
    func didChangeProximity(beacon: Beacon)
}

class LocationWrapper: NSObject, LocationInput {
    
    var locationManager: CLLocationManager
    var output: LocationOutput?
    
    fileprivate var completionCurrentLocation: CompletionCurrentLocation?
    fileprivate var authorizationStatus: CLAuthorizationStatus
    fileprivate var isLocationUpdated: Bool
    fileprivate var geocoder: CLGeocoder
    fileprivate lazy var beaconsRanging = [Beacon]()
    
    override convenience init() {
        let locationManager = CLLocationManager()
        self.init(locationManager: locationManager)
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.authorizationStatus = CLLocationManager.authorizationStatus()
        self.isLocationUpdated = false
        self.geocoder = CLGeocoder()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10
        self.locationManager.activityType = CLActivityType.other
    }
    
    func enableLocationServices() -> Bool {
        let status = self.authorizationStatus
        switch status {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse, .denied, .restricted:
            self.showLocationPermissionAlert()
            return false
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
            return false
        }
    }
    
    func monitoring(regions: [Region]) {
        for region in regions {
            self.startMonitoring(region: region)
            LogInfo("start: \(region.name)")
        }
    }
    
    func currentUserLocation(completion: @escaping CompletionCurrentLocation) {
        self.completionCurrentLocation = completion
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            completion(CLLocation(latitude: 0, longitude: 0), nil)
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
                    self.isRangingAvailable(beacon: clRegion)
                }
            }
        }
    }
    
    private func isRangingAvailable(beacon: CLRegion) {
        if CLLocationManager.isRangingAvailable(), let beaconRegion = beacon as? CLBeaconRegion {
            self.locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func stopAllMonitoredRegions() {
        let monitoredRegions = self.locationManager.monitoredRegions
        for monitoredRegion in monitoredRegions {
            self.locationManager.stopMonitoring(for: monitoredRegion)
            LogDebug("stop: \(monitoredRegion.identifier)")
        }
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        for beacon in beacons {
            let beaconRanged = self.beaconAlreadyRanged(beacon: beacon)
            
            if let beaconAlreadyRanged = beaconRanged {
                let changeProximity = beaconAlreadyRanged.newProximity(proximity: beacon.proximity)
                if changeProximity {
                    self.notifyStateBeaconChanged(beacon: beaconAlreadyRanged)
                }
                
            } else {
                let newBeacon = Beacon(
                    code: region.identifier,
                    notifyOnEntry: region.notifyOnEntry,
                    notifyOnExit: region.notifyOnExit,
                    uuid: beacon.proximityUUID,
                    major: Int(truncating: beacon.major),
                    minor: Int(truncating: beacon.minor),
                    name: region.identifier)
                
                _ = newBeacon.newProximity(proximity: beacon.proximity)
                self.beaconsRanging.append(newBeacon)
                self.notifyStateBeaconChanged(beacon: newBeacon)
            }
            
        }
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
        self.completionCurrentLocation?(CLLocation(latitude: 0, longitude: 0), nil)
        LogError(error as NSError)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if self.authorizationStatus != status {
            self.authorizationStatus = status
            self.output?.didChangeAuthorization(status: status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !self.isLocationUpdated {
            self.isLocationUpdated = !self.isLocationUpdated
            self.locationManager.stopUpdatingLocation()
            
            guard let location = locations.last else {
                LogDebug("User can't update location")
                return
            }
            
            self.geocoder.reverseGeocodeLocation(location, completionHandler: { placemark, _ in
                if let completion = self.completionCurrentLocation {
                    completion(location, placemark?.first)
                }
            })
        }
    }
    
    // MARK: - Private

    private func beaconAlreadyRanged(beacon: CLBeacon) -> Beacon? {
        
        for orxbeacon in self.beaconsRanging {
            if orxbeacon.isEqualtoCLBeacon(clBeacon: beacon) {
                return orxbeacon
            }
        }
        return nil
    }
    
    private func notifyStateBeaconChanged(beacon: Beacon) {
        self.output?.didChangeProximity(beacon: beacon)
        LogDebug("beacon: \(beacon.name)) -> proximity: \(String(describing: beacon.currentProximity?.name())) ")
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
