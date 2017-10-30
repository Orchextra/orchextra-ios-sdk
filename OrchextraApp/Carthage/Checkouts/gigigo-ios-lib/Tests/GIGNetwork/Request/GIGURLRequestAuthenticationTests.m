//
//  GIGURLRequestAuthenticationTests.m
//  GIGLibrary
//
//  Created by Sergio Baró on 31/08/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "GIGURLRequest.h"


@interface GIGURLRequestAuthenticationTests : XCTestCase

@property (strong, nonatomic) NSURLAuthenticationChallenge *challengeMock;
@property (strong, nonatomic) NSURLProtectionSpace *protectionSpaceMock;
@property (strong, nonatomic) id<NSURLAuthenticationChallengeSender> senderMock;
@property (strong, nonatomic) NSURLSession *sessionMock;
@property (strong, nonatomic) NSURLSessionDataTask *taskMock;

@property (strong, nonatomic) GIGURLRequest *request;
@property (strong, nonatomic) MKTArgumentCaptor *captor;

@end

@implementation GIGURLRequestAuthenticationTests

- (void)setUp
{
    [super setUp];
    
    self.request = [[GIGURLRequest alloc] initWithMethod:@"GET" url:@"http://url" sessionFactory:nil requestFactory:nil logger:nil manager:nil];
    
    self.protectionSpaceMock = MKTMock([NSURLProtectionSpace class]);
    self.senderMock = MKTMockProtocol(@protocol(NSURLAuthenticationChallengeSender));
    self.challengeMock = MKTMock([NSURLAuthenticationChallenge class]);
    self.sessionMock = MKTMock([NSURLSession class]);
    self.taskMock = MKTMock([NSURLSessionDataTask class]);
    
    [MKTGiven([self.challengeMock protectionSpace]) willReturn:self.protectionSpaceMock];
    [MKTGiven([self.challengeMock sender]) willReturn:self.senderMock];
    
    self.captor = [[MKTArgumentCaptor alloc] init];
}

#pragma mark - TESTS

- (void)test_authentication_default
{
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengePerformDefaultHandling);
        XCTAssert(credential == nil);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_ignore_ssl
{
    self.request.ignoreSSL = YES;
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssert(credential != nil);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_http_basic
{
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTTPBasic];
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssertNotNil(credential);
        XCTAssertTrue([credential.user isEqualToString:@"user"]);
        XCTAssertTrue([credential.password isEqualToString:@"password"]);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_block_returns_nil
{
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodDefault];
    
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return nil;
    };
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengePerformDefaultHandling);
        XCTAssert(credential == nil);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_block_returns_credential
{
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodDefault];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user" password:@"password" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssert(credential != nil);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_block_and_ignore_ssl
{
    self.request.ignoreSSL = YES;
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user" password:@"password" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssert(credential != nil);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_block_and_http_basic
{
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTTPBasic];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssertNotNil(credential);
        XCTAssertTrue([credential.user isEqualToString:@"user"]);
        XCTAssertTrue([credential.password isEqualToString:@"password"]);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_block_and_http_basic_trust_authentication
{
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodServerTrust];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssertNotNil(credential);
        XCTAssertTrue([credential.user isEqualToString:@"user2"]);
        XCTAssertTrue([credential.password isEqualToString:@"password2"]);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_block_and_ignore_ssl_basic_authentication
{
    self.request.ignoreSSL = YES;
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTTPBasic];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssertNotNil(credential);
        XCTAssertTrue([credential.user isEqualToString:@"user2"]);
        XCTAssertTrue([credential.password isEqualToString:@"password2"]);
    }];
    
    XCTAssert(blockCalled == YES);
}

- (void)test_authentication_block_and_ignore_ssl_and_http_basic_other_authentication
{
    self.request.ignoreSSL = YES;
    [self.request setHTTPBasicUser:@"user" password:@"password"];
    
    [MKTGiven([self.protectionSpaceMock authenticationMethod]) willReturn:NSURLAuthenticationMethodHTMLForm];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"user2" password:@"password2" persistence:NSURLCredentialPersistenceForSession];
    self.request.authentication = ^id(NSURLAuthenticationChallenge *challenge) {
        return credential;
    };
    
    __block BOOL blockCalled = NO;
    [self.request URLSession:self.sessionMock task:self.taskMock didReceiveChallenge:self.challengeMock completionHandler:^(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential) {
        blockCalled = YES;
        XCTAssert(disposition == NSURLSessionAuthChallengeUseCredential);
        XCTAssertNotNil(credential);
        XCTAssertTrue([credential.user isEqualToString:@"user2"]);
        XCTAssertTrue([credential.password isEqualToString:@"password2"]);
    }];
    
    XCTAssert(blockCalled == YES);
}

@end
