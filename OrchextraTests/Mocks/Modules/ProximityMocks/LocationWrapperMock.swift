//
//  LocationWrapperMock.swift
//  OrchextraTests
//
//  Created by Judith Medina on 02/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import CoreLocation
@testable import Orchextra

class LocationWrapperMock: LocationInput {
    
    var output: LocationOutput?
    var inputCurrentLocation: (location: CLLocation, placemark: CLPlacemark?) = (location: CLLocation(latitude: 0, longitude: 0), placemark: nil)
    
    var spyMonitoring = (called: true, monitoring: [Region]())
    var spyStopAllMonitoredRegionsCalled = false
    var spyShowLocationPermissionAlertCalled = false

    func enableLocationServices() -> Bool {
        return true
    }
    
    func monitoring(regions: [Region]) {
        self.spyMonitoring.called = true
        self.spyMonitoring.monitoring = regions
    }
    
    func stopAllMonitoredRegions() {
        self.spyStopAllMonitoredRegionsCalled = true
    }
    
    func showLocationPermissionAlert() {
        self.spyShowLocationPermissionAlertCalled = true
    }
    
    func currentUserLocation(completion: @escaping CompletionCurrentLocation) {
        completion(self.inputCurrentLocation.location , self.inputCurrentLocation.placemark)
    }
}
