//
//  GeofenceSpec.swift
//  OrchextraTests
//
//  Created by Judith Medina on 02/10/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import UIKit
import Quick
import Nimble
import CoreLocation
import GIGLibrary
import OHHTTPStubs
@testable import Orchextra

class GeofenceSpec: QuickSpec {
    
    var proximityWrapper: ProximityWrapper!
    var proximityModule: ProximityModule!
    var locationWrapperMock: LocationWrapperMock!
    var storageProximityMock: StorageProximityMock!
    var outputModuleMock: ModuleOutputMock!
    
    override func spec() {
        
        beforeEach {
            self.locationWrapperMock = LocationWrapperMock()
            self.storageProximityMock = StorageProximityMock()
            self.outputModuleMock = ModuleOutputMock()
            
            self.proximityWrapper = ProximityWrapper(
                locationWrapper: self.locationWrapperMock,
                storage: self.storageProximityMock)
            self.proximityModule = ProximityModule(proximityWrapper: self.proximityWrapper)
            self.proximityModule.outputModule = self.outputModuleMock
        }
        
        afterEach {
            self.locationWrapperMock = nil
            self.storageProximityMock = nil
            self.outputModuleMock = nil
            self.proximityWrapper = nil
            self.proximityModule = nil
        }
        
        describe("test proximity module") {
            
            context("start", closure: {
                
                fit("user current location empty") {
                    // Arrange
                    let json = JSONHandler().jsonFrom(filename: "triggering_configuration")
                    self.outputModuleMock.completionConfigInput = json?["data"] as? [String: Any]
                    self.locationWrapperMock.inputCurrentLocation = (location: CLLocation(latitude: 0, longitude: 0), placemark: nil)
                    
                    // Act
                    self.proximityModule.start()
                    
                    // Assert
                    expect(self.outputModuleMock.spySetConfig.called).to(equal(true))
                
                    let geoLocation = self.outputModuleMock.spySetConfig.config?["geoLocation"] as! [String: Any]
                    let point = geoLocation["point"] as! [String: Any]
                    let lat = point["lat"] as! Double
                    let lng = point["lng"] as! Double
                    expect(lat).to(equal(0.0))
                    expect(lng).to(equal(0.0))
                    
                    expect(self.locationWrapperMock.spyStopAllMonitoredRegionsCalled).toEventually(equal(true))
                    expect(self.locationWrapperMock.spyMonitoring.called).toEventually(equal(true))
                    expect(self.storageProximityMock.spySaveRegion.called).toEventually(equal(true))
                    expect(self.locationWrapperMock.spyMonitoring.monitoring.count).toEventually(equal(3))
                }
            })
     
            
//            context("finish") {
//
//                it("without action") {
//
//                }
//
//                it("with action") {
//
//                }
//            }
        }
    }
}
