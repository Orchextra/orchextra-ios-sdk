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
#import <GIGLibrary/GIGLibrary.h>

#import "ORCActionCommunicator.h"
#import "ORCValidatorActionInterator.h"
#import "ORCRegion.h"
#import "ORCBeacon.h"
#import "ORCGeofence.h"
#import "ORCConstants.h"


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



@end
