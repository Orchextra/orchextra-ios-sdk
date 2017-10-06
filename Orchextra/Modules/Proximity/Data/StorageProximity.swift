//
//  StorageProximity.swift
//  Orchextra
//
//  Created by Judith Medina on 13/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol StorageProximityInput {
    func saveGeofence(geofence: RegionModelOrx)
    func removeGeofence(geofence: RegionModelOrx)
    func findElement(code: String) -> RegionModelOrx?
}

struct StorageProximity: StorageProximityInput {
    
    private let keyGeofences = "keyGeofences"

    let userDefaults: UserDefaults
    
    init() {
        let userDefaults = UserDefaults.standard
        self.init(userDefaults: userDefaults)
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Geofences
    
    func saveGeofence(geofence: RegionModelOrx) {
        var geofencesOrx = [RegionModelOrx]()
        if let geofences = self.decode() {
            geofencesOrx = geofences
        }
    
        if !geofencesOrx.contains(where: { $0.code == geofence.code }) {
            geofencesOrx.append(geofence)
            self.encode(geofences: geofencesOrx)
        }
    }
    
    func removeGeofence(geofence: RegionModelOrx) {
        var geofencesOrx = [RegionModelOrx]()
        if let geofences = self.decode() {
            geofencesOrx = geofences
        }
        if let indexGeofence = self.findIndex(
            geofence: geofence, geofencesOrx: geofencesOrx) {
            geofencesOrx.remove(at: indexGeofence)
        }
    }
    
    func encode(geofences: [RegionModelOrx]) {
        self.userDefaults.set(try? PropertyListEncoder().encode(geofences), forKey:keyGeofences)
    }
    
    func decode() -> [RegionModelOrx]? {
        if let data = self.userDefaults.value(forKey:keyGeofences) as? Data {
            let geofences = try? PropertyListDecoder().decode([RegionModelOrx].self, from: data)
            return geofences
        }
        return nil
    }
    
    func findElement(code: String) -> RegionModelOrx? {
        if let geofences = self.decode() {
            if let i = geofences.index(where: { $0.code == code }) {
                return geofences[i]
            }
        }
        return nil
    }
    
    func findIndex(geofence: RegionModelOrx, geofencesOrx: [RegionModelOrx]) -> Int? {
        if let i = geofencesOrx.index(where: { $0.code == geofence.code }) {
            return i
        }
        return nil
    }
}
