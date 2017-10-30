//
//  GIGURLRequestTests.m
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGTests.h"

#import "GIGURLManager.h"
#import "GIGURLRequest.h"


@interface GIGURLRequestTests : XCTestCase

@property (strong, nonatomic) NSURLSession *sessionMock;
@property (strong, nonatomic) NSURLSessionDataTask *taskMock;
@property (strong, nonatomic) GIGURLManager *managerMock;
@property (strong, nonatomic) GIGURLRequest *request;

@end


@implementation GIGURLRequestTests

- (void)setUp
{
    [super setUp];
    
    self.sessionMock = MKTMock([NSURLSession class]);
    self.taskMock = MKTMock([NSURLSessionDataTask class]);
    self.managerMock = MKTMock([GIGURLManager class]);
    
    self.request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" manager:self.managerMock];
}

- (void)tearDown
{
    self.taskMock = nil;
    self.sessionMock = nil;
    self.managerMock = nil;
    
    self.request = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_Request_init
{
    GIGURLRequest *request = [[GIGURLRequest alloc] init];
    
    XCTAssert(request != nil);
}

- (void)test_Request_error
{
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    [self.request URLSession:self.sessionMock task:self.taskMock didCompleteWithError:error];
    
    XCTAssertNotNil(response);
    XCTAssertFalse(response.success);
    XCTAssertTrue([response.error isEqual:error]);
}

- (void)test_Request_response_404
{
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:404 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
        XCTAssert(disposition = NSURLSessionResponseAllow);
    }];
    [self.request URLSession:self.sessionMock task:self.taskMock didCompleteWithError:nil];
    
    XCTAssertNotNil(response);
    XCTAssertFalse(response.success);
    XCTAssertTrue(response.error.code == 404);
}

- (void)test_Request_response_500_with_data
{
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    NSString *str = @"data string";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:404 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
        XCTAssert(disposition == NSURLSessionResponseAllow);
    }];
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveData:data];
    NSError *error = [NSError errorWithDomain:@"com.gigigo.errorCode" code:500 userInfo:nil];
    [self.request URLSession:self.sessionMock task:self.taskMock didCompleteWithError:error];
    
    XCTAssertNotNil(response);
    XCTAssertFalse(response.success);
    XCTAssertTrue(response.error.code == 500);
    XCTAssertNotNil(response.data);
}

- (void)test_Request_response_200
{
    __block GIGURLResponse *response = nil;
    self.request.completion = ^(id resp) {
        response = resp;
    };
    [self.request send];
    
    NSData *data = [self dataImage];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
        XCTAssert(disposition == NSURLSessionResponseAllow);
    }];
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveData:data];
    [self.request URLSession:self.sessionMock task:self.taskMock didCompleteWithError:nil];
    
    XCTAssertNotNil(response);
    XCTAssertTrue(response.success);
    XCTAssertNotNil(response.data);
    XCTAssertTrue([response.data isEqualToData:data]);
    XCTAssertNil(response.error);
}

- (void)test_Request_download_progress
{
    __block float progress = 0.0f;
    self.request.downloadProgress = ^(float prog) {
        progress = prog;
    };
    [self.request send];
    
    NSData *data = [self dataImage];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSDictionary *headerFields = @{@"Content-Length": [NSString stringWithFormat:@"%ld", (long)data.length]};
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
    
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
        XCTAssert(disposition = NSURLSessionResponseAllow);
    }];
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveData:data];
    
    XCTAssertTrue(progress == 1.0f, @"%f", progress);
}

- (void)test_Request_upload_progress
{
    __block float progress = 0.0f;
    self.request.uploadProgress = ^(float prog) {
        progress = prog;
    };
    [self.request send];
    
    NSURL *URL = [NSURL URLWithString:@"http://url"];
    NSHTTPURLResponse *HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    [self.request URLSession:self.sessionMock dataTask:self.taskMock didReceiveResponse:HTTPResponse completionHandler:^(NSURLSessionResponseDisposition disposition) {
        XCTAssert(disposition == NSURLSessionResponseAllow);
    }];
    [self.request URLSession:self.sessionMock task:self.taskMock didSendBodyData:10 totalBytesSent:10 totalBytesExpectedToSend:20];
    
    XCTAssertTrue(progress == 0.5f, @"%f", progress);
}

#pragma mark - HELPERS

- (NSData *)dataImage
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

@end
