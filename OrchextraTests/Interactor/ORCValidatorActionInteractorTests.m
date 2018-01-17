//
//  ORCValidatorActionInteractorTests.m
//  Orchestra
//
//  Created by Judith Medina on 7/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

#import "OrchextraTests-Swift.h"

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCActionCommunicator.h"
#import "ORCValidatorActionInterator.h"
#import "ORCRegion.h"
#import "ORCBeacon.h"
#import "ORCGeofence.h"
#import "ORCProximityFormatter.h"

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

- (void)test_validateProximityWithRegion_returnTypeGeofenceAndValueCode_whereRegionGeofenceType
{
    ORCRegion *region = [[ORCRegion alloc] init];
    region.type = ORCTypeGeofence;
    region.code = @"808d1108c9913b284f045059fb6e77d7";
    region.currentEvent = 1;
    
    [self.validatorInterator validateProximityWithRegion:region completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeGeofence]);
    XCTAssert([formattedValues[@"value"] isEqualToString:@"808d1108c9913b284f045059fb6e77d7"]);
    XCTAssert([formattedValues[@"event"] isEqualToString:@"enter"]);
    XCTAssertNil(formattedValues[@"distance"]);
    
}

- (void)test_validateProximityWithRegion_returnTypeBeaconRegionAndValueCode_whereIsBeaconRegion
{
    ORCRegion *region = [[ORCRegion alloc] init];
    region.type = ORCTypeBeacon;
    region.code = @"808d1108c9913b284f045059fb6e77d7";
    region.currentEvent = 1;
    
    [self.validatorInterator validateProximityWithRegion:region completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeRegion]);
    XCTAssert([formattedValues[@"value"] isEqualToString:@"808d1108c9913b284f045059fb6e77d7"]);
    XCTAssert([formattedValues[@"event"] isEqualToString:@"enter"]);
    XCTAssertNil(formattedValues[@"distance"]);
    
}

- (void)test_validate_beacon_with_md5
{
    NSString *md5Code = @"808d1108c9913b284f045059fb6e77d7";
    
    ORCBeacon *beacon = [[ORCBeacon alloc] init];
    beacon.type = ORCTypeBeacon;
    beacon.identifier = @"BeaconIdentifier";
    beacon.uuid = [[NSUUID alloc] initWithUUIDString:@"B02D9B98-613D-4E22-ACAB-C962C91B05D2"];
    beacon.major = @1;
    beacon.minor = @2;
    beacon.currentProximity = CLProximityFar;
    beacon.currentEvent = ORCTypeEventEnter;
    
    [self.validatorInterator validateProximityWithBeacon:beacon completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeBeacon]);
    XCTAssert([formattedValues[@"value"] isEqualToString:md5Code]);
    XCTAssert([formattedValues[@"distance"] isEqualToString:@"far"]);
    XCTAssertNil(formattedValues[@"event"]);
}

- (void)test_validateProximityWithBeacon_returnProximityFar_whereIsBeaconisFar
{
    ORCBeacon *beacon = [[ORCBeacon alloc] init];
    beacon.type = ORCTypeBeacon;
    beacon.identifier = @"BeaconIdentifier";
    beacon.uuid = [[NSUUID alloc] initWithUUIDString:@"B02D9B98-613D-4E22-ACAB-C962C91B05D2"];
    beacon.major = @1;
    beacon.minor = @2;
    beacon.currentProximity = CLProximityFar;
    
    [self.validatorInterator validateProximityWithBeacon:beacon completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeBeacon]);
    XCTAssert([formattedValues[@"distance"] isEqualToString:@"far"]);
}

- (void)test_validateProximityWithBeacon_returnProximityNear_whereIsBeaconisNear
{
    ORCBeacon *beacon = [[ORCBeacon alloc] init];
    beacon.type = ORCTypeBeacon;
    beacon.identifier = @"BeaconIdentifier";
    beacon.uuid = [[NSUUID alloc] initWithUUIDString:@"B02D9B98-613D-4E22-ACAB-C962C91B05D2"];
    beacon.major = @1;
    beacon.minor = @2;
    beacon.currentProximity = CLProximityNear;
    
    [self.validatorInterator validateProximityWithBeacon:beacon completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeBeacon]);
    XCTAssert([formattedValues[@"distance"] isEqualToString:@"near"]);
}

- (void)test_validateProximityWithBeacon_returnProximityImmediate_whereIsBeaconisImmediate
{
    ORCBeacon *beacon = [[ORCBeacon alloc] init];
    beacon.type = ORCTypeBeacon;
    beacon.identifier = @"BeaconIdentifier";
    beacon.uuid = [[NSUUID alloc] initWithUUIDString:@"B02D9B98-613D-4E22-ACAB-C962C91B05D2"];
    beacon.major = @1;
    beacon.minor = @2;
    beacon.currentProximity = CLProximityImmediate;
    
    [self.validatorInterator validateProximityWithBeacon:beacon completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeBeacon]);
    XCTAssert([formattedValues[@"distance"] isEqualToString:@"immediate"]);
}

