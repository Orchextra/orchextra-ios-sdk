//
//  ORCEddystoneBeaconTests.swift
//  Orchextra
//
//  Created by Carlos Vicente on 27/7/17.
//  Copyright © 2017 Gigigo. All rights reserved.
//

import XCTest
@testable import Orchextra

class ORCEddystoneBeaconTests: XCTestCase {
    var beacon: ORCEddystoneBeacon?
    
    override func setUp() {
        super.setUp()
        guard let peripheralId = UUID(uuidString: "4B9F9513-2877-77B1-5B9F-A198CCF814DF") else { return }
        self.beacon = ORCEddystoneBeacon(
            peripheralId: peripheralId,
            requestWaitTime: 120
        )
    }
    
    override func tearDown() {
        self.beacon = nil
        super.tearDown()
    }
    
    // MARK: Tests validating actions
    func testcanBeSentToValidateActionWithoutUpdatingBeaconInfo() {
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingUIDWithoutInstance() {
        self.updateBeaconWithUIDWithoutInstance()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingUIDWithInstance() {
        self.updateBeaconWithUIDWithInstance()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingUrl() {
        self.updateBeaconWithUrl()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingUIDWithUIDAndUrl() {
        self.updateBeaconWithUIDWithInstance()
        self.updateBeaconWithUrl()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingRSSI() {
        self.updateBeaconWithRSSI()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingUIDWithUIDAndUrlAndRSSI() {
        self.updateBeaconWithUIDWithInstance()
        self.updateBeaconWithUrl()
        self.updateBeaconWithRSSI()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingProximityTimer() {
        self.updateProximityTimer()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingUIDWithUIDAndUrlAndRSSIAndProximityTimer() {
        self.updateBeaconWithUIDWithInstance()
        self.updateBeaconWithUrl()
        self.updateBeaconWithRSSI()
        self.updateProximityTimer()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertTrue(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingTelemetry() {
        self.updateBeaconWithTelemetry()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertFalse(canBeSentToValidateAction)
    }
    
    func testcanBeSentToValidateActionUpdatingUIDWithUIDAndUrlAndRSSIAndProximityTimerAndTelemetry() {
        self.updateBeaconWithUIDWithInstance()
        self.updateBeaconWithUrl()
        self.updateBeaconWithRSSI()
        self.updateProximityTimer()
        self.updateBeaconWithTelemetry()
        guard let canBeSentToValidateAction = self.beacon?.canBeSentToValidateAction() else { return }
        XCTAssertTrue(canBeSentToValidateAction)
    }

    
    // MARK: Utilities
    private func updateBeaconWithUIDWithoutInstance() {
        let uid = ORCEddystoneUID(
            namespace: "636f6b65634063656575",
            instance: ""
        )
        self.beacon?.uid = uid
    }
    
    private func updateBeaconWithUIDWithInstance() {
        let uid = ORCEddystoneUID(
            namespace: "636f6b65634063656575",
            instance: "100000303976"
        )
        self.beacon?.uid = uid
    }
    
    private func updateBeaconWithUrl() {
        let url = URL(string: "www.gigigo.com")
        self.beacon?.url = url
    }
    
    private func updateBeaconWithTelemetry() {
        let telemetry = ORCEddystoneTelemetry(
            tlmVersion: "0",
            batteryVoltage: 3632,
            batteryPercentage: 100,
            temperature: 28.1875,
            advertisingPDUcount: "175795000",
            uptime: 123456
        )
        self.beacon?.telemetry = telemetry
    }
    
    private func updateBeaconWithRSSI() {
        let rssi = Int8(-41)
        self.beacon?.updateRssiBuffer(rssi: rssi)
    }
    
    @objc private func timerSelector() {
        print("timer did fired")
    }
    
    private func updateProximityTimer() {
        self.beacon?.proximityTimer = Timer(timeInterval: 1.0,
                                            target: self,
                                            selector: #selector(timerSelector),
                                            userInfo: nil,
                                            repeats: false)
    }
}
