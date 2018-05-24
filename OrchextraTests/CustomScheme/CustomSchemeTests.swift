//
//  CustomSchemeTests.swift
//  OrchextraTests
//
//  Created by Carlos Vicente on 22/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import Orchextra

class CustomSchemeTests: QuickSpec {
    let orchextra: Orchextra = Orchextra.shared
    var orxDelegate: ORXDelegateMock!
    var scannerMock: ScannerVCMock!
    
    override func spec() {
        
        beforeEach {
            self.orxDelegate = ORXDelegateMock()
            self.orchextra.delegate = self.orxDelegate
            self.scannerMock = ScannerVCMock()
            OrchextraController.shared.setScanner(vc: self.scannerMock)
        }
        
        afterEach {
            self.orxDelegate = nil
        }
        
        describe("orchextra custom scheme") {
            context("scanner") {
                fit("is called") {
                    // Arrange
                    let scannerCustomScheme = Config.scannerCustomScheme
                    let actionCustomScheme = ActionCustomScheme(
                        id: nil,
                        trackId: nil,
                        urlString: scannerCustomScheme,
                        type: "customScheme",
                        scredule: nil,
                        notification: nil
                    )
                    
                    // Act
                    actionCustomScheme.executable()
                    
                    // Assert
                    XCTAssertNil((self.orxDelegate.spyCustomSchemeCalled).scheme)
                    expect((self.orxDelegate.spyCustomSchemeCalled).called).toEventually(equal(false))
                    expect(self.scannerMock.spyShowScannerCalled).toEventually(equal(true))
                }
            }
        }
        
        describe("orchextra custom scheme") {
            context("not implemented") {
                fit("is called") {
                    // Arrange
                    let scannerCustomScheme = "Orchextra://customSchemeNotManagedYet"
                    let actionCustomScheme = ActionCustomScheme(
                        id: nil,
                        trackId: nil,
                        urlString: scannerCustomScheme,
                        type: "customScheme",
                        scredule: nil,
                        notification: nil
                    )
                    
                    // Act
                    actionCustomScheme.executable()
                    
                    // Assert
                    XCTAssertNotNil((self.orxDelegate.spyCustomSchemeCalled).scheme)
                    expect((self.orxDelegate.spyCustomSchemeCalled).called).toEventually(equal(true))
                }
            }
        }
        
        describe("custom scheme scanner") {
            context("not managed by Orchextra") {
                fit("is called") {
                    // Arrange
                    let scannerCustomScheme = "ocm://scanner"
                    let actionCustomScheme = ActionCustomScheme(
                        id: nil,
                        trackId: nil,
                        urlString: scannerCustomScheme,
                        type: "customScheme",
                        scredule: nil,
                        notification: nil
                    )
                    
                    // Act
                    actionCustomScheme.executable()
                    
                    // Assert
                    XCTAssertNotNil((self.orxDelegate.spyCustomSchemeCalled).scheme)
                    expect((self.orxDelegate.spyCustomSchemeCalled).called).toEventually(equal(true))
                }
            }
        }
    }
}
