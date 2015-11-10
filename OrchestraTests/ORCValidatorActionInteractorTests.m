//
//  ORCValidatorActionInteractorTests.m
//  Orchestra
//
//  Created by Judith Medina on 7/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCActionCommunicator.h"
#import "ORCValidatorActionInterator.h"
#import "ORCTriggerRegion.h"
#import "ORCTriggerBeacon.h"
#import "ORCTriggerGeofence.h"


@interface ORCValidatorActionInteractorTests : XCTestCase

@property (strong, nonatomic) ORCActionCommunicator *communicatorMock;
@property (strong, nonatomic) ORCValidatorActionInterator *validatorInterator;

@end


@implementation ORCValidatorActionInteractorTests

- (void)setUp
{
    [super setUp];
    
    self.communicatorMock = MKTMock([ORCActionCommunicator class]);
    self.validatorInterator = [[ORCValidatorActionInterator alloc] initWithCommunicator:self.communicatorMock];
}

- (void)tearDown
{
    [super tearDown];
    
    self.communicatorMock = nil;
    self.validatorInterator = nil;
}

- (void)test_validate_scan_barcode
{
    NSDictionary *valitateValues = @{@"type" : ORCTypeBarcode, @"value" : @"12345"};
    [self.validatorInterator validateScanType:ORCTypeBarcode scannedValue:@"12345" completion:nil];

    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];

    XCTAssert([valitateValues[@"type"] isEqualToString:formattedValues[@"type"]]);
    XCTAssert([valitateValues[@"value"] isEqualToString:formattedValues[@"value"]]);
}

- (void)test_validate_scan_qr
{
    NSDictionary *valitateValues = @{@"type" : ORCTypeQR, @"value" : @"12345"};
    
    [self.validatorInterator validateScanType:ORCTypeQR scannedValue:@"12345" completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([valitateValues[@"type"] isEqualToString:formattedValues[@"type"]]);
    XCTAssert([valitateValues[@"value"] isEqualToString:formattedValues[@"value"]]);
}

- (void)test_validate_vuforia
{
    NSDictionary *valitateValues = @{@"type" : ORCTypeVuforia, @"value" : @"12345"};
    
    [self.validatorInterator validateVuforia:@"12345" completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([valitateValues[@"type"] isEqualToString:formattedValues[@"type"]]);
    XCTAssert([valitateValues[@"value"] isEqualToString:formattedValues[@"value"]]);
}

- (void)test_validate_beacon
{
    NSDictionary *valitateValues = @{@"type" : ORCTypeBeacon, @"value" : @"BeaconIdentifier"};

    ORCTriggerBeacon *beacon = [[ORCTriggerBeacon alloc] init];
    beacon.type = ORCTypeBeacon;
    beacon.identifier = @"BeaconIdentifier";
    beacon.currentProximity = CLProximityFar;
    beacon.currentEvent = ORCTypeEventEnter;
    
    [self.validatorInterator validateProximityWithBeacon:beacon completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([valitateValues[@"type"] isEqualToString:formattedValues[@"type"]]);
    XCTAssert([valitateValues[@"value"] isEqualToString:formattedValues[@"value"]]);
}

- (void)test_validate_geofences
{
    NSDictionary *valitateValues = @{@"type" : ORCTypeGeofence, @"value" : @"GeofenceGigigo"};
    
    ORCTriggerGeofence *geofence = [[ORCTriggerGeofence alloc] init];
    geofence.type = ORCTypeGeofence;
    geofence.identifier = @"GeofenceGigigo";
    geofence.currentDistance = @10;
    geofence.currentEvent = ORCTypeEventExit;
    
    [self.validatorInterator validateProximityWithGeofence:geofence completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([valitateValues[@"type"] isEqualToString:formattedValues[@"type"]]);
    XCTAssert([valitateValues[@"value"] isEqualToString:formattedValues[@"value"]]);
}


@end
