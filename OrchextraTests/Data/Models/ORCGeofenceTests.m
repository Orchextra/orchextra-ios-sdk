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

- (void)test_init_beacon_with_minor_nil
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
