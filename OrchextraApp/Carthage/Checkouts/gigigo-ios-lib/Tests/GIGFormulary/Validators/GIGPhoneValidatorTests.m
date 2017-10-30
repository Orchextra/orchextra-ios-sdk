//
//  GIGPhoneValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGPhoneValidator.h"


@interface GIGPhoneValidatorTests : XCTestCase

@property (strong, nonatomic) GIGPhoneValidator *validator;

@end


@implementation GIGPhoneValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGPhoneValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_valid_phones
{
    XCTAssertTrue([self.validator validate:@"900123123" error:nil]);
    XCTAssertTrue([self.validator validate:@"+1900123123" error:nil]);
    XCTAssertTrue([self.validator validate:@"+12900123123" error:nil]);
    XCTAssertTrue([self.validator validate:@"+123900123123" error:nil]);
}

- (void)test_invalid_phones
{
    XCTAssertFalse([self.validator validate:@"1" error:nil]);
    XCTAssertFalse([self.validator validate:@"+413y9743" error:nil]);
    XCTAssertFalse([self.validator validate:@"+1239876543210" error:nil]);
    XCTAssertFalse([self.validator validate:@"98765432" error:nil]);
    XCTAssertFalse([self.validator validate:@"9876543210" error:nil]);
}

@end
