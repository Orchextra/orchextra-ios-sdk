//
//  ORCCBCentralWrapper.swift
//  EddystoneExample
//
//  Created by Carlos Vicente on 28/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation
import CoreBluetooth
import UserNotifications

@objc public class ORCCBCentralWrapper: NSObject {
    
    // MARK: Public properties
    public static var scanLevel: CoreBluetoothScanLevel = .scanByIntervals
    public var centralManager: CBCentralManager?
    
    @objc public var availableRegions: [ORCEddystoneRegion]
    @objc var validatorInteractor: ORCValidatorActionInterator
    @objc var actionInterface: ORCActionInterface
    var centralManagerQueue: DispatchQueue?
    var requestWaitTime: Int
    var eddystoneParser: ORCEddystoneProtocolParser?
    var scannerStarted: Bool
    var beaconList: [ORCEddystoneBeacon]
    
    var startScannerBackgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var stopScannerBackgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    // MARK: Public methods
    @objc public init(actionInterface:ORCActionInterface,
                      validatorActionInteractor: ORCValidatorActionInterator,
                      requestWaitTime: Int) {
        let centralManagerQueue = DispatchQueue(label:"centralManagerQueue", qos: .userInitiated)
        self.centralManagerQueue = centralManagerQueue
        self.requestWaitTime = requestWaitTime
        self.scannerStarted = false
        self.validatorInteractor = validatorActionInteractor
        self.actionInterface = actionInterface
        self.beaconList = [ORCEddystoneBeacon]()
        self.availableRegions = [ORCEddystoneRegion]()
        super.init()
        
        self.initializeCentralManager()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.stopScanner),
            name: NSNotification.Name(rawValue: ORCCoreBluetoothStart),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.startScanner),
            name: NSNotification.Name(rawValue: ORCCoreBluetoothStop),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: ORCCoreBluetoothStart),
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: ORCCoreBluetoothStop),
            object: nil
        )
    }
    
    @objc public func initializeCentralManager() {
        let centralManager = CBCentralManager(delegate: self,
                                              queue: self.centralManagerQueue,
                                              options: [CBCentralManagerOptionRestoreIdentifierKey : "ORCCentralManagerIdentifier"])
        
        self.centralManager = centralManager
    }
    
    // MARK: Public scan methods
    @objc public func startScanner() -> Void {
        var secondsToStopScanner: Int = 0
        if self.isAvailableScanner() {
            self.startScannerBackgroundTask = UIApplication.shared.beginBackgroundTask(withName: EddystoneConstants.backgrond_task_start_scanner, expirationHandler: {
                self.endStartScannerTask()
            })
            
            DispatchQueue.global().async(execute: {
                self.performStartScanner()
                
                while secondsToStopScanner < EddystoneConstants.timeToStopScanner {
                    Thread.sleep(forTimeInterval: 1)
                    secondsToStopScanner+=1
                    
                    ORCLog.logDebug(format: "Seconds to stop scanner: \(secondsToStopScanner) - Remaining time: \(UIApplication.shared.backgroundTimeRemaining)")
                }
                
                self.endStartScannerTask()
            })
        }
    }
    
    @objc public func stopScanner() -> Void {
        var secondsToStartScanner: Int = 0
        let timeToStartScanner = self.timeToStartScanner()
        self.stopScannerBackgroundTask = UIApplication.shared.beginBackgroundTask(withName: EddystoneConstants.backgrond_task_start_scanner, expirationHandler: {
            
            ORCLog.logDebug(format:"---------------------------------------- TASK EXPIRED (SYSTEM) ----------------------------------")
            self.endStopScannerTask()
        })
        
        DispatchQueue.global().async(execute: {
            self.performStopScanner()
            while secondsToStartScanner < timeToStartScanner {
                Thread.sleep(forTimeInterval: 1)
                secondsToStartScanner+=1
                
                ORCLog.logDebug(format: "Seconds to start scanner: \(secondsToStartScanner) - Remaining time: \(UIApplication.shared.backgroundTimeRemaining)")
            }
            
            self.endStopScannerTask()
        })
    }
    
    // MARK: Private utilities
    private func isAvailableScanner() -> Bool {
        var isAvailableScanner = false
        if !self.scannerStarted,
            self.centralManager?.state == .poweredOn ,
            self.availableRegions.count > 0 {
            isAvailableScanner = true
        }
        return isAvailableScanner
    }
    
    private func isAvailableStopTool() -> Bool {
        var isAvailableStopTool: Bool
        
        switch ORCCBCentralWrapper.scanLevel {
        case .always:
            isAvailableStopTool = false
            break
        case .scanByIntervals:
            isAvailableStopTool = true
            break
        }
        return isAvailableStopTool
    }
    
    private func timeToStartScanner() -> Int {
        if UIApplication.shared.applicationState != .background {
            return EddystoneConstants.timeToStartScanner
        } else {
            return EddystoneConstants.timeToStartScannerBackground
        }
    }
    
    private func beaconIsValidToSentAction(beacon: ORCEddystoneBeacon) -> Bool {
        return beacon.canBeSentToValidateAction()
    }
    
    private func validateAction(beacon: ORCEddystoneBeacon) {
        DispatchQueue.main.async {
            self.validatorInteractor.validateProximity(with: beacon, completion: {(action, error) in
                guard let actionNotNil = action else { return }
                
                actionNotNil.launchedByTriggerCode = beacon.uid?.uidCompossed
                self.actionInterface.didFireTrigger(with: action)
            })
        }
    }
    
    fileprivate func sendInfoForBeaconsDetected() {
         _ = self.beaconList.filter(self.beaconIsValidToSentAction)
                            .map(self.validateAction)
    }
    
    // MARK: Private scan methods
    private func performStartScanner() {
        ORCLog.logDebug(format: "--- START SCANNER ---")
        self.scannerStarted = true
        let serviceUUID:String = EddystoneConstants.serviceUUID
        let services: [CBUUID] = [CBUUID (string:serviceUUID)]
        let options: [String : Any] = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
        
        if self.eddystoneParser == nil {
            self.eddystoneParser = ORCEddystoneProtocolParser(
                requestWaitTime: self.requestWaitTime,
                validatorInteractor: self.validatorInteractor,
                availableRegions: self.availableRegions,
                actionInterface: self.actionInterface)
        }
        self.centralManager?.scanForPeripherals(withServices: services, options: options)
    }
    
    private func performStopScanner() {
        ORCLog.logDebug(format: "--- STOP SCANNER ---")
        self.scannerStarted = false
        self.centralManager?.stopScan()
        self.eddystoneParser?.cleanDetectedBeaconList()
    }
    
    //MARK: Private finish task methods
    private func endStartScannerTask() {
        if (self.isAvailableStopTool()) {
            UIApplication.shared.endBackgroundTask(self.startScannerBackgroundTask)
            self.startScannerBackgroundTask = UIBackgroundTaskInvalid
            self.stopScanner()
        }
    }
    
    private func endStopScannerTask() {
        ORCLog.logVerbose(format: "Number of beacons detected \(self.beaconList.count)")
        UIApplication.shared.endBackgroundTask(self.stopScannerBackgroundTask)
        self.stopScannerBackgroundTask = UIBackgroundTaskInvalid
        self.startScanner()
    }
    
}

extension ORCCBCentralWrapper: CBCentralManagerDelegate {
    
    // MARK: CBCentralManagerDelegate methods
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
        ORCLog.logVerbose(format: "centralManager willRestoreState: \(dict)")
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [AnyHashable : Any] else { return }
        
        let serviceUUID:String = EddystoneConstants.serviceUUID
        let serviceCBUUID = CBUUID(string: serviceUUID)
        let peripheralId:UUID = peripheral.identifier as UUID
        let rssi:Int = RSSI.intValue
        
        guard let beaconServiceData:Data = (serviceData[serviceCBUUID] as? Data),
            let eddystoneParser = self.eddystoneParser else { return }
        
        eddystoneParser.parse(beaconServiceData,
                              peripheralId: peripheralId,
                              rssi: rssi)
        self.beaconList = eddystoneParser.parseServiceInformation()
        
        DispatchQueue.global().async(execute: {
            self.sendInfoForBeaconsDetected()
        })
    }
}
