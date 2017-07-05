//
//  EddystoneRegionManager.swift
//  Orchextra
//
//  Created by Carlos Vicente on 26/5/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import Foundation

class EddystoneRegionManager {
    // MARK: Properties
    let availableRegions: [ORCEddystoneRegion]
    let validatorInteractor: ORCValidatorActionInterator
    var regionsEntered: [ORCEddystoneRegion]
    var regionsExited: [ORCEddystoneRegion]
    var beaconsDetected: [ORCEddystoneBeacon]
    
    // MARK: Initializer
    init(availableRegions: [ORCEddystoneRegion], validatorInteractor: ORCValidatorActionInterator) {
        self.availableRegions = availableRegions
        self.validatorInteractor = validatorInteractor
        self.regionsEntered = [ORCEddystoneRegion]()
        self.regionsExited = [ORCEddystoneRegion]()
        self.beaconsDetected = [ORCEddystoneBeacon]()
    }
    
    // MARK: Public methods
    func addDetectedBeacon(beacon: ORCEddystoneBeacon) {
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
    private func regionDidEnter(region: ORCEddystoneRegion)  {
        if self.isAvailable(region) &&
            (!(self.regionsEntered.contains(region))) {
            region.regionEvent = .enter
            self.regionsEntered.append(region)
            
            if region.notifyOnEntry {
                self.addNotification(message: "REGION DID ENTER")
                self.validatorInteractor.validateProximity(with: region, completion: { (action, error) in
                    guard let actionNotNil = action else { return }
                    ORCLog.logVerbose(format: "--- REGION DID ENTER ---", region.uid.namespace)
                    actionNotNil.launchedByTriggerCode = region.uid.namespace
                })
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
                self.addNotification(message: "REGION DID EXIT")
                self.validatorInteractor.validateProximity(with: region, completion: { (action, error) in
                    guard let actionNotNil = action else { return }
                    
                    ORCLog.logVerbose(format: "--- REGION DID EXIT ---", region.uid.namespace)
                    actionNotNil.launchedByTriggerCode = region.uid.namespace
                })
            }
        }
    }
    
    private func updateRegions() {
        let _ =  self.regionsEntered.filter(isNotDetected).map(exit)
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
    
    // TODO: Delete this method
    private func addNotification(message: String) {
        let notification = UILocalNotification()
        notification.fireDate = Date()
        notification.alertBody = "Hey you! \(message)"
        notification.alertAction = message
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    private func exit(from region: ORCEddystoneRegion) {
        self.regionDidExit(region: region)
    }
}
