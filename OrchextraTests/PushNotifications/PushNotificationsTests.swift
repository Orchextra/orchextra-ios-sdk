//
//  PushNotificationsTests.swift
//  OrchextraTests
//
//  Created by Carlos Vicente on 17/11/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Orchextra

class PushNotificationsTests: QuickSpec {
    
    var orchextra: Orchextra!
    var pushorxManagerMock: PushOrxManagerMock!
    
    override func spec() {
        
        beforeEach {
            self.orchextra = Orchextra.shared
            self.pushorxManagerMock = PushOrxManagerMock()
            self.orchextra.pushManager = self.pushorxManagerMock
        }
        
        afterEach {
            self.pushorxManagerMock = nil
        }

        describe("orchextra push notification") {
            context("received") {
                fit("without associated action") {
                    // Arrange
                    let json = JSONHandler().jsonFrom(filename: "push_notification_payload_without_action")
                    
                    // Act
                    self.orchextra.handleRemoteNotification(userInfo: json!)
                    
                    // Assert
                    expect((self.pushorxManagerMock.spyHandleRemoteNotification).called).toEventually(equal(true))
                    XCTAssertNotNil((self.pushorxManagerMock.spyHandleRemoteNotification).userInfo)
                    
                    expect((self.pushorxManagerMock.spyDispatchAction).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyDispatchAction).action)
                }
                
                fit("with webview action") {
                    // Arrange
                    let json = JSONHandler().jsonFrom(filename: "push_notification_payload_with_action_webview")
                    
                    // Act
                    self.orchextra.handleRemoteNotification(userInfo: json!)
                    
                    // Assert
                    expect((self.pushorxManagerMock.spyHandleRemoteNotification).called).toEventually(equal(true))
                    XCTAssertNotNil((self.pushorxManagerMock.spyHandleRemoteNotification).userInfo)
                    
                    expect((self.pushorxManagerMock.spyDispatchAction).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyDispatchAction).action)
                }
            }
        }
        
        describe("push notification") {
            context("without orchextra identifier") {
                fit("without associated action") {
                    // Arrange
                    let json = JSONHandler().jsonFrom(filename: "push_notification_without_orchextra_identifier")
                    
                    // Act
                    self.orchextra.handleRemoteNotification(userInfo: json!)
                    
                    // Assert
                    expect((self.pushorxManagerMock.spyHandleRemoteNotification).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyHandleRemoteNotification).userInfo)
                    
                    expect((self.pushorxManagerMock.spyDispatchAction).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyDispatchAction).action)
                }
                
                fit("with webview action") {
                    // Arrange
                    let json = JSONHandler().jsonFrom(filename: "push_notification_payload_with_action_webview_without_orchextra_identifier")
                    
                    // Act
                    self.orchextra.handleRemoteNotification(userInfo: json!)
                    
                    // Assert
                    expect((self.pushorxManagerMock.spyHandleRemoteNotification).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyHandleRemoteNotification).userInfo)
                    
                    expect((self.pushorxManagerMock.spyDispatchAction).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyDispatchAction).action)
                }
            }
            
            context("with orchextra identifier false") {
                fit("without associated action") {
                    // Arrange
                    let json = JSONHandler().jsonFrom(filename: "push_notification_with_otchextra_identifier_false")
                    
                    // Act
                    self.orchextra.handleRemoteNotification(userInfo: json!)
                    
                    // Assert
                    expect((self.pushorxManagerMock.spyHandleRemoteNotification).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyHandleRemoteNotification).userInfo)
                    
                    expect((self.pushorxManagerMock.spyDispatchAction).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyDispatchAction).action)
                }
                
                fit("with webview action") {
                    // Arrange
                    let json = JSONHandler().jsonFrom(filename: "push_notification_payload_with_action_webview_with_orchextra_identifier_false")
                    
                    // Act
                    self.orchextra.handleRemoteNotification(userInfo: json!)
                    
                    // Assert
                    expect((self.pushorxManagerMock.spyHandleRemoteNotification).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyHandleRemoteNotification).userInfo)
                    
                    expect((self.pushorxManagerMock.spyDispatchAction).called).toEventually(equal(false))
                    XCTAssertNil((self.pushorxManagerMock.spyDispatchAction).action)
                }
            }
        }
    }
}
