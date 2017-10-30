//
//  GIGURLJSONResponseTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGURLJSONResponse.h"
#import "GIGJSON.h"


@interface GIGURLJSONResponseTests : XCTestCase

@end

@implementation GIGURLJSONResponseTests

- (void)test_init_with_nil_data
{
    GIGURLJSONResponse *response = [[GIGURLJSONResponse alloc] initWithData:nil];
    
    XCTAssertFalse(response.success);
    XCTAssertNil(response.data);
    XCTAssertNil(response.json);
}

- (void)test_init_with_invalid_json_data
{
    NSData *data = [@"{\"json\":}" dataUsingEncoding:NSUTF8StringEncoding];
    
    GIGURLJSONResponse *response = [[GIGURLJSONResponse alloc] initWithData:data];
    
    XCTAssertFalse(response.success);
    XCTAssertTrue([response.data isEqualToData:data]);
    XCTAssertNil(response.json);
    XCTAssertNotNil(response.error);
}

- (void)test_init_with_valid_json_data
{
    NSData *data = [@"{\"json\": \"valid_json\"}" dataUsingEncoding:NSUTF8StringEncoding];
    
    GIGURLJSONResponse *response = [[GIGURLJSONResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertNotNil(response.json);
    XCTAssertNil(response.error);
}

- (void)test_init_with_json
{
    id json = [@"{\"json\": \"valid_json\"}" toJSON];
    GIGURLJSONResponse *response = [[GIGURLJSONResponse alloc] initWithJSON:json];
    
    XCTAssertTrue(response.success);
    XCTAssertNotNil(response.data);
    XCTAssertNotNil(response.json);
    XCTAssertTrue([response.json isEqual:json]);
    XCTAssertNil(response.error);
}

- (void)test_init_with_nil_json
{
    GIGURLJSONResponse *response = [[GIGURLJSONResponse alloc] initWithJSON:nil];
    
    XCTAssertFalse(response.success);
    XCTAssertNil(response.data);
    XCTAssertNil(response.json);
}

@end
