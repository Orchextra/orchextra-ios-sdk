//
//  GIGTextValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGTextValidator.h"


@interface GIGTextValidatorTests : XCTestCase

@property (strong, nonatomic) GIGTextValidator *validator;

@end


@implementation GIGTextValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGTextValidator alloc] init];
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

- (void)test_validate_text
{
    XCTAssertTrue([self.validator validate:@"a" error:nil]);
    XCTAssertTrue([self.validator validate:@"a b" error:nil]);
    XCTAssertFalse([self.validator validate:@"a@" error:nil]);
    XCTAssertFalse([self.validator validate:@"a1" error:nil]);
}

@end
