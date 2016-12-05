//
//  ORCCBCentralWrapper.swift
//  EddystoneExample
//
//  Created by Carlos Vicente on 28/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation
import CoreBluetooth


@objc public class ORCCBCentralWrapper: NSObject, CBCentralManagerDelegate {
    
    public var centralManager: CBCentralManager?
    var centralManagerQueue: DispatchQueue
    var requestWaitTime: Int
    @objc var validatorInteractor: ORCValidatorActionInterator
    @objc var actionInterface: ORCActionInterface
    var eddystoneParser: ORCEddystoneProtocolParser?
    var scannerStarted: Bool
    var beaconList: [ORCEddystoneBeacon]
    
    // MARK: PUBLIC
    
    @objc public init(actionInterface:ORCActionInterface,
                      validatorActionInteractor: ORCValidatorActionInterator,
                      requestWaitTime: Int) {
        
        let centralManagerQueue = DispatchQueue(label:"centralManagerQueue")
        self.centralManagerQueue = centralManagerQueue
        self.requestWaitTime = requestWaitTime
        self.scannerStarted = false
        self.validatorInteractor = validatorActionInteractor
        self.actionInterface = actionInterface
        self.beaconList = [ORCEddystoneBeacon]()
        
        self.validatorInteractor = validatorActionInteractor
        
        super.init()
        
        self.initializeCentralManager()
        
    }
    
    @objc public func initializeCentralManager() {
    
        let centralManager = CBCentralManager(delegate: self,
                                              queue:self.centralManagerQueue,
                                              options: [CBCentralManagerOptionRestoreIdentifierKey : "ORCCentralManagerIdentifier"])
        
        self.centralManager = centralManager
    }

    
    public func startScanner() -> Void {
        
        if !self.scannerStarted,
            self.centralManager?.state == .poweredOn {
            
            self.centralManagerQueue.async {
                
                self.scannerStarted = true
                let serviceUUID:String = EddystoneConstants.serviceUUID
                let services: [CBUUID] = [CBUUID (string:serviceUUID)]
                let options: [String : Any] = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
                
                self.eddystoneParser = ORCEddystoneProtocolParser(requestWaitTime: self.requestWaitTime)
                self.centralManager?.scanForPeripherals(withServices: services, options: options)
            }
        }
    }
    
    public func stopScanner() -> Void {
        
        self.centralManagerQueue.async() {
            
            self.scannerStarted = false
            self.centralManager?.stopScan()
        }
    }
    
    
    // MARK: CBCentralManagerDelegate
    
    public func centralManagerDidUpdateState(_ centralManager: CBCentralManager) -> Void {
        
        if self.scannerStarted,
            centralManager.state != .poweredOn {
            self.stopScanner()
        } else if !self.scannerStarted,
            centralManager.state == .poweredOn {
            self.startScanner()
        }
    }
    
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("centralManager willRestoreState: \(dict)")
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let serviceData:[AnyHashable: Any] = advertisementData[CBAdvertisementDataServiceDataKey] as? [AnyHashable : Any] {
            
            let serviceUUID:String = EddystoneConstants.serviceUUID
            let serviceCBUUID = CBUUID(string: serviceUUID)
            if let beaconServiceData:Data = (serviceData[serviceCBUUID] as? Data) {
                let peripheralId:UUID = peripheral.identifier as UUID
                let rssi:Int = RSSI.intValue
                if let eddystoneParser = self.eddystoneParser {
                    eddystoneParser.parse(beaconServiceData,
                                          peripheralId: peripheralId,
                                          rssi: rssi)
                    self.beaconList = eddystoneParser.parseServiceInformation()
                    DispatchQueue.main.async(execute: {
                        for eddystoneBeacon:ORCEddystoneBeacon in self.beaconList {
                            if eddystoneBeacon.canBeSentToValidateAction() {
                                self.validatorInteractor.validateProximity(with: eddystoneBeacon, completion: {(action, error) in
                                if let actionNotNil = action {
                                    actionNotNil.launchedByTriggerCode = eddystoneBeacon.uid?.uidCompossed
                                    self.actionInterface.didFireTrigger(with: action)
                                }
                            })
                                
                            }
                        }
                    })
                }
            }
        }
    }
}
