//
//  GIGURLResponseTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGURLResponse.h"


@interface GIGURLResponseTests : XCTestCase

@end

@implementation GIGURLResponseTests

- (void)test_init_with_success
{
    GIGURLResponse *response = [[GIGURLResponse alloc] initWithSuccess:YES];
    
    XCTAssertTrue(response.success);
    XCTAssertNil(response.data);
    XCTAssertNil(response.error);
}

- (void)test_init_with_nil_data
{
    GIGURLResponse *response = [[GIGURLResponse alloc] initWithData:nil];
    
    XCTAssertFalse(response.success);
    XCTAssertNil(response.data);
    XCTAssertNil(response.error);
}

- (void)test_init_with_data
{
    NSData *data = [@"data" dataUsingEncoding:NSUTF8StringEncoding];
    GIGURLResponse *response = [[GIGURLResponse alloc] initWithData:data];
    
    XCTAssertTrue(response.success);
    XCTAssertTrue([response.data isEqualToData:data]);
    XCTAssertNil(response.error);
}

- (void)test_init_with_error
{
    NSError *error = [NSError errorWithDomain:@"test.giglibrary.com" code:1000 userInfo:nil];
    GIGURLResponse *response = [[GIGURLResponse alloc] initWithError:error];
    
    XCTAssertFalse(response.success);
    XCTAssertNil(response.data);
    XCTAssertTrue([response.error isEqual:error]);
}

@end
