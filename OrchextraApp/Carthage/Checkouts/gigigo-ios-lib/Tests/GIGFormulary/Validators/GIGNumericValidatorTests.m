//
//  GIGNumericValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGNumericValidator.h"


@interface GIGNumericValidatorTests : XCTestCase

@property (strong, nonatomic) GIGNumericValidator *validator;

@end


@implementation GIGNumericValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGNumericValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_validation_mandatory
{
    self.validator.mandatory = YES;
    
    XCTAssertFalse([self.validator validate:nil error:nil]);
    XCTAssertFalse([self.validator validate:@"" error:nil]);
    XCTAssertFalse([self.validator validate:(id)@YES error:nil]);
}

- (void)test_validation_optional
{
    self.validator.mandatory = NO;
    
    XCTAssertTrue([self.validator validate:nil error:nil]);
    XCTAssertTrue([self.validator validate:@"" error:nil]);
    XCTAssertFalse([self.validator validate:(id)@YES error:nil]);
}

- (void)test_numeric_validation
{
    XCTAssertTrue([self.validator validate:@"1" error:nil]);
    XCTAssertTrue([self.validator validate:@"123456789" error:nil]);
    XCTAssertFalse([self.validator validate:@"ab" error:nil]);
    XCTAssertFalse([self.validator validate:@"123 " error:nil]);
}

@end
