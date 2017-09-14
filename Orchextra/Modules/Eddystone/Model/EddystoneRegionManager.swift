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
    let output: EddystoneOutput?
    let availableRegions: [EddystoneRegion]
    var regionsEntered: [EddystoneRegion]
    var regionsExited: [EddystoneRegion]
    var beaconsDetected: [EddystoneBeacon]
    
    // MARK: Initializer
    init(availableRegions: [EddystoneRegion], output: EddystoneOutput?) {
        self.output = output
        self.availableRegions = availableRegions
        self.regionsEntered = [EddystoneRegion]()
        self.regionsExited = [EddystoneRegion]()
        self.beaconsDetected = [EddystoneBeacon]()
    }
    
    // MARK: Public methods
    func addDetectedBeacon(beacon: EddystoneBeacon) {
        //TODO: Convert to functional
        for region in availableRegions {
            if region.uid.namespace == beacon.uid?.namespace {
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
        DispatchQueue.global(qos: .background).async {
            let outputRegionValues = self.handleOutputRegion(for: region, event: event)
            self.output?.sendTriggerToCoreWithValues(values: outputRegionValues)
        }
    }
    
    // MARK: - Method to generate region output
    private func handleOutputRegion(for region: EddystoneRegion, event: String) -> [String: Any] {
        LogDebug("\(event) \(region.uid.namespace)")
        let outputDic = ["type" : "eddystone_region",
                         "value" : region.code,
                         "namespace" : region.uid.namespace,
                         "event" : region.regionEvent.rawValue]
        
        return outputDic
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
        // TODO: convert to functional
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
