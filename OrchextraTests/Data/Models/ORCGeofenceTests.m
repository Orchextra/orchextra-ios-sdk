//
//  ORCGeofenceTests.m
//  Orchextra
//
//  Created by Judith Medina on 11/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ORCGeofence.h"

@interface ORCGeofenceTests : XCTestCase

@property (strong, nonatomic) NSBundle *testBundle;

@end

@implementation ORCGeofenceTests

- (void)setUp
{
    [super setUp];
    
    self.testBundle = [NSBundle bundleForClass:self.class];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_init_geofence_with_minor_nil
{
    //Prepare
    NSDictionary *json = [self jsonGeofence];
    
    //Execute
    ORCGeofence *geofence = [[ORCGeofence alloc] initWithJSON:json];
    
    //Verify
    XCTAssertNotNil(geofence);
    
    XCTAssert([geofence.code isEqualToString:@"569cd134bbafcd9b608b4598"]);
    XCTAssert([geofence.name isEqualToString:@"Gigigo"]);
    XCTAssert([geofence.longitude isEqualToString:@"-3.627889"]);
    XCTAssert([geofence.latitude isEqualToString:@"40.44583"]);
    XCTAssert([geofence.radius isEqualToNumber:@200]);

    XCTAssertTrue(geofence.notifyOnEntry);
    XCTAssertTrue(geofence.notifyOnExit);
}

- (void)test_initGeofence_withGeofence
{
    ORCGeofence *geofence = [[ORCGeofence alloc] init];
    geofence.code = @"code";
    geofence.identifier = @"identifier";
    geofence.currentEvent = 2;
    geofence.currentDistance = @0;
    geofence.longitude = @"100";
    geofence.latitude = @"100";
    geofence.radius = @0;
    
    ORCGeofence *geofenceFromGeofence = [[ORCGeofence alloc] initWithGeofence:geofence];
    
    XCTAssert([geofenceFromGeofence.type isEqualToString:@"geofence"]);
    XCTAssert([geofenceFromGeofence.code isEqualToString:@"code"]);
    XCTAssert([geofenceFromGeofence.identifier isEqualToString:@"identifier"]);
    XCTAssert(geofenceFromGeofence.currentEvent == 2);
    XCTAssert([geofenceFromGeofence.currentDistance isEqual:@0]);
    XCTAssert([geofenceFromGeofence.longitude isEqual:@"100"]);
    XCTAssert([geofenceFromGeofence.latitude isEqual:@"100"]);
    XCTAssert([geofenceFromGeofence.radius isEqual:@0]);
}

- (void)test_initGeofence_withGeofenceNil
{
    ORCGeofence *geofence = [[ORCGeofence alloc] init];
    ORCGeofence *geofenceFromGeofence = [[ORCGeofence alloc] initWithGeofence:geofence];
    
    XCTAssert([geofenceFromGeofence.type isEqualToString:@"geofence"]);
    XCTAssert([geofenceFromGeofence.code isEqualToString:@""]);
    XCTAssert([geofenceFromGeofence.identifier isEqualToString:@""]);
    XCTAssert(geofenceFromGeofence.currentEvent == 0);
    XCTAssert([geofenceFromGeofence.currentDistance isEqual:@0]);
    XCTAssert([geofenceFromGeofence.longitude isEqual:@"0"]);
    XCTAssert([geofenceFromGeofence.latitude isEqual:@"0"]);
    XCTAssert([geofenceFromGeofence.radius isEqual:@0]);
}

- (void)test_convert_to_cl_region
{
    //Prepare
    NSDictionary *json = [self jsonGeofence];
    
    //Execute
    ORCGeofence *geofence = [[ORCGeofence alloc] initWithJSON:json];
    CLRegion *region = [geofence convertToCLRegion];
    
    //Verify
    XCTAssertNotNil(region);
    XCTAssertTrue([region.identifier isEqualToString:geofence.code]);
}

#pragma mark - Helper

-(NSDictionary *)jsonGeofence
{
    NSString *path = [self.testBundle pathForResource:@"region_geofence" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    return json;
}

@end
