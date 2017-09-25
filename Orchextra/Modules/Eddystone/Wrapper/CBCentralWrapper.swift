//
//  CBCentralWrapper.swift
//  EddystoneExample
//
//  Created by Carlos Vicente on 28/6/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation
import CoreBluetooth
import UserNotifications

import GIGLibrary

protocol EddystoneInput {
    
    var output: EddystoneOutput? {get set}
    
    func register(regions: [EddystoneRegion], with requestWaitTime: Int)
    func startEddystoneScanner()
    func stopEddystoneScanner()
}

protocol EddystoneOutput {
    func sendTriggerToCoreWithValues(values: [String: Any])
}

/// CoreBluetooth levels are used to define the time to scan out for eddystone beacons.
enum CoreBluetoothScanLevel {
    /// Core bluetooth scanner always active searching for peripherals.
    case always
    /// Core bluetooth scanner searaching for peripherals from time to time.
    case byIntervals
}

class CBCentralWrapper: NSObject, EddystoneInput {
    
    // MARK: Public properties
    static var scanLevel: CoreBluetoothScanLevel = .byIntervals
    var output: EddystoneOutput?
    var eddystoneParser: EddystoneProtocolParser?
    var availableRegions: [EddystoneRegion]
    var beaconList: [EddystoneBeacon]
    var centralManagerQueue: DispatchQueue?
    var centralManager: CBCentralManager?
    var requestWaitTime: Int
    var scannerStarted: Bool
    
    var startScannerBackgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var stopScannerBackgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    // MARK: - EddystoneInput protocol methods
    func register(regions: [EddystoneRegion], with requestWaitTime: Int) {
        self.requestWaitTime = requestWaitTime
        self.availableRegions = regions
        self.startEddystoneScanner()
    }
    
    func startEddystoneScanner() {
        self.startScanner()
    }
    
    func stopEddystoneScanner() {
        self.stopScanner()
    }
    
