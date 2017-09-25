//
//  StorageProximity.swift
//  Orchextra
//
//  Created by Judith Medina on 13/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

struct StorageProximity {
    
    private let keyGeomarketing = "keyGeomarketing"
    private let keyProximity = "keyProximity"
    private let keyRegions = "keyRegions"

    let userDefault: UserDefaults
    
    init(userDefault: UserDefaults = UserDefaults()) {
        self.userDefault = userDefault
    }
    
    // MARK: - Geofences
    
    func saveRegions(regions: [Region]?) {
        self.userDefault.archiveObject(regions, forKey: keyRegions)
    }
    
    func loadRegions() -> [Region]? {
        let regions = self.userDefault.unarchiveObject(forKey: keyRegions) as? [Region]
        return regions
    }
    
    func saveListGeofences(geofences: [Geofence]) {
        self.userDefault.archiveObject(geofences, forKey: keyGeomarketing)
    }
    
    func loadListGeofences() -> [Geofence]? {
        return self.userDefault.unarchiveObject(forKey: keyGeomarketing) as? [Geofence]
    }
    
    // MARK: - Beacons

    func saveListBeacons(beacons: [Beacon]) {
        self.userDefault.archiveObject(beacons, forKey: keyProximity)
    }
    
    func loadListBeacons() -> [Beacon]? {
        return self.userDefault.unarchiveObject(forKey: keyProximity) as? [Beacon]
    }
}
