//
//  ORCGIGURLJSONResponseTests.m
//  Orchextra
//
//  Created by Judith Medina on 2/9/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ORCGIGURLJSONResponse.h"

@interface ORCGIGURLJSONResponseTests : XCTestCase

@property (strong, nonatomic) NSBundle *testBundle;

@end

@implementation ORCGIGURLJSONResponseTests

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

- (void)test_initURLJSONResponse_withData_returnJSONData
{
    NSString *path = [self.testBundle pathForResource:@"GET_action_vuforia_without_schedule_data" ofType:@"json"];
    XCTAssertNotNil(path);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);
    
    ORCGIGURLJSONResponse *response = [[ORCGIGURLJSONResponse alloc] initWithData:data];
    XCTAssertNotNil(response);
    XCTAssertNotNil(response.json);
    XCTAssertNotNil(response.jsonData);
}

- (void)test_initURLJSONResponse_withNilData
{
    ORCGIGURLJSONResponse *response = [[ORCGIGURLJSONResponse alloc] initWithData:nil];
    XCTAssertNotNil(response);
    
    XCTAssertNil(response.json);
    XCTAssertNil(response.jsonData);
    XCTAssertNotNil(response.error);
    

}



@end
