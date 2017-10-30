//
//  GIGBoolValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGBoolValidator.h"


@interface GIGBoolValidatorTests : XCTestCase

@property (strong, nonatomic) GIGBoolValidator *validator;

@end


@implementation GIGBoolValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGBoolValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_validate_booleans
{
    XCTAssertTrue([self.validator validate:@YES error:nil]);
    XCTAssertFalse([self.validator validate:@NO error:nil]);
}

@end
