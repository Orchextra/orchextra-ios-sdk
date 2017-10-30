//
//  GIGCharactersValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGCharactersValidator.h"


@interface GIGCharactersValidatorTests : XCTestCase

@property (strong, nonatomic) GIGCharactersValidator *validator;

@end


@implementation GIGCharactersValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGCharactersValidator alloc] initWithCharacters:@"_?@"];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_mandatory_empty
{
    self.validator.mandatory = YES;
    
    XCTAssertFalse([self.validator validate:nil error:nil]);
    XCTAssertFalse([self.validator validate:@"" error:nil]);
}

- (void)test_optional_empty
{
    self.validator.mandatory = NO;
    
    XCTAssertTrue([self.validator validate:nil error:nil]);
    XCTAssertTrue([self.validator validate:@"" error:nil]);
}

- (void)test_valid_strings
{
    XCTAssertTrue([self.validator validate:@"_?@" error:nil]);
    XCTAssertTrue([self.validator validate:@"_" error:nil]);
    XCTAssertTrue([self.validator validate:@"?" error:nil]);
    XCTAssertTrue([self.validator validate:@"???" error:nil]);
    XCTAssertTrue([self.validator validate:@"@" error:nil]);
}

- (void)test_invalid_strings
{
    XCTAssertFalse([self.validator validate:@"_1" error:nil]);
    XCTAssertFalse([self.validator validate:@"1" error:nil]);
    XCTAssertFalse([self.validator validate:@"=_?" error:nil]);
    XCTAssertFalse([self.validator validate:@"" error:nil]);
    XCTAssertFalse([self.validator validate:@"_1" error:nil]);
    XCTAssertFalse([self.validator validate:@"1" error:nil]);
}

@end
