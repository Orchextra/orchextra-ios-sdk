//
//  GIGURLFormatterTests.m
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGURLFormatter.h"


@interface GIGURLFormatterTests : XCTestCase

@property (strong, nonatomic) GIGURLFormatter *formatter;

@end


@implementation GIGURLFormatterTests

- (void)setUp
{
    [super setUp];
    
    self.formatter = [[GIGURLFormatter alloc] init];
}

- (void)tearDown
{
    self.formatter = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_format_url_empty
{
    NSString *result = nil;
    
    result = [self.formatter formatUrl:nil withProtocol:@"http"];
    XCTAssertTrue([result isEqualToString:@"http://"], @"%@", result);
    
    result = [self.formatter formatUrl:@"" withProtocol:@"http"];
    XCTAssertTrue([result isEqualToString:@"http://"], @"%@", result);
}

- (void)test_format_url_only_protocol
{
    NSString *result = nil;
    
    result = [self.formatter formatUrl:@"https://" withProtocol:@"http"];
    XCTAssertTrue([result isEqualToString:@"http://"], @"%@", result);
    
    result = [self.formatter formatUrl:@"http://" withProtocol:@"http"];
    XCTAssertTrue([result isEqualToString:@"http://"], @"%@", result);
    
    result = [self.formatter formatUrl:@"http://" withProtocol:@"https"];
    XCTAssertTrue([result isEqualToString:@"https://"], @"%@", result);
    
    result = [self.formatter formatUrl:@"https://" withProtocol:@"https"];
    XCTAssertTrue([result isEqualToString:@"https://"], @"%@", result);
}

- (void)test_format_url
{
    NSString *result = nil;
    
    result = [self.formatter formatUrl:@"http://hola" withProtocol:@"https"];
    XCTAssertTrue([result isEqualToString:@"https://hola"], @"%@", result);
    
    result = [self.formatter formatUrl:@"https://hola" withProtocol:@"http"];
    XCTAssertTrue([result isEqualToString:@"http://hola"], @"%@", result);
    
    result = [self.formatter formatUrl:@"hola" withProtocol:@"http"];
    XCTAssertTrue([result isEqualToString:@"http://hola"], @"%@", result);
}

@end