- (void)testValidateProximityWithEddystoneRegion_whereEventIsEnter
{
    ORCEddystoneUID *uid = [[ORCEddystoneUID alloc] initWithNamespace:@"636f6b65634063656575"instance:nil];
    
    ORCEddystoneRegion *region = [[ORCEddystoneRegion alloc] initWithUid:uid
                                                                    code:@"59631d973570a131308b4570"
                                                           notifyOnEntry:YES
                                                            notifyOnExit: NO];
    region.regionEvent = regionEventEnter;
    
    [self.validatorInterator validateProximityWithEddystoneRegion: region
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    NSString *eventToString = formattedValues[@"event"];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneRegion]);
    XCTAssertTrue([eventToString isEqualToString:@"enter"]);
    XCTAssertFalse([eventToString isEqualToString:@"exit"]);
    XCTAssertFalse([eventToString isEqualToString:@"stay"]);
    XCTAssertFalse([eventToString isEqualToString:@"undetected"]);
}

- (void)testValidateProximityWithEddystoneRegion_whereEventIsExit
{
    ORCEddystoneUID *uid = [[ORCEddystoneUID alloc] initWithNamespace:@"636f6b65634063656575"instance:nil];
    
    ORCEddystoneRegion *region = [[ORCEddystoneRegion alloc] initWithUid:uid
                                                                    code:@"59631d973570a131308b4570"
                                                           notifyOnEntry:NO
                                                            notifyOnExit: YES];
    region.regionEvent = regionEventExit;
    
    [self.validatorInterator validateProximityWithEddystoneRegion: region
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    NSString *eventToString = formattedValues[@"event"];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneRegion]);
    XCTAssertTrue([eventToString isEqualToString:@"exit"]);
    XCTAssertFalse([eventToString isEqualToString:@"enter"]);
    XCTAssertFalse([eventToString isEqualToString:@"stay"]);
    XCTAssertFalse([eventToString isEqualToString:@"undetected"]);
}

- (void)testValidateProximityWithEddystoneRegion_whereEventIsStay
{
    ORCEddystoneUID *uid = [[ORCEddystoneUID alloc] initWithNamespace:@"636f6b65634063656575"instance:nil];
    
    ORCEddystoneRegion *region = [[ORCEddystoneRegion alloc] initWithUid:uid
                                                                    code:@"59631d973570a131308b4570"
                                                           notifyOnEntry:NO
                                                            notifyOnExit: YES];
    region.regionEvent = regionEventStay;
    
    [self.validatorInterator validateProximityWithEddystoneRegion: region
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    NSString *eventToString = formattedValues[@"event"];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneRegion]);
    XCTAssertTrue([eventToString isEqualToString:@"stay"]);
    XCTAssertFalse([eventToString isEqualToString:@"enter"]);
    XCTAssertFalse([eventToString isEqualToString:@"exit"]);
    XCTAssertFalse([eventToString isEqualToString:@"undetected"]);
}

- (void)testValidateProximityWithEddystoneRegion_whereEventIsUndetected
{
    ORCEddystoneUID *uid = [[ORCEddystoneUID alloc] initWithNamespace:@"636f6b65634063656575"instance:nil];
    
    ORCEddystoneRegion *region = [[ORCEddystoneRegion alloc] initWithUid:uid
                                                                    code:@"59631d973570a131308b4570"
                                                           notifyOnEntry:NO
                                                            notifyOnExit: YES];
    region.regionEvent = regionEventUndetected;
    
    [self.validatorInterator validateProximityWithEddystoneRegion: region
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    NSString *eventToString = formattedValues[@"event"];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneRegion]);
    XCTAssertTrue([eventToString isEqualToString:@"undetected"]);
    XCTAssertFalse([eventToString isEqualToString:@"enter"]);
    XCTAssertFalse([eventToString isEqualToString:@"exit"]);
    XCTAssertFalse([eventToString isEqualToString:@"stay"]);
}

- (void)testValidateProximityWithEddystoneRegion_withoutRegionEvent
{
    ORCEddystoneUID *uid = [[ORCEddystoneUID alloc] initWithNamespace:@"636f6b65634063656575"instance:nil];
    
    ORCEddystoneRegion *region = [[ORCEddystoneRegion alloc] initWithUid:uid
                                                                    code:@"59631d973570a131308b4570"
                                                           notifyOnEntry:NO
                                                            notifyOnExit: YES];
    
    [self.validatorInterator validateProximityWithEddystoneRegion: region
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    NSString *eventToString = formattedValues[@"event"];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneRegion]);
    XCTAssertTrue([eventToString isEqualToString:@"undetected"]);
    XCTAssertFalse([eventToString isEqualToString:@"enter"]);
    XCTAssertFalse([eventToString isEqualToString:@"exit"]);
    XCTAssertFalse([eventToString isEqualToString:@"stay"]);
}

