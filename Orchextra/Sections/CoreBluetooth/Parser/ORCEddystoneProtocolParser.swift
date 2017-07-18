//
//  EddystonProtocolParser.swift
//  EddystonExample
//
//  Created by Carlos Vicente on 1/7/16.
//  Copyright © 2016 Gigigo SL. All rights reserved.
//

import Foundation

enum frameType {
    case unknown
    case uid
    case url
    case telemetry
    case eid
}

protocol EddystoneParserDelegate {
    func sendInfoForBeaconsDetected()
}

class ORCEddystoneProtocolParser {
    // MARK: Properties
    var peripheralId:UUID?
    var serviceDataInformation: Data?
    var rssi:Int?
    var serviceBytes: [UInt8]?
    var currentFrameType: frameType?
    var currentBeacon: ORCEddystoneBeacon?
    var requestWaitTime: Int
    var regionManager: EddystoneRegionManager
    
    init(requestWaitTime: Int, validatorInteractor: ORCValidatorActionInterator, availableRegions: [ORCEddystoneRegion]) {
        self.requestWaitTime = requestWaitTime
        self.regionManager = EddystoneRegionManager(availableRegions: availableRegions, validatorInteractor: validatorInteractor)
    }
    
    // MARK: Public
    func cleanDetectedBeaconList()  {
        self.regionManager.cleanDetectedBeaconList()
    }
    
    func parse(_ serviceDataInformation:Data, peripheralId:UUID, rssi:Int) -> Void {
        self.peripheralId = peripheralId
        self.rssi = rssi
        self.serviceDataInformation = serviceDataInformation
        self.serviceBytes = [UInt8](repeating: 0, count: serviceDataInformation.count)
        
        guard  var serviceBytes = self.serviceBytes  else { return }
        serviceDataInformation.copyBytes(to: &serviceBytes, count: serviceDataInformation.count)
        self.serviceBytes = serviceBytes
    }
    
    func parseServiceInformation() -> [ORCEddystoneBeacon] {
        guard let serviceBytesInformation = self.serviceBytes else { return self.regionManager.beaconsDetected }
        let frameBytes:UInt8 = serviceBytesInformation[EddystoneConstants.frameTypePosition]
        
        guard let peripheralId = self.peripheralId,
            let rssi = self.rssi else { return self.regionManager.beaconsDetected }
        
        if self.currentBeacon?.peripheralId != peripheralId {
            self.currentBeacon = ORCEddystoneBeacon(peripheralId: peripheralId,
                                                    requestWaitTime: requestWaitTime)
        }
        
        self.currentBeacon?.updateRssiBuffer(rssi: Int8(rssi))
        self.currentFrameType = self.frameType(frameBytes)
        self.parseInformationForFrameType()
        
        return self.regionManager.beaconsDetected
    }
    
    // MARK: Public (FrameType)
    func frameType(_ fromBytes: UInt8) -> frameType {
        var frameType: frameType = .unknown
        switch fromBytes {
        case EddystoneConstants.frameUID:
            frameType = .uid
        case EddystoneConstants.frameURL:
            frameType = .url
        case EddystoneConstants.frameTelemetry:
            frameType = .telemetry
        case EddystoneConstants.frameEID:
            frameType = .eid
        default:
            frameType = .unknown
        }
        
        return frameType
    }
    
    // MARK: Public (Url Scheme Prefix)
    func urlSchemePrefix(_ fromBytes: UInt8) -> String {
        var urlScheme: String = ""
        switch fromBytes {
        case EddystoneConstants.urlSchemePrefixHttp_www:
            urlScheme = EddystoneConstants.urlSchemeTypeHttp_www
        case EddystoneConstants.urlSchemePrefixHttps_www:
            urlScheme = EddystoneConstants.urlSchemeTypeHttps_www
        case EddystoneConstants.urlSchemePrefixHttp:
            urlScheme = EddystoneConstants.urlSchemeTypeHttp
        case EddystoneConstants.urlSchemePrefixHttps:
            urlScheme = EddystoneConstants.urlSchemeTypeHttps
        default:
            urlScheme = ""
        }
        
        return urlScheme
    }
    
