//
//  ORCRegionTests.m
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ORCRegion.h"

@interface ORCRegionTests : XCTestCase

@property (strong, nonatomic) NSBundle *testBundle;

@end

@implementation ORCRegionTests

- (void)setUp
{
    [super setUp];
    
    self.testBundle = [NSBundle bundleForClass:self.class];

}

- (void)tearDown
{
    [super tearDown];
    
    self.testBundle = nil;
}

- (void)test_init_region_with_json
{
    NSString *path = [self.testBundle pathForResource:@"region_beacon" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    ORCRegion *region = [[ORCRegion alloc] initWithJSON:json];
    
    XCTAssertNotNil(region);
    XCTAssert([region.code isEqualToString:@"56b9c4923570a199728b4597"]);
    XCTAssertTrue(region.notifyOnEntry);
    XCTAssertTrue(region.notifyOnExit);
}

- (void)test_init_region_with_region
{
    ORCRegion *region = [[ORCRegion alloc] init];
    region.identifier = @"identifier";
    region.code = @"code";
    region.currentEvent = ORCTypeEventEnter;
    region.type = @"beacon_region";
    
    ORCRegion *regionFromRegion = [[ORCRegion alloc] initWithRegion:region];
    
    XCTAssertNotNil(regionFromRegion);
    XCTAssert([regionFromRegion.type isEqualToString:@"beacon_region"]);
    XCTAssert([regionFromRegion.code isEqualToString:@"code"]);
    XCTAssertTrue([regionFromRegion.identifier isEqualToString:@"identifier"]);
    XCTAssertTrue(regionFromRegion.currentEvent == ORCTypeEventEnter);
}

- (void)test_init_region_withRegionNil
{
    ORCRegion *region = [[ORCRegion alloc] init];

    ORCRegion *regionFromRegion = [[ORCRegion alloc] initWithRegion:region];
    
    XCTAssertNotNil(regionFromRegion);
    XCTAssert([regionFromRegion.type isEqualToString:@"beacon_region"]);
    XCTAssert([regionFromRegion.code isEqualToString:@""]);
    XCTAssertTrue([regionFromRegion.identifier isEqualToString:@""]);
    XCTAssertTrue(regionFromRegion.currentEvent == ORCTypeEventNone);
}

@end
