//
//  EddystonProtocolParser.swift
//  EddystonExample
//
//  Created by Carlos Vicente on 1/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

protocol EddystoneParserDelegate {
    func sendInfoForBeaconsDetected()
}

class EddystoneProtocolParser {
    // MARK: Properties
    var serviceDataInformation: Data?
    var serviceBytes: [UInt8]?
    var peripheralId: UUID?
    var requestWaitTime: Int
    var rssi: Int?
    var currentFrameType: FrameType?
    var currentBeacon: EddystoneBeacon?
    var regionManager: EddystoneRegionManager
    
    init(
        requestWaitTime: Int,
        availableRegions: [EddystoneRegion],
        output: EddystoneOutput?
        ) {
        self.requestWaitTime = requestWaitTime
        self.regionManager = EddystoneRegionManager(
            availableRegions: availableRegions,
            output: output
        )
    }
    
    // MARK: Public
    func cleanDetectedBeaconList() {
        self.regionManager.cleanDetectedBeaconList()
    }
    
    func parse(_ serviceDataInformation: Data, peripheralId: UUID, rssi: Int) {
        self.peripheralId = peripheralId
        self.rssi = rssi
        self.serviceDataInformation = serviceDataInformation
        self.serviceBytes = [UInt8](repeating: 0, count: serviceDataInformation.count)
        
        guard  var serviceBytes = self.serviceBytes  else { return }
        serviceDataInformation.copyBytes(to: &serviceBytes, count: serviceDataInformation.count)
        self.serviceBytes = serviceBytes
    }
    
    func parseServiceInformation() -> [EddystoneBeacon] {
        guard let serviceBytesInformation = self.serviceBytes else { return self.regionManager.beaconsDetected }
        let frameBytes: UInt8 = serviceBytesInformation[EddystoneConstants.frameTypePosition]
        
        guard let peripheralId = self.peripheralId,
            let rssi = self.rssi else { return self.regionManager.beaconsDetected }
        
        if self.currentBeacon?.peripheralId != peripheralId {
            self.currentBeacon = EddystoneBeacon(peripheralId: peripheralId,
                                                    requestWaitTime: requestWaitTime)
        }
        
        self.currentBeacon?.updateRssiBuffer(rssi: Int8(rssi))
        self.currentFrameType = EddystoneDecoder.frameType(frameBytes)
        self.parseInformationForFrameType()
    
        return self.regionManager.beaconsDetected
    }
    
    // MARK: Public (Telemetry Parsing)
    func parseTelemetryInformation() -> EddystoneTelemetry {
        guard let serviceData: Data = self.serviceDataInformation else {
            return EddystoneTelemetry(tlmVersion: "",
                                         batteryVoltage: 0,
                                         batteryPercentage: 0,
                                         temperature: 0,
                                         advertisingPDUcount: "",
                                         uptime: 0)
        }
        
        let tlmVersionString = self.parseTelemetryTlmVersion(serviceData)
        let batteryVoltage = self.parseTelemetryBatteryVoltage(serviceData)
        let batteryPercentage = self.parseBatteryPercentage(batteryVoltage)
        let temperature = self.parseTelemetryTemperature(serviceData)
        let advertisingPDUcountString = self.parseTelemetryAdvertisingPDUCount(serviceData)
        let uptime = self.parseTelemetryUptime(serviceData)
        
        return EddystoneTelemetry(tlmVersion: tlmVersionString,
                                     batteryVoltage: batteryVoltage,
                                     batteryPercentage: batteryPercentage,
                                     temperature: temperature,
                                     advertisingPDUcount: advertisingPDUcountString,
                                     uptime: uptime)
        
    }
    
    // MARK: Private methods
    fileprivate func parseRangingDataInformation(_ serviceBytesInformation: [UInt8]) -> UInt8? {
        let rangingData: UInt8 = serviceBytesInformation[EddystoneConstants.rangingDataPosition]
        return UInt8(rangingData)
    }
    
