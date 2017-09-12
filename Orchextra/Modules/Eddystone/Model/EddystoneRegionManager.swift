//
//  EddystoneRegionManager.swift
//  Orchextra
//
//  Created by Carlos Vicente on 26/5/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation
import GIGLibrary

class EddystoneRegionManager {
    // MARK: Properties
//    let actionInterface: ORCActionInterface
    let availableRegions: [EddystoneRegion]
//    let validatorInteractor: ORCValidatorActionInterator
    var regionsEntered: [EddystoneRegion]
    var regionsExited: [EddystoneRegion]
    var beaconsDetected: [EddystoneBeacon]
    
    // MARK: Initializer
    init(
        availableRegions: [EddystoneRegion]//,
//        validatorInteractor: ORCValidatorActionInterator,
//        actionInterface: ORCActionInterface
        ) {
        self.availableRegions = availableRegions
//        self.validatorInteractor = validatorInteractor
//        self.actionInterface = actionInterface
        self.regionsEntered = [EddystoneRegion]()
        self.regionsExited = [EddystoneRegion]()
        self.beaconsDetected = [EddystoneBeacon]()
    }
    
    // MARK: Public methods
    func addDetectedBeacon(beacon: EddystoneBeacon) {
        //TODO: Convert to functional
        for region in availableRegions {
            if region.uid.namespace == beacon.uid?.namespace {
                if !self.beaconsDetected.contains(beacon) {
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
    private func regionDidEnter(region: EddystoneRegion)  {
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
    
    private func regionDidExit(region: EddystoneRegion) {
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
    
    private func validateAction(for region: EddystoneRegion, event: String) {
        DispatchQueue.main.async {
//            self.validatorInteractor.validateProximity(with: region, completion: { (action, error) in
//                guard let actionNotNil = action else { return }
//                LogInfo("\(event) \(region.uid.namespace)")
//                actionNotNil.launchedByTriggerCode = region.code
//                self.actionInterface.didFireTrigger(with: actionNotNil)
//            })
        }
    }
    
    private func updateRegions() {
        _ =  self.regionsEntered.filter(isNotDetected)
            .map(exit)
    }
    
    // MARK: Private methods
    private func isAvailable(_ region: EddystoneRegion) -> Bool {
        return self.availableRegions.contains(region)
    }
    
    private func isNotDetected(region: EddystoneRegion) -> Bool {
        var isNotDetected = true
        for beacon in self.beaconsDetected {
            if beacon.uid?.namespace == region.uid.namespace {
                isNotDetected = false
                break
            }
        }
        return isNotDetected
    }
    
    private func exit(from region: EddystoneRegion) {
        self.regionDidExit(region: region)
    }
}