    // MARK: Public (Url Decoded)
    func urlDecoded(_ fromBytes: UInt8) -> String {
        var urlDecoded = ""
        
        switch fromBytes {
        case EddystoneConstants.urlEncodingCom_Slash:
            urlDecoded = EddystoneConstants.urlDecodingCom_Slash
        case EddystoneConstants.urlEncodingOrg_Slash:
            urlDecoded = EddystoneConstants.urlDecodingOrg_Slash
        case EddystoneConstants.urlEncodingEdu_Slash:
            urlDecoded = EddystoneConstants.urlDecodingEdu_Slash
        case EddystoneConstants.urlEncodingNet_Slash:
            urlDecoded = EddystoneConstants.urlDecodingNet_Slash
        case EddystoneConstants.urlEncodingInfo_Slash:
            urlDecoded = EddystoneConstants.urlDecodingInfo_Slash
        case EddystoneConstants.urlEncodingBiz_Slash:
            urlDecoded = EddystoneConstants.urlDecodingBiz_Slash
        case EddystoneConstants.urlEncodingGov_Slash:
            urlDecoded = EddystoneConstants.urlDecodingGov_Slash
        case EddystoneConstants.urlEncodingCom:
            urlDecoded = EddystoneConstants.urlDecodingCom
        case EddystoneConstants.urlEncodingOrg:
            urlDecoded = EddystoneConstants.urlDecodingOrg
        case EddystoneConstants.urlEncodingEdu:
            urlDecoded = EddystoneConstants.urlDecodingEdu
        case EddystoneConstants.urlEncodingNet:
            urlDecoded = EddystoneConstants.urlDecodingNet
        case EddystoneConstants.urlEncodingInfo:
            urlDecoded = EddystoneConstants.urlDecodingInfo
        case EddystoneConstants.urlEncodingBiz:
            urlDecoded = EddystoneConstants.urlDecodingBiz
        case EddystoneConstants.urlEncodingGov:
            urlDecoded = EddystoneConstants.urlDecodingGov
        default:
            urlDecoded = ""
        }
        
        return urlDecoded
    }
    
