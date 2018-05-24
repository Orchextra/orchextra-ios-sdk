//
//  StorageProximity.swift
//  Orchextra
//
//  Created by Judith Medina on 13/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol StorageProximityInput {
    func saveRegion(region: RegionModelOrx)
    func removeRegion(region: RegionModelOrx)
    func findElement(code: String) -> RegionModelOrx?
    
    func saveRequestWaitTime(rwt: Int)
    func loadRequestWaitTime() -> Int?
}

struct StorageProximity: StorageProximityInput {
    
    private let keyRegions = "keyRegions"
    private let keyRequestWaitTime = "keyRequestWaitTime"

    let userDefaults: UserDefaults
    
    init() {
        let userDefaults = UserDefaults.standard
        self.init(userDefaults: userDefaults)
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Regions
    
    func saveRegion(region: RegionModelOrx) {
        var regionsOrx = [RegionModelOrx]()
        if let regions = self.decode() {
            regionsOrx = regions
        }
    
        if !regionsOrx.contains(where: { $0.code == region.code }) {
            regionsOrx.append(region)
            self.encode(regions: regionsOrx)
        }
    }
    
    func removeRegion(region: RegionModelOrx) {
        var regionsOrx = [RegionModelOrx]()
        if let regions = self.decode() {
            regionsOrx = regions
        }
        if let indexGeofence = self.findIndex(
            region: region, regionsOrx: regionsOrx) {
            regionsOrx.remove(at: indexGeofence)
        }
    }
    
    func findElement(code: String) -> RegionModelOrx? {
        if let geofences = self.decode() {
            if let i = geofences.index(where: { $0.code == code }) {
                return geofences[i]
            }
        }
        return nil
    }
    
    // Methods to store and retrieve request wait time
    
    func saveRequestWaitTime(rwt: Int) {
        self.userDefaults.set(rwt, forKey: keyRequestWaitTime)
    }
    
    func loadRequestWaitTime() -> Int? {
        return self.userDefaults.value(forKey: keyRequestWaitTime) as? Int
    }
    
    // MARK: - Encode & Decode
    
    private func encode(regions: [RegionModelOrx]) {
        self.userDefaults.set(try? PropertyListEncoder().encode(regions), forKey: keyRegions)
    }
    
    private func decode() -> [RegionModelOrx]? {
        if let data = self.userDefaults.value(forKey: keyRegions) as? Data {
            let regions = try? PropertyListDecoder().decode([RegionModelOrx].self, from: data)
            return regions
        }
        return nil
    }
    
    private func findIndex(region: RegionModelOrx, regionsOrx: [RegionModelOrx]) -> Int? {
        if let i = regionsOrx.index(where: { $0.code == region.code }) {
            return i
        }
        return nil
    }
}
