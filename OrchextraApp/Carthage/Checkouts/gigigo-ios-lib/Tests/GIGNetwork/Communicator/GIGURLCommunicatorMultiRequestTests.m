//
//  GIGURLCommunicatorMultiRequestTests.m
//  giglibrary
//
//  Created by Sergio Baró on 22/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGDispatch.h"
#import "GIGTests.h"

#import "GIGURLManager.h"
#import "GIGURLRequestFactory.h"
#import "GIGURLCommunicator.h"


@interface GIGURLCommunicatorMultiRequestTests : XCTestCase

@property (strong, nonatomic) GIGURLManager *managerMock;
@property (strong, nonatomic) GIGURLRequestFactory *requestFactoryMock;
@property (strong, nonatomic) NSURLSession *sessionMock;
@property (strong, nonatomic) NSURLSessionDataTask *taskMock;

@property (strong, nonatomic) GIGURLCommunicator *communicator;
@property (strong, nonatomic) GIGURLRequest *request1;
@property (strong, nonatomic) GIGURLRequest *request2;

@end


@implementation GIGURLCommunicatorMultiRequestTests

- (void)setUp
{
    [super setUp];
    
    self.managerMock = MKTMock([GIGURLManager class]);
    self.requestFactoryMock = MKTMock([GIGURLRequestFactory class]);
    self.sessionMock = MKTMock([NSURLSession class]);
    self.taskMock = MKTMock([NSURLSessionDataTask class]);
    
    self.communicator = [[GIGURLCommunicator alloc] initWithManager:self.managerMock requestFactory:self.requestFactoryMock];
    
    self.request1 = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url1" sessionFactory:nil requestFactory:nil logger:nil manager:self.managerMock];
    [MKTGiven([self.requestFactoryMock requestWithMethod:@"GET" url:@"http://url1"]) willReturn:self.request1];
    self.request2 = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url2" sessionFactory:nil requestFactory:nil logger:nil manager:self.managerMock];
    [MKTGiven([self.requestFactoryMock requestWithMethod:@"GET" url:@"http://url2"]) willReturn:self.request2];
}

#pragma mark - TESTS

- (void)test_Send_Requests
{
    XCTestExpectation *groupRequestsSuccess = [self expectationWithDescription:@"All requests have finished"];

    NSDictionary *requests = @{@"Request_1": self.request1,
                               @"Request_2": self.request2};

    NSData *dataImage = [self dataImageType];
    NSData *dataText = [self dataTextType];

    [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
        [groupRequestsSuccess fulfill];
        
        XCTAssert([NSThread isMainThread]);
        
        GIGURLResponse *response1 = [responses valueForKey:@"Request_1"];
        GIGURLResponse *response2 = [responses valueForKey:@"Request_2"];


        XCTAssertNotNil(response1);
        XCTAssertTrue(response1.success);
        XCTAssert([response1.data isEqualToData:dataImage]);

        XCTAssertNotNil(response2);
        XCTAssertTrue(response2.success);
        XCTAssert([response2.data isEqualToData:dataText]);
    }];

    [self responseToRequest:self.request1 data:dataImage delayInSeconds:0.5f];
    [self responseToRequest:self.request2 data:dataText delayInSeconds:0.3f];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error){}];
}

- (void)test_Send_Requests_OneResponse_WithError
{
    XCTestExpectation *groupRequestsSuccess = [self expectationWithDescription:@"All requests have finished"];
    
    NSDictionary *requests = @{@"Request_1": self.request1,
                               @"Request_2": self.request2};
    
    NSData *dataText = [self dataTextType];
    
    [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
        GIGURLResponse *response1 = [responses valueForKey:@"Request_1"];
        GIGURLResponse *response2 = [responses valueForKey:@"Request_2"];
        
        [groupRequestsSuccess fulfill];
        
        XCTAssertNotNil(response1);
        XCTAssertFalse(response1.success);
        XCTAssertTrue(response1.error.code == 404);
        
        XCTAssertNotNil(response2);
        XCTAssertTrue(response2.success);
        XCTAssert([response2.data isEqualToData:dataText]);
    }];
    
    [self responseWithErrorToRequest:self.request1 statusCode:404 delayInSeconds:0.5f];
    [self responseToRequest:self.request2 data:dataText delayInSeconds:0.2f];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error){}];
}

- (void)test_Send_Requests_AllResponses_WithError
{
    XCTestExpectation *groupRequestsSuccess = [self expectationWithDescription:@"All requests have finished"];
    
    NSDictionary *requests = @{@"Request_1": self.request1,
                               @"Request_2": self.request2};
    
    [self.communicator sendRequests:requests completion:^(NSDictionary *responses) {
        GIGURLResponse *response1 = [responses valueForKey:@"Request_1"];
        GIGURLResponse *response2 = [responses valueForKey:@"Request_2"];
        
        [groupRequestsSuccess fulfill];
        
        XCTAssertNotNil(response1);
        XCTAssertFalse(response1.success);
        XCTAssertTrue(response1.error.code == 404);
        
        XCTAssertNotNil(response2);
        XCTAssertFalse(response2.success);
        XCTAssertTrue(response2.error.code == 500);
    }];
    
    [self responseWithErrorToRequest:self.request1 statusCode:404 delayInSeconds:0.5f];
    [self responseWithErrorToRequest:self.request2 statusCode:500 delayInSeconds:0.2f];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error){}];
}

#pragma mark - HELPERS

#pragma mark - Responses

- (void)responseToRequest:(GIGURLRequest *)request data:(NSData *)data delayInSeconds:(double)delayInSeconds
{
    gig_dispatch_after_seconds(delayInSeconds, ^{
        NSURL *URL = [NSURL URLWithString:@"http://url"];
        NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                      statusCode:200
                                                                     HTTPVersion:@"HTTP/1.1"
                                                                    headerFields:nil];
        [request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
            XCTAssert(disposition == NSURLSessionResponseAllow);
        }];
        [request URLSession:self.sessionMock dataTask:self.taskMock didReceiveData:data];
        [request URLSession:self.sessionMock task:self.taskMock didCompleteWithError:nil];
    });
}

- (void)responseWithErrorToRequest:(GIGURLRequest *)request statusCode:(NSInteger)statusCode delayInSeconds:(double)delayInSeconds
{
    gig_dispatch_after_seconds(delayInSeconds, ^{
        NSURL *URL = [NSURL URLWithString:@"http://url"];
        NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL
                                                                      statusCode:statusCode
                                                                     HTTPVersion:@"HTTP/1.1"
                                                                    headerFields:nil];
        
        [request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
            XCTAssert(disposition == NSURLSessionResponseAllow);
        }];
        [request URLSession:self.sessionMock task:self.taskMock didCompleteWithError:nil];
    });
}

#pragma mark - Data Type

- (NSData *)dataTextType
{
    NSString *message = @"This is a good candidate for notifications when a group of tasks completes.";
    return [message dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dataImageType
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}

#pragma mark - Handle files

- (NSData *)dataFromJSONFile:(NSString *)filename
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:filename ofType:nil];
    
    NSError *error = nil;
    if (!path)
    {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:path options:kNilOptions error:&error];
    return data;
}

@end