    fileprivate func parseInformationForFrameType() {
        guard let type = self.currentFrameType else { return }
        switch type {
        case .uid:
            guard let eddystoneUID = parseUIDInformation() else { return }
            self.currentBeacon?.uid = eddystoneUID
            self.parseRangingData()
        case .url:
            guard let url = parseURLInformation() else { return }
            self.currentBeacon?.url = url
            self.parseRangingData()
        case .telemetry:
            let telemetry = parseTelemetryInformation()
            self.currentBeacon?.telemetry = telemetry
        case .eid:
            guard let eid = parseEIDInformation() else { return }
            self.currentBeacon?.eid = eid
            self.parseRangingData()
        default:
            assert(true, "Invalid frame type")
        }
        self.updateBeaconList()
    }
    
    private func parseRangingData() {
        guard let serviceBytes = self.serviceBytes,
            let rangingData = parseRangingDataInformation(serviceBytes) else { return }
        self.currentBeacon?.rangingData = Int8(bitPattern: rangingData)
    }
    
    // MARK: Private (UUID Parsing)
    fileprivate func parseUIDInformation() -> EddystoneUID? {
        guard let serviceBytes = self.serviceBytes,
            serviceBytes.count >= EddystoneConstants.uidMinimiumSize else { return nil }
        
        let namespace: String = parseRangeOfBytes(serviceBytes, range: Range(uncheckedBounds: (EddystoneConstants.uidNamespaceEndPosition, EddystoneConstants.uidNamespaceInitialPosition)))
        let instance: String = parseRangeOfBytes(serviceBytes, range: Range(uncheckedBounds: (EddystoneConstants.uidInstanceEndPosition, EddystoneConstants.uidInstanceInitialPosition)))
        
        let eddystoneUID = EddystoneUID(namespace: namespace, instance: instance)
        
        return eddystoneUID
    }
    
    // MARK: Private (URL Parsing)
    fileprivate func parseURLInformation() -> URL? {
        var urlString: String = ""
        guard let serviceBytes = self.serviceBytes else { return URL(string: "") }
        
        let urlSchemeBytes: UInt8 = serviceBytes[EddystoneConstants.urlSchemePrefixPosition]
        let urlScheme: String = EddystoneDecoder.urlSchemePrefix(urlSchemeBytes)
        
        urlString.append(urlScheme)
        
        for i in EddystoneConstants.urlHostInitialPosition..<serviceBytes.count {
            let bytesToBeDecoded: UInt8 = serviceBytes[i]
            let urlDecoded: String = EddystoneDecoder.urlDecoded(bytesToBeDecoded)
            
            if urlDecoded.characters.count > 0 {
                urlString.append(urlDecoded)
            } else {
                guard let urlDecoded = String(data: Data(bytes: [bytesToBeDecoded], count: 1) as Data,
                                              encoding: String.Encoding.utf8)  else { return URL(string: urlString) }
                urlString.append(urlDecoded)
            }
        }
        
        return URL(string: urlString)
    }
    
    fileprivate func parseRangeOfBytes(_ serviceBytes: [UInt8], range: Range<Int>) -> String {
        var result: String = ""
        for i in range.upperBound..<range.lowerBound {
            let bytesToBeDecoded: UInt8 = serviceBytes[i]
            let byteDecoded: String = String(bytesToBeDecoded,
                                            radix: EddystoneConstants.bytesToStringConverterRadix,
                                            uppercase: false)
            
            if byteDecoded.characters.count == 1 {
                result.append("0")
            }
            
            result.append(byteDecoded)
        }
        
        return result
    }
    
    // MARK: Private (EID Parsing)
    fileprivate func parseEIDInformation() -> String? {
        guard let serviceBytes = self.serviceBytes else { return nil }
        let range = Range(uncheckedBounds: (serviceBytes.count, EddystoneConstants.eidInitialPosition))
        let eid = self.parseRangeOfBytes(serviceBytes,
                                         range: range)
        
        return eid
    }
    
