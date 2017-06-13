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

@objc public class ORCCBCentralWrapper: NSObject, CBCentralManagerDelegate {
    
    // MARK: Public properties
    public static var scanLevel: CoreBluetoothScanLevel = .scanByIntervals
    public var centralManager: CBCentralManager?
    
    @objc var validatorInteractor: ORCValidatorActionInterator
    @objc var actionInterface: ORCActionInterface
    var centralManagerQueue: DispatchQueue
    var requestWaitTime: Int
    var eddystoneParser: ORCEddystoneProtocolParser?
    var scannerStarted: Bool
    var beaconList: [ORCEddystoneBeacon]
    var scanningTimer: Timer?
    var stoppedScannerTimer: Timer?
    
    // MARK: Public methods
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
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: ORCCoreBluetoothStart),
                                                  object: nil
        )
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: ORCCoreBluetoothStop),
                                                  object: nil
        )
    }
    
    @objc public func initializeCentralManager() {
        let centralManager = CBCentralManager(delegate: self,
                                              queue:self.centralManagerQueue,
                                              options: [CBCentralManagerOptionRestoreIdentifierKey : "ORCCentralManagerIdentifier"])
        
        self.centralManager = centralManager
    }
    
    @objc public func createLocalNotification(with event: String, duration: Int) {
        let currentDate = Date()
        let timeToFireNotification: UInt = UInt(duration)
        let timeInterval = TimeInterval(timeToFireNotification)
        let userInfo: [AnyHashable : Any] = ["type": ORCTypeCoreBluetooth,
                                             "core_bluetooth_event": event]
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                            repeats: true)
            let content = UNMutableNotificationContent()
            let identifier = event
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            })
            
        } else {
            let localNotification = UILocalNotification()
            localNotification.fireDate = Date(timeInterval: timeInterval, since: currentDate)
            localNotification.userInfo = userInfo
            
            guard let scheduledNotifications = UIApplication.shared.scheduledLocalNotifications else { return }
            if !(scheduledNotifications.contains(localNotification)) {
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }
        }
    }
    
    @objc public func startScanner() -> Void {
        if !self.scannerStarted,
            self.centralManager?.state == .poweredOn {
            
            DispatchQueue.global().async (execute: {
                self.scannerStarted = true
                let serviceUUID:String = EddystoneConstants.serviceUUID
                let services: [CBUUID] = [CBUUID (string:serviceUUID)]
                let options: [String : Any] = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
                
                if self.eddystoneParser == nil {
                    self.eddystoneParser = ORCEddystoneProtocolParser(requestWaitTime: self.requestWaitTime, validatorInteractor: self.validatorInteractor)
                }
                self.cancelLocalNotification(for: ORCCoreBluetoothStop)
                self.createLocalNotification(with: ORCCoreBluetoothStart, duration: EddystoneConstants.timeToScan)
                self.centralManager?.scanForPeripherals(withServices: services, options: options)
                
            })
            
            
            //            DispatchQueue.global().async {
            //                self.scannerStarted = true
            //                let serviceUUID:String = EddystoneConstants.serviceUUID
            //                let services: [CBUUID] = [CBUUID (string:serviceUUID)]
            //                let options: [String : Any] = [CBCentralManagerScanOptionAllowDuplicatesKey : true]
            //
            //                if self.eddystoneParser == nil {
            //                    self.eddystoneParser = ORCEddystoneProtocolParser(requestWaitTime: self.requestWaitTime, validatorInteractor: self.validatorInteractor)
            //                }
            //
            //                self.centralManager?.scanForPeripherals(withServices: services, options: options)
            //
            //                self.initializeScanningTimer()
            //                if self.isAvailableStopTool() {
            //                    self.invalidateStoppedScanerTimer()
            //                }
            //            }
        }
    }
    
    @objc public func stopScanner() -> Void {
        DispatchQueue.global().async (execute: {
            self.scannerStarted = false
            self.centralManager?.stopScan()
            self.cancelLocalNotification(for: ORCCoreBluetoothStart)
            if self.isAvailableStopTool() {
                self.createLocalNotification(with: ORCCoreBluetoothStop, duration: EddystoneConstants.timeToStopScanner)
            }
        })
        self.eddystoneParser?.cleanDetectedBeaconList()
        
        //        DispatchQueue.global().async (execute: {
        //            self.scannerStarted = false
        //            self.centralManager?.stopScan()
        //            self.invalidateScanningTimer()
        //            if self.isAvailableStopTool() {
        //                self.initializeStoppedScannerTimer()
        //            }
        //        })
        //        self.eddystoneParser?.cleanDetectedBeaconList()
    }
    
    // MARK: Private utilities
    private func beaconIsValidToSentAction(beacon: ORCEddystoneBeacon) -> Bool {
        return beacon.canBeSentToValidateAction()
    }
    
    private func validateAction(beacon: ORCEddystoneBeacon) {
        self.validatorInteractor.validateProximity(with: beacon, completion: {(action, error) in
            guard let actionNotNil = action else { return }
            
            actionNotNil.launchedByTriggerCode = beacon.uid?.uidCompossed
            self.actionInterface.didFireTrigger(with: action)
        })
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
    
    // MARK: Private timer methods
    
    private func cancelLocalNotification(for event: String) {
        if #available(iOS 10, *) {
        } else {
            let localNotificationsScheduledFiltered = UIApplication.shared.scheduledLocalNotifications?.filter ({ localNotification in
                guard let userInfo = localNotification.userInfo,
                    let eventType: String = userInfo["core_bluetooth_event"] as? String else { return false }
                return  eventType == event
            })
            UIApplication.shared.scheduledLocalNotifications = localNotificationsScheduledFiltered
        }
    }
