//
//  GIGURLCommunicatorTests.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGTests.h"

#import "GIGURLManager.h"
#import "GIGURLCommunicator.h"


@interface GIGURLCommunicatorTests : XCTestCase

@property (strong, nonatomic) GIGURLManager *managerMock;
@property (strong, nonatomic) NSURLSession *sessionMock;
@property (strong, nonatomic) NSURLSessionDataTask *taskMock;
@property (strong, nonatomic) GIGURLCommunicator *communicator;

@end


@implementation GIGURLCommunicatorTests

- (void)setUp
{
    [super setUp];
    
    self.managerMock = MKTMock([GIGURLManager class]);
    self.sessionMock = MKTMock([NSURLSession class]);
    self.taskMock = MKTMock([NSURLSessionDataTask class]);
    
    self.communicator = [[GIGURLCommunicator alloc] initWithManager:self.managerMock];
}

#pragma mark - TESTS (Build Requests)

- (void)test_Request_GET_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  GET:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"GET"]);
}

- (void)test_Request_POST_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  POST:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"POST"]);
}

- (void)test_Request_DELETE_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  DELETE:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"DELETE"]);
}

- (void)test_Request_PUT_Method
{
    GIGURLRequest *requestFromCommunicator = [self.communicator  PUT:@"http://url"];
    XCTAssert([requestFromCommunicator.method isEqualToString:@"PUT"]);
}

#pragma mark - TESTS (Log Level)

- (void)test_Communicator_log_level_by_default_should_be_error
{
    XCTAssert(self.communicator.logLevel == GIGLogLevelError);
    
    GIGURLRequest *request = [self.communicator GET:@"http://url"];
    XCTAssert(request.logLevel == self.communicator.logLevel);
}

- (void)test_Request_log_level_changes
{
    self.communicator.logLevel = GIGLogLevelVerbose;
    
    GIGURLRequest *request = [self.communicator GET:@"http://url"];
    XCTAssert(request.logLevel == GIGLogLevelVerbose);
}

#pragma mark - TESTS (Send Requests)

- (void)test_Send_Request_From_Communicator
{
    GIGURLRequest *request = [self.communicator GET:@"http://url"];
    NSData *data = [self dataImageType];

    __block GIGURLResponse *blockResponse = nil;
    [self.communicator sendRequest:request completion:^(GIGURLResponse *response) {
        blockResponse = response;
    }];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    
    __block NSURLSessionResponseDisposition blockDisposition = 0;
    [request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
        blockDisposition = disposition;
    }];
    
    XCTAssert(blockDisposition == NSURLSessionResponseAllow);
    
    [request URLSession:self.sessionMock dataTask:self.taskMock didReceiveData:data];
    [request URLSession:self.sessionMock task:self.taskMock didCompleteWithError:nil];
    
    XCTAssert(blockResponse.data != nil);
    XCTAssert([blockResponse.data isEqualToData:data]);
}

#pragma mark - TESTS (Mocks)

- (void)test_Response_Mock_FileNotFound
{
    GIGURLRequest *request = [[GIGURLRequest alloc] initWithMethod:nil url:nil sessionFactory:nil requestFactory:nil logger:nil manager:self.managerMock];
    request.requestTag = @"not_defined_on_fixture";
    
    request.completion = ^(GIGURLResponse *response) {
        XCTAssertFalse(response.success);
        XCTAssertTrue(response.error.code == 404);
    };
}

#pragma mark - HELPERS

#pragma mark - Data Type

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
