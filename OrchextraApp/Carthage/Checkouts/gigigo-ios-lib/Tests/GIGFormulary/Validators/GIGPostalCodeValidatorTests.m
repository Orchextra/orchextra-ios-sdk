//
//  GIGPostalCodeValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGPostalCodeValidator.h"


@interface GIGPostalCodeValidatorTests : XCTestCase

@property (strong, nonatomic) GIGPostalCodeValidator *validator;

@end


@implementation GIGPostalCodeValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGPostalCodeValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_valid_postal_codes
{
    XCTAssertTrue([self.validator validate:@"1234" error:nil]);
    XCTAssertTrue([self.validator validate:@"01234" error:nil]);
    XCTAssertTrue([self.validator validate:@"12345" error:nil]);
}

- (void)test_invalid_postal_codes
{
    XCTAssertFalse([self.validator validate:@"0234" error:nil]);
    XCTAssertFalse([self.validator validate:@"123" error:nil]);
    XCTAssertFalse([self.validator validate:@"1" error:nil]);
    XCTAssertFalse([self.validator validate:@"123456" error:nil]);
    XCTAssertFalse([self.validator validate:@"00123" error:nil]);
    XCTAssertFalse([self.validator validate:@"123a" error:nil]);
}

@end