    // MARK: Private (Telemetry parsing)
    fileprivate func parseTelemetryTlmVersion(_ serviceData: Data) -> String {
        var tlmVersion: UInt8 = 0
        let tlmVersionRange =  Range(uncheckedBounds: (EddystoneConstants.tlmVersionInitialPosition, EddystoneConstants.tlmVersionEndPosition))
        serviceData.copyBytes(to: &tlmVersion, from: tlmVersionRange)
        
        return String(tlmVersion)
    }
    
    fileprivate func parseTelemetryBatteryVoltage(_ serviceData: Data) -> Double {
        let batteryRange: Range<Data.Index> = Range(uncheckedBounds: (EddystoneConstants.tlmBatteryInitialPosition, EddystoneConstants.tlmBatteryEndPosition))
        let batterySubdata: Data = serviceData.subdata(in: batteryRange)
        let batteryVoltage = batterySubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt16>) -> UInt16 in
            let result: UInt16 = UInt16(bigEndian: pointer.pointee)
            return result
        }
        
        let batteryVoltageInMiliVolts: Double = Double(batteryVoltage)
        return batteryVoltageInMiliVolts
    }
    
    fileprivate func parseBatteryPercentage(_ batteryVolts: Double) -> Double {
        var batteryLevel: Double = 0
        if batteryVolts >= 3000 {
            batteryLevel = 100
        } else if batteryVolts > 2900 {
            batteryLevel = 100 - ((3000 - batteryVolts) * 58) / 100
        } else if batteryVolts > 2740 {
            batteryLevel = 42 - ((2900 - batteryVolts) * 24) / 160
        } else if batteryVolts > 2440 {
            batteryLevel = 18 - ((2740 - batteryVolts) * 12) / 300
        } else if batteryVolts > 2100 {
            batteryLevel = 6 - ((2440 - batteryVolts) * 6) / 340
        } else {
            batteryLevel = 0
        }
        
        return batteryLevel
    }
    
    fileprivate func parseTelemetryTemperatureFixed(_ serviceData: Data) -> Float {
        let temperatureFixedRange: Range<Data.Index> = Range(uncheckedBounds: (EddystoneConstants.tlmTemperatureFixedInitialPosition, EddystoneConstants.tlmTemperatureFixedEndPosition))
        let beaconTemperatureFixedSubdata: Data = serviceData.subdata(in: temperatureFixedRange)
        
        // This is in 8.8 fixed point. Just have to divide by 256 to get the actual number.
        let beaconTemperatureFixed = beaconTemperatureFixedSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> UInt8 in
            return pointer.pointee
        }
        
        return Float(beaconTemperatureFixed)
    }
    
    fileprivate func parseTelemetryTemperatureFractional(_ serviceData: Data) -> Float {
        let temperatureFractionalRange: Range<Data.Index> = Range(uncheckedBounds: (EddystoneConstants.tlmTemperatureFractionalInitialPosition, EddystoneConstants.tlmTemperatureFractionalEndPosition))
        let beaconTemperatureFractionalSubdata: Data = serviceData.subdata(in: temperatureFractionalRange)
        
        // This is in 8.8 fixed point. Just have to divide by 256 to get the actual number.
        let beaconTemperatureFractional = beaconTemperatureFractionalSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> UInt8 in
            return pointer.pointee
        }
        
        return Float(beaconTemperatureFractional)
    }
    
    fileprivate func parseTelemetryTemperature(_ serviceData: Data) -> Float {
        let temperatureFixed = parseTelemetryTemperatureFixed(serviceData)
        let temperatureFractional = parseTelemetryTemperatureFractional(serviceData)
        
        let temperature = temperatureFixed + temperatureFractional / EddystoneConstants.temperature8pointeNotation
        
        return temperature
    }
    
    fileprivate func parseTelemetryAdvertisingPDUCount(_ serviceData: Data) -> String {
        let advertisingPDUCountRange: Range<Data.Index> = Range(uncheckedBounds: (EddystoneConstants.tlmAdvertisingPDUCountInitialPosition, EddystoneConstants.tlmAdvertisingPDUCountEndPosition))
        let advertisingPDUCountSubdata: Data = serviceData.subdata(in: advertisingPDUCountRange)
        
        let advertisingPDUCount = advertisingPDUCountSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt32>) -> UInt32 in
            let result: UInt32 = UInt32(bigEndian: pointer.pointee)
            return result
        }
        
        return String(advertisingPDUCount)
    }
    
    fileprivate func parseTelemetryUptime(_ serviceData: Data) -> TimeInterval {
        let timeOnSincePowerOnRange: Range<Data.Index> = Range(uncheckedBounds: (EddystoneConstants.tlmTimeOnSincePowerOnInitialPosition, EddystoneConstants.tlmTimeOnSincePowerOnEndPosition))
        let timeOnSincePowerOnSubdata: Data = serviceData.subdata(in: timeOnSincePowerOnRange)
        
        let timeOnSincePowerOn = timeOnSincePowerOnSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt32>) -> UInt32 in
            let result: UInt32 = UInt32(bigEndian: pointer.pointee)
            return result
        }
        
        let uptime: TimeInterval = TimeInterval(timeOnSincePowerOn)
        return uptime
    }
    
    // MARK: Private (BeaconList)
    fileprivate func updateBeaconList() {
        var beaconsDetected: [EddystoneBeacon] = self.regionManager.beaconsDetected
            .filter(self.isCurrentBeaconAlreadyDetected)
            .map(self.updateRssiBuffer)
            .map(self.updateRangingData)
            .map(self.updateProximity)
            .map(self.updateFrameTypeInformation)
            .map(self.updateHasBeenSent)
        
        if beaconsDetected.count == 0 {
            if let currentBeacon = self.currentBeacon {
                beaconsDetected.append(currentBeacon)
            }
        }
        
        self.regionManager.updateBeaconsDetected(with: beaconsDetected)
    }
    
    private func isCurrentBeaconAlreadyDetected(beacon: EddystoneBeacon) -> Bool {
        return beacon.peripheralId == currentBeacon?.peripheralId ||
            beacon.uid?.uidCompossed == currentBeacon?.uid?.uidCompossed
    }
    
    private func updateRangingData(with beacon: EddystoneBeacon) -> EddystoneBeacon {
        guard let rangingData = currentBeacon?.rangingData else { return beacon }
        beacon.rangingData = rangingData
        return beacon
    }
    
    private func updateRssiBuffer(with beacon: EddystoneBeacon) -> EddystoneBeacon {
        guard let rssiBuffer = currentBeacon?.rssiBuffer else { return beacon }
        _ = rssiBuffer.map { _ in beacon.updateRssiBuffer }
        return beacon
    }
    
    private func updateProximity(with beacon: EddystoneBeacon) -> EddystoneBeacon {
        guard let currentBeaconProximity = currentBeacon?.proximity,
            currentBeaconProximity != .unknown else { return beacon }
        
        var beaconUpdated = beacon
        let beaconProximity = beacon.proximity
        beaconUpdated = beaconUpdated.updateProximity(currentProximity: beaconProximity)
        if currentBeaconProximity == beaconProximity {
            guard let proximityTimer = currentBeacon?.proximityTimer else { return beaconUpdated }
            beaconUpdated.proximityTimer = proximityTimer
            if proximityTimer.fireDate <= Date() {
                beaconUpdated.proximityTimer?.fire()
            }
        }
    
        return beaconUpdated
    }
    
    private func updateFrameTypeInformation(with beacon: EddystoneBeacon) -> EddystoneBeacon {
        guard let type = currentFrameType else { return beacon }
        switch type {
        case .unknown:
            assert(true, "Update not allowed")
        case .uid:
            beacon.uid = currentBeacon?.uid
        case .url:
            beacon.url = currentBeacon?.url
        case .telemetry:
            beacon.telemetry = currentBeacon?.telemetry
        case .eid:
            beacon.eid = currentBeacon?.eid
        }
        return beacon
    }
    
    private func updateHasBeenSent(with beacon: EddystoneBeacon) -> EddystoneBeacon {
        let beaconUpdated = beacon
        beaconUpdated.hasBeenSent = self.currentBeacon?.hasBeenSent ?? false
        return beaconUpdated
    }
}
