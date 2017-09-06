//
//  ProximityWrapper.swift
//  Orchextra
//
//  Created by Judith Medina on 04/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

class ProximityWrapper {
    
    var outputModule: ModuleOutput?
    
    // Attributes module
    
    var regions: [Region]?
    lazy var locationWrapper = LocationWrapper()
    
    
    func register(regions: [Region]) {
        self.regions = regions
    }
    
    func startMonitoring() {
       
        guard let regions = self.regions else {
            LogWarn("No regions to monitoring")
            return }
        
        if !self.locationWrapper.needRequestAuthorization() {
            self.locationWrapper.monitoring(regions: regions)
        }
    }
}

extension ProximityWrapper: LocationOutput {
    
    func didChangeAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            self.startMonitoring()
            
        default:
            break
        }
    }
}
