//
//  GIGURLManagerFixturesTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 04/11/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGTests.h"
#import "NSData+GIGExtension.h"

#import "GIGURLManager.h"
#import "GIGURLFixturesKeeper.h"
#import "GIGURLRequest.h"


@interface GIGURLManagerFixturesTests : XCTestCase

@property (strong, nonatomic) GIGURLRequest *request;
@property (strong, nonatomic) GIGURLFixturesKeeper *keeperMock;
@property (strong, nonatomic) NSData *requestMockData;
@property (strong, nonatomic) NSData *fixtureMockData;

@property (strong, nonatomic) GIGURLManager *manager;

@end


@implementation GIGURLManagerFixturesTests

- (void)setUp
{
    [super setUp];
    
    self.keeperMock = MKTMock([GIGURLFixturesKeeper class]);
    self.request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@""];
    self.request.requestTag = @"request";
    self.request.mockFilename = @"mock_filename";
    
    self.requestMockData = [NSData randomData];
    self.fixtureMockData = [NSData randomData];
    
    [MKTGiven([self.keeperMock mockWithFilename:self.request.mockFilename]) willReturn:self.requestMockData];
    [MKTGiven([self.keeperMock mockForRequestTag:self.request.requestTag]) willReturn:self.fixtureMockData];
    
    self.manager = [[GIGURLManager alloc] initWithDomainsKeeper:nil fixturesKeeper:self.keeperMock notificationCenter:nil];
}

#pragma mark - TESTS

- (void)test_Request_should_use_request_mock_before_fixture_mock
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:YES];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:YES];
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == YES);
    XCTAssert([self.manager mockForRequest:self.request] == self.requestMockData);
}

- (void)test_Request_should_use_fixture_mock_if_no_request_mock
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:YES];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:YES];
    self.request.mockFilename = nil;
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == YES);
    XCTAssert([self.manager mockForRequest:self.request] == self.fixtureMockData);
}

- (void)test_Request_should_use_fixture_mock_with_undefined_fixture_mock
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:YES];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:NO];
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == YES);
    XCTAssert([self.manager mockForRequest:self.request] == self.requestMockData);
}

- (void)test_Request_should_use_fixture_mock_but_is_not_defined
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:YES];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:NO];
    self.request.mockFilename = nil;
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == NO);
    XCTAssert([self.manager mockForRequest:self.request] == nil);
}

- (void)test_Request_should_use_request_mock_and_fixtures_disabled
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:NO];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:YES];
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == YES);
    XCTAssert([self.manager mockForRequest:self.request] == self.requestMockData);
}

- (void)test_Request_should_use_no_mock_but_has_fixture_mock
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:NO];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:YES];
    self.request.mockFilename = nil;
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == NO);
    XCTAssert([self.manager mockForRequest:self.request] == nil);
}

- (void)test_Request_should_use_request_mock
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:NO];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:NO];
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == YES);
    XCTAssert([self.manager mockForRequest:self.request] == self.requestMockData);
}

- (void)test_Request_should_use_no_mock
{
    [MKTGiven([self.keeperMock useFixture]) willReturnBool:NO];
    [MKTGiven([self.keeperMock isMockDefinedForRequestTag:self.request.requestTag]) willReturnBool:NO];
    self.request.mockFilename = nil;
    
    XCTAssert([self.manager requestShouldUseMock:self.request] == NO);
    XCTAssert([self.manager mockForRequest:self.request] == nil);
}

@end
