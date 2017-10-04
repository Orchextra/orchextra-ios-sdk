//
//  StorageProximityMock.swift
//  OrchextraTests
//
//  Created by Judith Medina on 02/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
@testable import Orchextra

class StorageProximityMock: StorageProximityInput {

    var spySaveGeofence: (called: Bool, geofence: GeofenceOrx)!
    var spyRemoveGeofence: (called: Bool, geofence: GeofenceOrx)!
    var spyFindElement = (called: false, code: "")
    var geofenceInput: GeofenceOrx?

    func saveGeofence(geofence: GeofenceOrx) {
        self.spySaveGeofence = (called: true, geofence: geofence)
    }
    
    func removeGeofence(geofence: GeofenceOrx) {
        self.spyRemoveGeofence = (called: true, geofence: geofence)
    }
    
    func findElement(code: String) -> GeofenceOrx? {
        self.spyFindElement.called = true
        self.spyFindElement.code = code
        
        return geofenceInput
    }
}
