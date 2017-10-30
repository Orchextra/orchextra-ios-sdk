//
//  GIGURLRequestThreadsTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 28/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGNetwork.h"


@interface GIGURLRequestThreadsTests : XCTestCase

@end

@implementation GIGURLRequestThreadsTests

#pragma mark - TESTS

- (void)test_block_executes_on_main_thread
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should complete"];
    
    GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://www.gigigo.com" manager:nil];
    
    __block BOOL isMainThread = NO;
    request.completion = ^(GIGURLResponse *response) {
        isMainThread = [NSThread isMainThread];
        
        [expectation fulfill];
    };
    
    [request send];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
    
    XCTAssert(isMainThread);
}

@end