    // MARK: Public (Telemetry Parsing)
    func parseTelemetryInformation() -> Telemetry {
        guard let serviceData:Data = self.serviceDataInformation else {
            return Telemetry(tlmVersion: "",
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
        
        return Telemetry(tlmVersion: tlmVersionString,
                         batteryVoltage: batteryVoltage,
                         batteryPercentage: batteryPercentage,
                         temperature: temperature,
                         advertisingPDUcount: advertisingPDUcountString,
                         uptime: uptime)
        
    }
    
    // MARK: Private methods
    fileprivate func parseTXPowerInformation(_ serviceBytesInformation: [UInt8]) -> UInt8? {
        let txPower:UInt8 = serviceBytesInformation[EddystoneConstants.txPowerPosition]
        return txPower
    }
    
    fileprivate func parseRangingDataInformation(_ serviceBytesInformation: [UInt8]) -> UInt8? {
        let rangingData:UInt8 = serviceBytesInformation[EddystoneConstants.rangingDataPosition]
        return UInt8(rangingData)
    }
    
    fileprivate func parseInformationForFrameType() -> Void {
        guard let type = self.currentFrameType else { return }
        switch type {
        case .uid:
            guard let eddystoneUID = parseUIDInformation() else { return }
            self.currentBeacon?.uid = eddystoneUID
            self.updateRangingData()
        case .url:
            guard let url = parseURLInformation() else { return }
            self.currentBeacon?.url = url
            self.updateRangingData()
        case .telemetry:
            let telemetry:Telemetry = parseTelemetryInformation()
            self.currentBeacon?.telemetry = telemetry
        case .eid:
            guard let eid = parseEIDInformation() else { return }
            self.currentBeacon?.eid = eid
            self.updateRangingData()
        default:
            assert(true, "Invalid frame type")
        }
        
        self.addBeaconIfNeeded()
    }
    
    private func updateRangingData() {
        guard let serviceBytes = self.serviceBytes,
            let rangingData = parseRangingDataInformation(serviceBytes) else { return }
        self.currentBeacon?.rangingData = Int8(bitPattern: rangingData)
    }
    
    // MARK: Private (UUID Parsing)
    fileprivate func parseUIDInformation() -> EddystoneUID? {
        guard let serviceBytes = self.serviceBytes,
            serviceBytes.count >= EddystoneConstants.uidMinimiumSize else { return nil }
        
        let namespace:String = parseRangeOfBytes(serviceBytes, range: Range(uncheckedBounds:(EddystoneConstants.uidNamespaceEndPosition, EddystoneConstants.uidNamespaceInitialPosition)))
        let instance:String = parseRangeOfBytes(serviceBytes, range: Range(uncheckedBounds:(EddystoneConstants.uidInstanceEndPosition, EddystoneConstants.uidInstanceInitialPosition)))
        
        let eddystoneUID = EddystoneUID(namespace: namespace, instance: instance)
        
        return eddystoneUID
    }
    
    // MARK: Private (URL Parsing)
    fileprivate func parseURLInformation() -> URL? {
        var urlString: String = ""
        guard let serviceBytes = self.serviceBytes else { return URL(string: "") }
        
        let urlSchemeBytes:UInt8 = serviceBytes[EddystoneConstants.urlSchemePrefixPosition]
        let urlScheme:String = urlSchemePrefix(urlSchemeBytes)
        
        urlString.append(urlScheme)
        
        for i in EddystoneConstants.urlHostInitialPosition..<serviceBytes.count {
            let bytesToBeDecoded:UInt8 = serviceBytes[i]
            let urlDecoded:String = self.urlDecoded(bytesToBeDecoded)
            
            if urlDecoded.characters.count > 0  {
                urlString.append(urlDecoded)
            } else {
                guard let urlDecoded = String(data: Data(bytes:[bytesToBeDecoded], count: 1) as Data,
                                              encoding: String.Encoding.utf8)  else { return URL(string: urlString) }
                urlString.append(urlDecoded)
            }
        }
        
        return URL(string: urlString)
    }
    
    fileprivate func parseRangeOfBytes(_ serviceBytes:[UInt8], range:Range<Int>) -> String {
        var result:String = ""
        for i in range.upperBound..<range.lowerBound {
            let bytesToBeDecoded:UInt8 = serviceBytes[i]
            let byteDecoded:String = String(bytesToBeDecoded,
                                            radix:EddystoneConstants.bytesToStringConverterRadix,
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
        let range = Range(uncheckedBounds:(serviceBytes.count, EddystoneConstants.eidInitialPosition))
        let eid = self.parseRangeOfBytes(serviceBytes,
                                         range:range)
        
        return eid
    }
    
    // MARK: Private (Telemetry parsing)
    fileprivate func parseTelemetryTlmVersion(_ serviceData: Data) -> String {
        var tlmVersion: UInt8 = 0
        let tlmVersionRange =  Range(uncheckedBounds: (EddystoneConstants.tlmVersionInitialPosition, EddystoneConstants.tlmVersionEndPosition))
        serviceData.copyBytes(to: &tlmVersion, from: tlmVersionRange)
        
        return String(tlmVersion)
    }
    
    fileprivate func parseTelemetryBatteryVoltage(_ serviceData:Data) -> Double {
        let batteryRange: Range<Data.Index> = Range(uncheckedBounds:(EddystoneConstants.tlmBatteryInitialPosition, EddystoneConstants.tlmBatteryEndPosition))
        let batterySubdata:Data = serviceData.subdata(in: batteryRange)
        let batteryVoltage = batterySubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt16>) -> UInt16 in
            let result: UInt16 = UInt16(bigEndian: pointer.pointee)
            return result
        }
        
        let batteryVoltageInMiliVolts:Double = Double(batteryVoltage)
        return batteryVoltageInMiliVolts
    }
    
    fileprivate func parseBatteryPercentage(_ batteryVolts: Double) -> Double {
        var batteryLevel: Double = 0
        if (batteryVolts >= 3000) {
            batteryLevel = 100
        } else if (batteryVolts > 2900) {
            batteryLevel = 100 - ((3000 - batteryVolts) * 58) / 100
        } else if (batteryVolts > 2740) {
            batteryLevel = 42 - ((2900 - batteryVolts) * 24) / 160
        } else if (batteryVolts > 2440) {
            batteryLevel = 18 - ((2740 - batteryVolts) * 12) / 300
        } else if (batteryVolts > 2100) {
            batteryLevel = 6 - ((2440 - batteryVolts) * 6) / 340
        } else {
            batteryLevel = 0
        }
        
        return batteryLevel
    }
    
    fileprivate func parseTelemetryTemperatureFixed(_ serviceData: Data) -> Float {
        let temperatureFixedRange: Range<Data.Index> = Range(uncheckedBounds:(EddystoneConstants.tlmTemperatureFixedInitialPosition, EddystoneConstants.tlmTemperatureFixedEndPosition))
        let beaconTemperatureFixedSubdata:Data = serviceData.subdata(in: temperatureFixedRange)
        
        // This is in 8.8 fixed point. Just have to divide by 256 to get the actual number.
        let beaconTemperatureFixed = beaconTemperatureFixedSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> UInt8 in
            return pointer.pointee
        }
        
        return Float(beaconTemperatureFixed)
    }
    
    fileprivate func parseTelemetryTemperatureFractional(_ serviceData: Data) -> Float {
        let temperatureFractionalRange: Range<Data.Index> = Range(uncheckedBounds:(EddystoneConstants.tlmTemperatureFractionalInitialPosition, EddystoneConstants.tlmTemperatureFractionalEndPosition))
        let beaconTemperatureFractionalSubdata:Data = serviceData.subdata(in: temperatureFractionalRange)
        
        // This is in 8.8 fixed point. Just have to divide by 256 to get the actual number.
        let beaconTemperatureFractional = beaconTemperatureFractionalSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> UInt8 in
            return pointer.pointee
        }
        
        return Float(beaconTemperatureFractional)
    }
    