- (void)testValidateProximityWithEddystoneBeacon_withInmediateEvent
{
    ORCEddystoneBeacon *beacon = [self eddystoneBeacon];
    [beacon updateRssiBufferWithRssi:-41];
    
    [self.validatorInterator validateProximityWithEddystoneBeacon:beacon
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneBeacon]);
    XCTAssertTrue([formattedValues[@"distance"] isEqualToString:@"immediate"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"near"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"far"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"unknown"]);
    XCTAssertTrue([formattedValues[@"namespace"] isEqualToString:@"636f6b65634063656575"]);
    XCTAssertTrue([formattedValues[@"instance"] isEqualToString:@"100000303976"]);
    XCTAssertTrue([formattedValues[@"phoneStatus"] isEqualToString:@"foreground"]);
    XCTAssertTrue([formattedValues[@"temperature"] isEqualToNumber:[NSNumber numberWithDouble:28.1875]]);
    XCTAssertTrue([formattedValues[@"url"] isEqualToString:@"www.gigigo.com"]);
    XCTAssertTrue([formattedValues[@"value"] isEqualToString:@"636f6b65634063656575100000303976"]);
}

- (void)testValidateProximityWithEddystoneBeacon_withNearEvent
{
    ORCEddystoneBeacon *beacon = [self eddystoneBeacon];
    [beacon updateRssiBufferWithRssi:-75];
    
    [self.validatorInterator validateProximityWithEddystoneBeacon:beacon
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneBeacon]);
    XCTAssertTrue([formattedValues[@"distance"] isEqualToString:@"near"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"immdieate"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"far"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"unknown"]);
    XCTAssertTrue([formattedValues[@"namespace"] isEqualToString:@"636f6b65634063656575"]);
    XCTAssertTrue([formattedValues[@"instance"] isEqualToString:@"100000303976"]);
    XCTAssertTrue([formattedValues[@"phoneStatus"] isEqualToString:@"foreground"]);
    XCTAssertTrue([formattedValues[@"temperature"] isEqualToNumber:[NSNumber numberWithDouble:28.1875]]);
    XCTAssertTrue([formattedValues[@"url"] isEqualToString:@"www.gigigo.com"]);
    XCTAssertTrue([formattedValues[@"value"] isEqualToString:@"636f6b65634063656575100000303976"]);
    
}

- (void)testValidateProximityWithEddystoneBeacon_withFarEvent
{
    ORCEddystoneBeacon *beacon = [self eddystoneBeacon];
    [beacon updateRssiBufferWithRssi:-88];

    [self.validatorInterator validateProximityWithEddystoneBeacon:beacon
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneBeacon]);
    XCTAssertTrue([formattedValues[@"distance"] isEqualToString:@"far"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"immediate"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"near"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"unknown"]);
    XCTAssertTrue([formattedValues[@"namespace"] isEqualToString:@"636f6b65634063656575"]);
    XCTAssertTrue([formattedValues[@"instance"] isEqualToString:@"100000303976"]);
    XCTAssertTrue([formattedValues[@"phoneStatus"] isEqualToString:@"foreground"]);
    XCTAssertTrue([formattedValues[@"temperature"] isEqualToNumber:[NSNumber numberWithDouble:28.1875]]);
    XCTAssertTrue([formattedValues[@"url"] isEqualToString:@"www.gigigo.com"]);
    XCTAssertTrue([formattedValues[@"value"] isEqualToString:@"636f6b65634063656575100000303976"]);
}

