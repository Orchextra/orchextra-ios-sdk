//
//  GIGURLCommunicatorMultiRequestFixtureTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 30/09/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGTests.h"

#import "GIGURLManager.h"
#import "GIGURLRequestFactory.h"
#import "GIGURLCommunicator.h"


@interface GIGURLCommunicatorMultiRequestFixtureTests : XCTestCase

@property (strong, nonatomic) GIGURLManager *managerMock;
@property (strong, nonatomic) NSData *fixtureData1;
@property (strong, nonatomic) NSData *fixtureData2;
@property (strong, nonatomic) GIGURLRequest *request1;
@property (strong, nonatomic) GIGURLRequest *request2;
@property (strong, nonatomic) GIGURLRequestFactory *requestFactoryMock;

@property (strong, nonatomic) GIGURLCommunicator *communicator;

@end

@implementation GIGURLCommunicatorMultiRequestFixtureTests

- (void)setUp
{
    [super setUp];
    
    self.managerMock = MKTMock([GIGURLManager class]);
    [MKTGiven([self.managerMock useFixture]) willReturnBool:YES];
    
    self.fixtureData1 = [@"fixture_data_1" dataUsingEncoding:NSUTF8StringEncoding];
    self.fixtureData2 = [@"fixture_data_2" dataUsingEncoding:NSUTF8StringEncoding];
    
    self.request1 = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url1" sessionFactory:nil requestFactory:nil logger:nil manager:self.managerMock];
    self.request1.requestTag = @"request1";
    
    self.request2 = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url2" sessionFactory:nil requestFactory:nil logger:nil manager:self.managerMock];
    self.request2.requestTag = @"request2";
    
    [MKTGiven([self.managerMock requestShouldUseMock:self.request1]) willReturnBool:YES];
    [MKTGiven([self.managerMock mockForRequest:self.request1]) willReturn:self.fixtureData1];
    [MKTGiven([self.managerMock requestShouldUseMock:self.request2]) willReturnBool:YES];
    [MKTGiven([self.managerMock mockForRequest:self.request2]) willReturn:self.fixtureData2];
    
    self.requestFactoryMock = MKTMock([GIGURLRequestFactory class]);
    [MKTGiven([self.requestFactoryMock requestWithMethod:@"GET" url:@"http://url1"]) willReturn:self.request1];
    [MKTGiven([self.requestFactoryMock requestWithMethod:@"GET" url:@"http://url2"]) willReturn:self.request2];
    
    self.communicator = [[GIGURLCommunicator alloc] initWithManager:self.managerMock requestFactory:self.requestFactoryMock];
}

- (void)tearDown
{
    self.managerMock = nil;
    self.request1 = nil;
    self.request2 = nil;
    self.requestFactoryMock = nil;
    
    self.communicator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_Multirequest_with_fixture_success
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"All requests have finished"];
    NSDictionary *requests = @{@"request1": self.request1, @"request2": self.request2};
    
    [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
        XCTAssert([NSThread isMainThread]);
        [expectation fulfill];
        
        XCTAssert(responses != nil);
        GIGURLResponse *response1 = responses[@"request1"];
        XCTAssert(response1 != nil);
        XCTAssert(response1.success == YES);
        XCTAssert(response1.error == nil);
        XCTAssert([response1.data isEqualToData:self.fixtureData1]);
        
        GIGURLResponse *response2 = responses[@"request2"];
        XCTAssert(response2 != nil);
        XCTAssert(response2.success == YES);
        XCTAssert(response2.error == nil);
        XCTAssert([response2.data isEqualToData:self.fixtureData2]);
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {}];
}

- (void)test_Multirequest_with_fixture_fail
{
    [MKTGiven([self.managerMock mockForRequest:self.request1]) willReturn:nil];
    [MKTGiven([self.managerMock mockForRequest:self.request2]) willReturn:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"All requests have finished"];
    NSDictionary *requests = @{@"request1": self.request1, @"request2": self.request2};
    
    [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
        XCTAssert([NSThread isMainThread]);
        [expectation fulfill];
        
        XCTAssert(responses != nil);
        GIGURLResponse *response1 = responses[@"request1"];
        XCTAssert(response1 != nil);
        XCTAssert(response1.success == NO);
        XCTAssert(response1.error != nil);
        XCTAssert(response1.error.code == 404);
        
        GIGURLResponse *response2 = responses[@"request2"];
        XCTAssert(response2 != nil);
        XCTAssert(response2.success == NO);
        XCTAssert(response2.error != nil);
        XCTAssert(response2.error.code == 404);
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {}];
}

- (void)test_Multirequest_with_fixture_one_request_fail
{
    [MKTGiven([self.managerMock mockForRequest:self.request2]) willReturn:nil];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"All requests have finished"];
    NSDictionary *requests = @{@"request1": self.request1, @"request2": self.request2};
    
    [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
        XCTAssert([NSThread isMainThread]);
        [expectation fulfill];
        
        XCTAssert(responses != nil);
        GIGURLResponse *response1 = responses[@"request1"];
        XCTAssert(response1 != nil);
        XCTAssert(response1.success == YES);
        XCTAssert(response1.error == nil);
        XCTAssert([response1.data isEqualToData:self.fixtureData1]);
        
        GIGURLResponse *response2 = responses[@"request2"];
        XCTAssert(response2 != nil);
        XCTAssert(response2.success == NO);
        XCTAssert(response2.error != nil);
        XCTAssert(response2.error.code == 404);
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {}];
}

- (void)test_Multirequest_with_fixture_no_retained_request
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"All requests have finished"];
    
    {
        GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:nil sessionFactory:nil requestFactory:nil logger:nil manager:self.managerMock];
        request.requestTag = @"request";
        
        [MKTGiven([self.managerMock requestShouldUseMock:request]) willReturnBool:YES];
        [MKTGiven([self.managerMock mockForRequest:request]) willReturn:nil];
        
        NSDictionary *requests = @{@"request": request};
        
        [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
            XCTAssert([NSThread isMainThread]);
            [expectation fulfill];
            
            XCTAssert(responses[@"request"] != nil);
        }];
    }
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {}];
}

@end