    fileprivate func parseTelemetryTemperature(_ serviceData:Data) -> Float {
        let temperatureFixed = parseTelemetryTemperatureFixed(serviceData)
        let temperatureFractional = parseTelemetryTemperatureFractional(serviceData)
        
        let temperature = temperatureFixed + temperatureFractional / EddystoneConstants.temperature8pointeNotation
        
        return temperature
    }
    
    fileprivate func parseTelemetryAdvertisingPDUCount(_ serviceData: Data) -> String {
        let advertisingPDUCountRange: Range<Data.Index> = Range(uncheckedBounds:(EddystoneConstants.tlmAdvertisingPDUCountInitialPosition, EddystoneConstants.tlmAdvertisingPDUCountEndPosition))
        let advertisingPDUCountSubdata:Data = serviceData.subdata(in: advertisingPDUCountRange)
        
        let advertisingPDUCount = advertisingPDUCountSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt32>) -> UInt32 in
            let result: UInt32 = UInt32(bigEndian: pointer.pointee)
            return result
        }
        
        return String(advertisingPDUCount)
    }
    
    fileprivate func parseTelemetryUptime(_ serviceData:Data) -> TimeInterval {
        let timeOnSincePowerOnRange: Range<Data.Index> = Range(uncheckedBounds:(EddystoneConstants.tlmTimeOnSincePowerOnInitialPosition, EddystoneConstants.tlmTimeOnSincePowerOnEndPosition))
        let timeOnSincePowerOnSubdata:Data = serviceData.subdata(in: timeOnSincePowerOnRange)
        
        let timeOnSincePowerOn = timeOnSincePowerOnSubdata.withUnsafeBytes { (pointer: UnsafePointer<UInt32>) -> UInt32 in
            let result: UInt32 = UInt32(bigEndian: pointer.pointee)
            return result
        }
        
        let uptime: TimeInterval = TimeInterval(timeOnSincePowerOn)
        return uptime
    }
    
    // MARK: Private (BeaconList)
    // TODO: Convert to functional
