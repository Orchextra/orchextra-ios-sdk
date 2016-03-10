//
//  ORCBeaconTests.m
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ORCBeacon.h"
#import "CLLocationManagerMock.h"

@interface ORCBeaconTests : XCTestCase

@property (strong, nonatomic) CLLocationManagerMock *locationManagerMock;
@property (strong, nonatomic) NSBundle *testBundle;
@property (strong, nonatomic) NSUUID *uuid;

@end

@implementation ORCBeaconTests

- (void)setUp
{
    [super setUp];
    
    self.locationManagerMock = [[CLLocationManagerMock alloc] init];
    self.uuid = [[NSUUID alloc] initWithUUIDString:@"B02D9B98-613D-4E22-ACAB-C962C91B05D2"];
    self.testBundle = [NSBundle bundleForClass:self.class];
}

- (void)tearDown
{
    [super tearDown];
    
    self.uuid = nil;
    self.testBundle = nil;
}

- (void)test_init_beacon_with_minor_nil
{
    NSString *path = [self.testBundle pathForResource:@"region_beacon" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    ORCBeacon *beacon = [[ORCBeacon alloc] initWithJSON:json];
    
    XCTAssertNotNil(beacon);
    XCTAssert([beacon.code isEqualToString:@"56b9c4923570a199728b4597"]);
    XCTAssert([beacon.uuid isEqual:[[NSUUID alloc] initWithUUIDString:@"B02D9B98-613D-4E22-ACAB-C962C91B05D2"]]);
    XCTAssert([beacon.major shortValue] == 2);
    XCTAssertNil(beacon.minor);

    XCTAssertTrue(beacon.notifyOnEntry);
    XCTAssertTrue(beacon.notifyOnExit);
}

- (void)test_init_beacon_with_major_and_minor_nil
{
    NSString *path = [self.testBundle pathForResource:@"region_beacon_major_minor_nil" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    ORCBeacon *beacon = [[ORCBeacon alloc] initWithJSON:json];
    
    XCTAssertNotNil(beacon);
    XCTAssert([beacon.code isEqualToString:@"56b9c4923570a199728b4597"]);
    XCTAssert([beacon.uuid isEqual:[[NSUUID alloc] initWithUUIDString:@"B02D9B98-613D-4E22-ACAB-C962C91B05D2"]]);
    XCTAssertNil(beacon.major);
    XCTAssertNil(beacon.minor);
    
    XCTAssertTrue(beacon.notifyOnEntry);
    XCTAssertTrue(beacon.notifyOnExit);
}

- (void)test_convert_to_system_region
{
    //Prepare
    ORCBeacon *beacon = [[ORCBeacon alloc] initWithUUID:self.uuid major:@6 minor:@6];
    beacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    CLRegion *region = [beacon convertToCLRegion];
    
    //Verify
    XCTAssertNotNil(region);
    XCTAssertTrue([region.identifier isEqualToString:beacon.code]);
}

- (void)test_orchextra_beacon_is_equal_to_CLBeacon
{
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc] initWithUUID:self.uuid major:@6 minor:@6];
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    CLBeaconRegion *beacon = [[CLBeaconRegion alloc]
                              initWithProximityUUID:self.uuid
                              major:6
                              minor:6
                              identifier:@"56b9c4923570a199728b4597"];
    
    XCTAssertTrue([orchextraBeacon isEqualToCLBeacon:(CLBeacon*)beacon]);
}

- (void)test_beacon_proximity_immediate
{
    //Prepare
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc]
                                  initWithUUID:self.uuid
                                  major:@6 minor:@6];
    
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    BOOL canUseImmediate = [orchextraBeacon setNewProximity:CLProximityImmediate];
    
    XCTAssertTrue(canUseImmediate);
}

- (void)test_beacon_proximity_immediate_without_waiting_requestTime
{
    //Prepare
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc]
                                  initWithUUID:self.uuid
                                  major:@6 minor:@6];
    
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    BOOL canUseImmediate = [orchextraBeacon setNewProximity:CLProximityImmediate];
    XCTAssertTrue(canUseImmediate);
    
    BOOL canUseImmediateAgain = [orchextraBeacon setNewProximity:CLProximityImmediate];
    XCTAssertFalse(canUseImmediateAgain);
}

- (void)test_beacon_proximity_near
{
    //Prepare
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc]
                                  initWithUUID:self.uuid
                                  major:@6 minor:@6];
    
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    BOOL canUseNear = [orchextraBeacon setNewProximity:CLProximityNear];
    
    XCTAssertTrue(canUseNear);
}

- (void)test_beacon_proximity_near_without_waiting_requestTime
{
    //Prepare
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc]
                                  initWithUUID:self.uuid
                                  major:@6 minor:@6];
    
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    BOOL canUseNear = [orchextraBeacon setNewProximity:CLProximityNear];
    XCTAssertTrue(canUseNear);
    
    BOOL canUseNearAgain = [orchextraBeacon setNewProximity:CLProximityNear];
    XCTAssertFalse(canUseNearAgain);
}

- (void)test_beacon_proximity_far
{
    //Prepare
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc]
                                  initWithUUID:self.uuid
                                  major:@6 minor:@6];
    
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    BOOL canUseFar = [orchextraBeacon setNewProximity:CLProximityFar];
    
    XCTAssertTrue(canUseFar);
}

- (void)test_beacon_proximity_far_without_waiting_requestTime
{
    //Prepare
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc]
                                  initWithUUID:self.uuid
                                  major:@6 minor:@6];
    
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    BOOL canUseFar = [orchextraBeacon setNewProximity:CLProximityFar];
    XCTAssertTrue(canUseFar);
    
    BOOL canUseFarAgain = [orchextraBeacon setNewProximity:CLProximityFar];
    XCTAssertFalse(canUseFarAgain);
}

- (void)test_beacon_proximity_immediate_near_far
{
    //Prepare
    ORCBeacon *orchextraBeacon = [[ORCBeacon alloc]
                                  initWithUUID:self.uuid
                                  major:@6 minor:@6];
    
    orchextraBeacon.code = @"56b9c4923570a199728b4597";
    
    //Execute
    BOOL canUseImmediate = [orchextraBeacon setNewProximity:CLProximityImmediate];
    XCTAssertTrue(canUseImmediate);
    
    BOOL canUseNear = [orchextraBeacon setNewProximity:CLProximityNear];
    XCTAssertTrue(canUseNear);
    
    BOOL canUseFar = [orchextraBeacon setNewProximity:CLProximityFar];
    XCTAssertTrue(canUseFar);
}


@end
