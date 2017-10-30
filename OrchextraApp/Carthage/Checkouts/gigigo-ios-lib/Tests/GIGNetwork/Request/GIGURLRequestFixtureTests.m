//
//  GIGURLRequestFixtureTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 30/09/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGTests.h"

#import "GIGURLManager.h"
#import "GIGURLRequest.h"


@interface GIGURLRequestFixtureTests : XCTestCase

@property (strong, nonatomic) GIGURLManager *managerMock;
@property (strong, nonatomic) GIGURLRequest *request;

@end

@implementation GIGURLRequestFixtureTests

- (void)setUp
{
    [super setUp];
    
    self.managerMock = MKTMock([GIGURLManager class]);
    [MKTGiven([self.managerMock useFixture]) willReturnBool:YES];
    
    self.request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" sessionFactory:nil requestFactory:nil logger:nil manager:self.managerMock];
    self.request.requestTag = @"request";
    self.request.fixtureDelay = GIGURLRequestFixtureDelayNone;
}

- (void)tearDown
{
    self.managerMock = nil;
    self.request = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_Request_with_fixture_Should_return_404
{
    [MKTGiven([self.managerMock requestShouldUseMock:self.request]) willReturnBool:YES];
    [MKTGiven([self.managerMock mockForRequest:self.request]) willReturn:nil];
    
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    XCTAssert(response != nil);
    XCTAssert(response.success == NO);
    XCTAssert(response.error != nil);
    XCTAssert(response.error.code == 404);
}

- (void)test_Request_with_fixture_Should_return_success
{
    NSData *fixtureData = [@"fixture_data" dataUsingEncoding:NSUTF8StringEncoding];
    
    [MKTGiven([self.managerMock requestShouldUseMock:self.request]) willReturnBool:YES];
    [MKTGiven([self.managerMock mockForRequest:self.request]) willReturn:fixtureData];
    
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    XCTAssert(response != nil);
    XCTAssert(response.success == YES);
    XCTAssert(response.error == nil);
    XCTAssert(response.data != nil);
    XCTAssert([response.data isEqualToData:fixtureData]);
}

@end