//    fileprivate func addBeaconIfNeeded() -> Void {
//        guard let currentBeacon = self.currentBeacon else { return }
//        let beaconsDetected = self.regionManager.beaconsDetected.filter(isCurrentBeaconAlreadyDetected)
//        let beaconsUpdated = beaconsDetected.map { _ in  updateDetectedBeacon }
//
//        if beaconsUpdated.count == 0 {
//            self.regionManager.addDetectedBeacon(beacon: currentBeacon)
//        }
//    }
    
    fileprivate func addBeaconIfNeeded() -> Void {
        var beaconUpdated: Bool = false
        for beacon in self.regionManager.beaconsDetected {
            if beacon.peripheralId == currentBeacon?.peripheralId ||
                beacon.uid?.uidCompossed == currentBeacon?.uid?.uidCompossed {
                
                self.updateRssiBuffer(with: beacon)
                self.updateRangingData(with: beacon)
                self.updateProximity(with: beacon)
                beaconUpdated = self.updateFrameTypeInformation(with: beacon)
            }
        }
        
        guard let currentBeacon = self.currentBeacon,
            beaconUpdated == false else { return }
        
        self.regionManager.addDetectedBeacon(beacon: currentBeacon)
    }
    
    private func isCurrentBeaconAlreadyDetected(beacon: ORCEddystoneBeacon) -> Bool {
        return beacon.peripheralId == currentBeacon?.peripheralId ||
                        beacon.uid?.uidCompossed == currentBeacon?.uid?.uidCompossed
    }
    
    private func updateDetectedBeacon(beacon: ORCEddystoneBeacon) -> Bool {
        self.updateRssiBuffer(with: beacon)
        self.updateRangingData(with: beacon)
        self.updateProximity(with: beacon)
        return self.updateFrameTypeInformation(with: beacon)
    }
    
    private func updateRangingData(with beacon: ORCEddystoneBeacon) {
        guard let rangingData = currentBeacon?.rangingData else { return }
        beacon.rangingData = rangingData
    }
    
    private func updateRssiBuffer(with beacon: ORCEddystoneBeacon) {
        guard let rssiBuffer = currentBeacon?.rssiBuffer else { return }
        _ = rssiBuffer.map { _ in beacon.updateRssiBuffer }
    }
    
    private func updateTxPower(with beacon: ORCEddystoneBeacon) {
        guard let txPower = currentBeacon?.txPower else { return }
        beacon.txPower = txPower
    }
    
    private func updateProximity(with beacon: ORCEddystoneBeacon) {
        guard let currentBeaconProximity = currentBeacon?.proximity,
            currentBeaconProximity != .unknown else {
                beacon.updateProximity(currentProximity: .unknown)
                return
        }
        
        let beaconProximity = beacon.proximity
        if currentBeaconProximity != beaconProximity {
            beacon.updateProximity(currentProximity: currentBeaconProximity)
        }
        
        guard let currentBeaconProximityTimer = currentBeacon?.proximityTimer else {
            beacon.updateProximity(currentProximity: currentBeaconProximity)
            return
        }
        
        beacon.proximityTimer = currentBeaconProximityTimer
        if currentBeaconProximityTimer.fireDate <= Date() {
            beacon.proximityTimer?.fire()
        }
    }
    
    private func updateFrameTypeInformation(with beacon: ORCEddystoneBeacon) -> Bool {
        var beaconUpdated: Bool = false
        guard let type = currentFrameType else { return beaconUpdated }
        switch type {
        case .unknown:
            assert(true, "Update not allowed")
        case .uid:
            beacon.uid = currentBeacon?.uid
            beaconUpdated = true
        case .url:
            beacon.url = currentBeacon?.url
            beaconUpdated = true
        case .telemetry:
            beacon.telemetry = currentBeacon?.telemetry
            beaconUpdated = true
        case .eid:
            beacon.eid = currentBeacon?.eid
            beaconUpdated = true
        }
        
        return beaconUpdated
    }
}