- (void)testValidateProximityWithEddystoneBeacon_withoutProximityEvent
{
    ORCEddystoneBeacon *beacon = [self eddystoneBeacon];
    
    [self.validatorInterator validateProximityWithEddystoneBeacon:beacon
                                                       completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssertTrue([formattedValues[@"type"] isEqualToString:ORCTypeEddystoneBeacon]);
    XCTAssertTrue([formattedValues[@"distance"] isEqualToString:@"unknown"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"immediate"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"near"]);
    XCTAssertFalse([formattedValues[@"distance"] isEqualToString:@"far"]);
    XCTAssertTrue([formattedValues[@"namespace"] isEqualToString:@"636f6b65634063656575"]);
    XCTAssertTrue([formattedValues[@"instance"] isEqualToString:@"100000303976"]);
    XCTAssertTrue([formattedValues[@"phoneStatus"] isEqualToString:@"foreground"]);
    XCTAssertTrue([formattedValues[@"temperature"] isEqualToNumber:[NSNumber numberWithDouble:28.1875]]);
    XCTAssertTrue([formattedValues[@"url"] isEqualToString:@"www.gigigo.com"]);
    XCTAssertTrue([formattedValues[@"value"] isEqualToString:@"636f6b65634063656575100000303976"]);
}


- (void)test_validate_geofences
{
    NSDictionary *valitateValues = @{@"type" : ORCTypeGeofence, @"value" : @"GeofenceGigigo"};
    
    ORCGeofence *geofence = [[ORCGeofence alloc] init];
    geofence.type = ORCTypeGeofence;
    geofence.code = @"GeofenceGigigo";
    geofence.currentDistance = @10;
    geofence.currentEvent = ORCTypeEventExit;
    
    [self.validatorInterator validateProximityWithGeofence:geofence completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([valitateValues[@"type"] isEqualToString:formattedValues[@"type"]]);
    XCTAssert([valitateValues[@"value"] isEqualToString:formattedValues[@"value"]]);
}

- (void)test_validateGeofence_WhenGeofenceNil
{
    ORCGeofence *geofence = [[ORCGeofence alloc] init];
    
    [self.validatorInterator validateProximityWithGeofence:geofence completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeGeofence]);
    XCTAssert([formattedValues[@"value"] isEqualToString:@""]);
    XCTAssert([formattedValues[@"event"] isEqualToString:@"none"]);
    XCTAssert([formattedValues[@"distance"] isEqual:@0]);
}

- (void)test_validateRegion_WhenRegionNil
{
    ORCRegion *region = [[ORCRegion alloc] init];
    
    [self.validatorInterator validateProximityWithRegion:region completion:nil];
    
    MKTArgumentCaptor *captorAction = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.communicatorMock) loadActionWithTriggerValues:[captorAction capture] completion:HC_notNilValue()];
    NSDictionary *formattedValues = [captorAction value];
    
    XCTAssert([formattedValues[@"type"] isEqualToString:ORCTypeRegion]);
    XCTAssert([formattedValues[@"value"] isEqualToString:@""]);
    XCTAssert([formattedValues[@"event"] isEqualToString:@"none"]);
}

- (void)test_validateResponse_withActionAndErrorNil_andRequetParams
{
    ORCURLActionResponse *response = [[ORCURLActionResponse alloc] init];
    response.action = nil;
    response.error = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"validateResponse"];
    [self.validatorInterator validateResponse:response requestParams:@{} completion:^(ORCAction *action, NSError *error) {
        XCTAssertNil(action);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)test_validateResponse_withNilResponse_withRequetParams
{
    ORCURLActionResponse *response = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"validateResponse"];
    [self.validatorInterator validateResponse:response requestParams:@{} completion:^(ORCAction *action, NSError *error) {
        XCTAssertNil(action);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)test_validateResponse_withAction_andNilRequetParams
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"GET_action_vuforia_without_schedule_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    ORCURLActionResponse *response = [[ORCURLActionResponse alloc] initWithData:data];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"validateResponse"];
    [self.validatorInterator validateResponse:response requestParams:@{} completion:^(ORCAction *action, NSError *error) {
        XCTAssertNotNil(action);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)test_validateResponse_withNilAction_andNilRequetParams
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"GET_action_datanil" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    ORCURLActionResponse *response = [[ORCURLActionResponse alloc] initWithData:data];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"validateResponse"];
    [self.validatorInterator validateResponse:response requestParams:nil completion:^(ORCAction *action, NSError *error) {
        XCTAssertNil(action);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

#pragma mark - Utilities

- (ORCEddystoneBeacon *)eddystoneBeacon
{
    ORCEddystoneUID *uid = [[ORCEddystoneUID alloc] initWithNamespace:@"636f6b65634063656575"
                                                             instance:@"100000303976"];
    NSUUID *peripheralId = [[NSUUID alloc] initWithUUIDString:@"4B9F9513-2877-77B1-5B9F-A198CCF814DF"];
    NSURL *url = [NSURL URLWithString:@"www.gigigo.com"];
    
    ORCEddystoneTelemetry *telemetry = [[ORCEddystoneTelemetry alloc] initWithTlmVersion:@"0"
                                                                          batteryVoltage:3632
                                                                       batteryPercentage:100
                                                                             temperature:28.1875
                                                                     advertisingPDUcount: @"175795000"
                                                                                  uptime:123456];
    
    ORCEddystoneBeacon *beacon = [[ORCEddystoneBeacon alloc] initWithPeripheralId:peripheralId
                                                                  requestWaitTime:120];
    beacon.uid = uid;
    beacon.url = url;
    beacon.telemetry = telemetry;
    
    return beacon;
}

@end
