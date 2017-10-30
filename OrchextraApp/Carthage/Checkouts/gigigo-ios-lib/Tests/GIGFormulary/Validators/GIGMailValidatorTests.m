
//
//  GIGMailValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGMailValidator.h"


@interface GIGMailValidatorTests : XCTestCase

@property (strong, nonatomic) GIGMailValidator *validator;

@end

@implementation GIGMailValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGMailValidator alloc] init];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_validate_invalid_mails
{
    XCTAssertFalse([self.validator validate:@"47392432" error:nil]);
    XCTAssertFalse([self.validator validate:@"example@mail" error:nil]);
    XCTAssertFalse([self.validator validate:@"mail.es" error:nil]);
}

- (void)test_validate_valid_mails
{
    XCTAssertTrue([self.validator validate:@"example@mail.es" error:nil]);
    XCTAssertTrue([self.validator validate:@"example.example@mail.es" error:nil]);
}

@end
