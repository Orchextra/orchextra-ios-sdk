//
//  EddystoneRegionManager.swift
//  Orchextra
//
//  Created by Carlos Vicente on 26/5/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

class ORCEddystoneRegionManager {
    // MARK: Properties
    @objc let actionInterface: ORCActionInterface
    let availableRegions: [ORCEddystoneRegion]
    @objc let validatorInteractor: ORCValidatorActionInterator
    var regionsEntered: [ORCEddystoneRegion]
    var regionsExited: [ORCEddystoneRegion]
    var beaconsDetected: [ORCEddystoneBeacon]
    
    // MARK: Initializer
    init(
        availableRegions: [ORCEddystoneRegion],
        validatorInteractor: ORCValidatorActionInterator,
        actionInterface: ORCActionInterface
        ) {
        self.availableRegions = availableRegions
        self.validatorInteractor = validatorInteractor
        self.actionInterface = actionInterface
        self.regionsEntered = [ORCEddystoneRegion]()
        self.regionsExited = [ORCEddystoneRegion]()
        self.beaconsDetected = [ORCEddystoneBeacon]()
    }
    
    func updateBeaconsDetected(with beaconsDetected: [ORCEddystoneBeacon]) {
        self.availableRegions.forEach { (region) in
            let availableBeaconsDetected = beaconsDetected.filter { (beaconDetected) in
                return beaconDetected.uid?.namespace == region.uid.namespace
            }
            
            availableBeaconsDetected.forEach { (beacon) in
                if !self.beaconsDetected.contains { $0.uid?.uidCompossed == beacon.uid?.uidCompossed } {
                    self.beaconsDetected.append(beacon)
                }
                self.regionDidEnter(region: region)
            }
        }
        
    }
    
    func cleanDetectedBeaconList() {
        self.updateRegions()
        self.beaconsDetected.removeAll()
    }
    
    // MARK: Regions management
    private func regionDidEnter(region: ORCEddystoneRegion)  {
        if self.isAvailable(region) &&
            (!(self.regionsEntered.contains(region))) {
            region.regionEvent = .enter
            self.regionsEntered.append(region)
            if region.notifyOnEntry {
                self.validateAction(
                    for: region,
                    event: "--- REGION DID ENTER ---"
                )
            }
            
            if self.regionsExited.contains(region) {
                guard let index = self.regionsExited.index(of: region) else { return }
                self.regionsExited.remove(at: index)
            }
        }
    }
    
    private func regionDidExit(region: ORCEddystoneRegion) {
        if self.isAvailable(region) &&
            self.regionsEntered.contains(region) &&
            !(self.regionsExited.contains(region)) {
            
            self.regionsExited.append(region)
            region.regionEvent = .exit
            if self.regionsEntered.contains(region) {
                guard let index = self.regionsEntered.index(of: region) else { return }
                self.regionsEntered.remove(at: index)
            }
            
            if region.notifyOnExit {
                self.validateAction(
                    for: region,
                    event: "--- REGION DID EXIT ---"
                )
            }
        }
    }
    
    private func validateAction(for region: ORCEddystoneRegion, event: String) {
        DispatchQueue.main.async {
            self.validatorInteractor.validateProximity(with: region, completion: { (action, error) in
                guard let actionNotNil = action else { return }
                
                ORCLog.logVerbose(format: event, region.uid.namespace)
                actionNotNil.launchedByTriggerCode = region.code
                self.actionInterface.didFireTrigger(with: actionNotNil)
            })
        }
    }
    
    private func updateRegions() {
        _ =  self.regionsEntered.filter(isNotDetected)
            .map(exit)
    }
    
    // MARK: Private methods
    private func isAvailable(_ region: ORCEddystoneRegion) -> Bool {
        return self.availableRegions.contains(region)
    }
    
    private func isNotDetected(region: ORCEddystoneRegion) -> Bool {
        var isNotDetected = true
        for beacon in self.beaconsDetected {
            if beacon.uid?.namespace == region.uid.namespace {
                isNotDetected = false
                break
            }
        }
        return isNotDetected
    }
    
    private func exit(from region: ORCEddystoneRegion) {
        self.regionDidExit(region: region)
    }
}