    // MARK: Public methods
    override init() {
        let centralManagerQueue = DispatchQueue(label:"centralManagerQueue", qos: .userInitiated)
        self.centralManagerQueue = centralManagerQueue
        self.scannerStarted = false
        self.beaconList = [EddystoneBeacon]()
        self.availableRegions = [EddystoneRegion]()
        self.requestWaitTime = EddystoneConstants.defaultRequestWaitTime
        super.init()
        self.initializeCentralManager()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.stopScanner),
            name: NSNotification.Name(rawValue: EddystoneConstants.coreBluetoothStart),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.startScanner),
            name: NSNotification.Name(rawValue: EddystoneConstants.coreBluetoothStop),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: EddystoneConstants.coreBluetoothStart),
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: EddystoneConstants.coreBluetoothStop),
            object: nil
        )
    }
    
    func initializeCentralManager() {
        let centralManager = CBCentralManager(delegate: self,
                                              queue: self.centralManagerQueue,
                                              options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralManagerIdentifier"])
        
        self.centralManager = centralManager
    }
    
    // MARK: Public scan methods
    @objc func startScanner() -> Void {
        var secondsToStopScanner: Int = 0
        if self.isAvailableScanner() {
            if self.startScannerBackgroundTask != UIBackgroundTaskInvalid {
                UIApplication.shared.endBackgroundTask(self.startScannerBackgroundTask)
                self.startScannerBackgroundTask = UIBackgroundTaskInvalid
            }
            
            UIApplication.shared.endBackgroundTask(self.stopScannerBackgroundTask)
            self.stopScannerBackgroundTask = UIBackgroundTaskInvalid
                self.startScannerBackgroundTask = UIApplication.shared.beginBackgroundTask(withName: EddystoneConstants.backgrond_task_start_scanner, expirationHandler: {
                    UIApplication.shared.endBackgroundTask(self.startScannerBackgroundTask)
                    self.startScannerBackgroundTask = UIBackgroundTaskInvalid
                })
                
                DispatchQueue.global(qos: .background).async {
                    self.performStartScanner()
                    while secondsToStopScanner < EddystoneConstants.timeToStopScanner {
                        Thread.sleep(forTimeInterval: 1)
                        secondsToStopScanner+=1
                        LogDebug("Seconds to stop scanner: \(secondsToStopScanner) - Remaining time: \(UIApplication.shared.backgroundTimeRemaining)")
                    }
                    
                    self.endStartScannerTask()
                }
            }
    }
    
    @objc func stopScanner() -> Void {
        UIApplication.shared.endBackgroundTask(self.startScannerBackgroundTask)
        self.startScannerBackgroundTask = UIBackgroundTaskInvalid
        
        if self.stopScannerBackgroundTask != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(self.stopScannerBackgroundTask)
            self.stopScannerBackgroundTask = UIBackgroundTaskInvalid
        }
        var secondsToStartScanner: Int = 0
        let timeToStartScanner = self.timeToStartScanner()
        self.stopScannerBackgroundTask = UIApplication.shared.beginBackgroundTask(withName: EddystoneConstants.backgrond_task_stop_scanner, expirationHandler: {
            LogDebug("---------------------------------------- TASK EXPIRED (SYSTEM) ----------------------------------")
            UIApplication.shared.endBackgroundTask(self.stopScannerBackgroundTask)
            self.stopScannerBackgroundTask = UIBackgroundTaskInvalid
        })
        
        DispatchQueue.global(qos: .background).async {
            self.performStopScanner()
            while secondsToStartScanner < timeToStartScanner {
                Thread.sleep(forTimeInterval: 1)
                secondsToStartScanner+=1
                LogDebug("Seconds to start scanner: \(secondsToStartScanner) - Remaining time: \(UIApplication.shared.backgroundTimeRemaining)")
            }
            
            self.endStopScannerTask()
        }
    }
    
    // MARK: Private utilities
    internal func isAvailableScanner() -> Bool {
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
        
        switch CBCentralWrapper.scanLevel {
        case .always:
            isAvailableStopTool = false
            break
        case .byIntervals:
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
    
    private func beaconIsValidToSentAction(beacon: EddystoneBeacon) -> Bool {
        return beacon.canBeSentToValidateAction()
    }
    
    private func validateAction(beacon: EddystoneBeacon) {
        DispatchQueue.global(qos: .background).async {
            guard let outputBeaconValues = self.handleOutputBeacon(for: beacon) else { return }
            self.output?.sendTriggerToCoreWithValues(values: outputBeaconValues)
        }
    }
    
    // MARK: - Method to generate beacon output
    private func handleOutputBeacon(for beacon: EddystoneBeacon) -> [String: Any]? {
        guard let uid = beacon.uid,
            let instance = uid.instance,
            let url = beacon.url else  { return nil }
        
        LogDebug("\(String(describing: beacon.uid?.uidCompossed)) \(beacon.proximity.rawValue)")
        var outputDic: [String: Any] = ["type" : "eddystone",
                                        "value" : uid.uidCompossed,
                                        "namespace" : uid.namespace,
                                        "instance" : instance,
                                        "distance" : beacon.proximity.rawValue,
                                        "url" : url.description]
        
        if let batteryPercentage = beacon.telemetry?.batteryPercentage {
            outputDic["battery"] = batteryPercentage.description
        }
        
        if let temperature = beacon.telemetry?.temperature {
            outputDic["temperature"] = temperature.description
        }
        
        return outputDic
    }
    
    
    fileprivate func sendInfoForBeaconsDetected() {
        _ = self.beaconList.filter(self.beaconIsValidToSentAction)
            .map(self.validateAction)
    }
    
    // MARK: Private scan methods
    private func performStartScanner() {
        LogDebug("--- START SCANNER ---")
        self.scannerStarted = true
        let serviceUUID:String = EddystoneConstants.serviceUUID
        let services: [CBUUID] = [CBUUID (string:serviceUUID)]
        let options: [String : Any] = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
        
        if self.eddystoneParser == nil {
            self.eddystoneParser = EddystoneProtocolParser(
                requestWaitTime: self.requestWaitTime,
                availableRegions: self.availableRegions,
                output: self.output)
        }
        self.centralManager?.scanForPeripherals(withServices: services, options: options)
    }
    
    private func performStopScanner() {
        LogDebug("--- STOP SCANNER ---")
        self.scannerStarted = false
        self.centralManager?.stopScan()
        self.eddystoneParser?.cleanDetectedBeaconList()
    }
    
    //MARK: Private finish task methods
    private func endStartScannerTask() {
        LogInfo("Number of beacons detected before stopping \(self.beaconList.count)")
        if (self.isAvailableStopTool()) {
            UIApplication.shared.endBackgroundTask(self.startScannerBackgroundTask)
            self.startScannerBackgroundTask = UIBackgroundTaskInvalid
            self.stopScanner()
        }
    }
    
    private func endStopScannerTask() {
        LogInfo("Number of beacons detected before starting \(self.beaconList.count)")
        UIApplication.shared.endBackgroundTask(self.stopScannerBackgroundTask)
        self.stopScannerBackgroundTask = UIBackgroundTaskInvalid
        self.startScanner()
    }
}

extension CBCentralWrapper: CBCentralManagerDelegate {
    // MARK: CBCentralManagerDelegate methods
    func centralManagerDidUpdateState(_ centralManager: CBCentralManager) -> Void {
        if self.scannerStarted,
            centralManager.state != .poweredOn {
            self.stopScanner()
        } else if !self.scannerStarted,
            centralManager.state == .poweredOn {
            self.startEddystoneScanner()
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        LogInfo("centralManager willRestoreState: \(dict)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
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
        
        DispatchQueue.global().sync {
            self.sendInfoForBeaconsDetected()
        }
    }
}
