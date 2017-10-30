//
//  GIGStringValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGStringValidator.h"


@interface GIGStringValidatorTests : XCTestCase

@property (strong, nonatomic) GIGStringValidator *validator;

@end


@implementation GIGStringValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGStringValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_validate_mandatory
{
    self.validator.mandatory = YES;
    
    XCTAssertFalse([self.validator validate:nil error:nil]);
    XCTAssertFalse([self.validator validate:@"" error:nil]);
    XCTAssertFalse([self.validator validate:(id)@YES error:nil]);
}

- (void)test_validate_optional
{
    self.validator.mandatory = NO;
    
    XCTAssertTrue([self.validator validate:nil error:nil]);
    XCTAssertTrue([self.validator validate:@"" error:nil]);
    XCTAssertFalse([self.validator validate:(id)@YES error:nil]);
}

@end
