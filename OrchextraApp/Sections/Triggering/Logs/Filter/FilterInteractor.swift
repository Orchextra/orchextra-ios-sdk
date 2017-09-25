//
//  FilterPresenter.swift
//  Orchextra
//
//  Created by Carlos Vicente on 3/9/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

protocol FilterInteractorInput {
    func retrieveFilters() -> [Filter]
    func update(filter: Filter, at position: Int)
    func clearSelectedFilters()
}

protocol FilterInteractorOutput {
    func filterUpdated(at position: Int)
}

class FilterInteractor {
    // MARK: - Attributes
    var filters: [Filter] = [Filter]()
    
    // MARK: - Interactor output
    var output: FilterInteractorOutput?
    
    // MARK: - Initializer
    init() {
       self.filters = self.initializeFilters()
    }
    
    func initializeFilters() -> [Filter] {
        let barcode = Filter(
            id: "barcode",
            name: "Barcode",
            index: 0,
            selected: false
        )
        let qr = Filter(
            id: "qr",
            name: "Qr",
            index: 1,
            selected: false
        )
        let imageRecognition = Filter(
            id: "vuforia",
            name: "Image recognition",
            index: 2,
            selected: false
        )
        let geofence = Filter(
            id: "geofence",
            name: "Geofence",
            index: 3,
            selected: false
        )
        let iBeaconRegion = Filter(
            id: "beacon_region",
            name: "iBeacon region",
            index: 4,
            selected: false
        )
        let eddystoneRegion = Filter(
            id: "eddystone_region",
            name: "Eddystone region",
            index: 5,
            selected: false
        )
        let iBeacon = Filter(
            id: "beacon",
            name: "iBeacon",
            index: 6,
            selected: false
        )
        let eddystone = Filter(
            id: "eddystone",
            name: "Eddystone",
            index: 7,
            selected: false)
        
        let filters = [barcode, qr, imageRecognition, geofence, iBeaconRegion, eddystoneRegion, iBeacon, eddystone].sorted { $0.index < $1.index }
        
        return filters
    }
}

extension FilterInteractor: FilterInteractorInput {
    func retrieveFilters() -> [Filter] {
        return self.filters.sorted { $0.index < $1.index }
    }
    
    func update(filter: Filter, at position: Int) {
        let filtersUpdated: [Filter] = self.filters.map { (currentFilter) in
            if currentFilter.id == filter.id {
                currentFilter.selected = !filter.selected
            }
            
            return currentFilter
        }
        
        self.filters = filtersUpdated
        self.output?.filterUpdated(at: position)
    }
    
    func clearSelectedFilters() {
        self.filters = self.initializeFilters()
    }
}
