//
//  ORCDeviceStorageTests.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ORCFormatterParameters.h"
#import "ORCLocationStorage.h"

@interface ORCFormatterParametersTests : XCTestCase

@property (strong, nonatomic) ORCFormatterParameters *formatter;
@property (strong, nonatomic) ORCLocationStorage *locationStorage;

@end

@implementation ORCFormatterParametersTests

- (void)setUp
{
    [super setUp];
    
    self.formatter = [[ORCFormatterParameters alloc] init];
    self.locationStorage = [[ORCLocationStorage alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    
    self.formatter = nil;
    self.locationStorage = nil;
}

- (void)test_formatter_parameters_device
{
    NSDictionary *dictionary = [self.formatter formatterParameteresDevice];
   
    XCTAssertNotNil(dictionary);
    XCTAssertTrue(dictionary[@"device"]);
}

- (void)test_formatter_user_location
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.415055 longitude:-3.685271];
    
    NSDictionary *dictionary = [self.formatter formattedUserLocation:location];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *point = dictionary[@"point"];
    XCTAssertNotNil(point);

    XCTAssertTrue([point[@"lat"] isEqualToNumber:[NSNumber numberWithDouble:40.415055]]);
    XCTAssertTrue([point[@"lng"] isEqualToNumber:[NSNumber numberWithDouble:-3.685271]]);
}


@end
