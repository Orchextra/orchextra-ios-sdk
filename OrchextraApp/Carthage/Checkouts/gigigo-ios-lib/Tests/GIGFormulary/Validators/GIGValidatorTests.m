//
//  GIGValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGValidator.h"


@interface GIGValidatorTests : XCTestCase

@property (strong, nonatomic) GIGValidator *validator;

@end


@implementation GIGValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;

    [super tearDown];
}

#pragma mark - TESTS

- (void)test_mandatory_by_default
{
    XCTAssertTrue(self.validator.mandatory);
}

- (void)test_validate_mandatory
{
    self.validator.mandatory = YES;
    
    XCTAssertFalse([self.validator validate:nil error:nil]);
    XCTAssertTrue([self.validator validate:@"" error:nil]);
}

- (void)test_validate_optional
{
    self.validator.mandatory = NO;
    
    XCTAssertTrue([self.validator validate:nil error:nil]);
    XCTAssertTrue([self.validator validate:@"" error:nil]);
}

@end