//    private func initializeScanningTimer() {
//        DispatchQueue.global().async(execute: {
//            let timerTimeInterval = TimeInterval(EddystoneConstants.timeToScan)
//            
//            self.scanningTimer = Timer.scheduledTimer(timeInterval: timerTimeInterval,
//                                                      target: self,
//                                                      selector: #selector(self.stopScanner),
//                                                      userInfo: nil,
//                                                      repeats: true)
//            
//            guard let timer = self.scanningTimer else { return }
//            self.addTimerToBackground(timer: timer)
//        })
//    }
    
//    private func initializeStoppedScannerTimer() {
//        DispatchQueue.global().async(execute: {
//            let timerTimeInterval = TimeInterval(EddystoneConstants.timeToStopScanner)
//            
//            self.stoppedScannerTimer = Timer.scheduledTimer(timeInterval: timerTimeInterval,
//                                                            target: self,
//                                                            selector: #selector(self.startScanner),
//                                                            userInfo: nil,
//                                                            repeats: true)
//            
//            guard let timer = self.stoppedScannerTimer else { return }
//            self.addTimerToBackground(timer: timer)
//        })
//    }
    
//    private func invalidateScanningTimer() {
//        self.scanningTimer?.invalidate()
//        self.scanningTimer = nil
//    }
//    
//    private func invalidateStoppedScanerTimer() {
//        self.stoppedScannerTimer?.invalidate()
//        self.stoppedScannerTimer = nil
//    }
    
    private func sendInfoForBeaconsDetected() {
        DispatchQueue.global().sync(execute: {
            ORCLog.logVerbose(format: "Number of beacons detected \(self.beaconList.count)")
            let beaconListValidToSentAction = self.beaconList.filter(self.beaconIsValidToSentAction)
            for beacon in beaconListValidToSentAction {
                self.validateAction(beacon: beacon)
            }
        })
    }
    
//    private func addTimerToBackground(timer: Timer) {
//        RunLoop.current.add(timer, forMode: .commonModes)
//        RunLoop.current.run()
//    }
    
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
        
        self.sendInfoForBeaconsDetected()
    }
}
