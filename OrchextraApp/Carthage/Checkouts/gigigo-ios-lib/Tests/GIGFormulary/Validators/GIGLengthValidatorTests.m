//
//  GIGLengthValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGLengthValidator.h"


@interface GIGLengthValidatorTests : XCTestCase

@end


@implementation GIGLengthValidatorTests

- (void)test_length_mandatory
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] init];
    validator.mandatory = YES;
    
    XCTAssertFalse([validator validate:@"" error:nil]);
    XCTAssertFalse([validator validate:nil error:nil]);
}

- (void)test_length_optional
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] init];
    validator.mandatory = NO;
    
    XCTAssertTrue([validator validate:@"" error:nil]);
    XCTAssertTrue([validator validate:nil error:nil]);
}

- (void)test_mandatory_with_max_length
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] initWithMaxLength:2];
    validator.mandatory = YES;
    
    XCTAssertFalse([validator validate:@"" error:nil]);
    XCTAssertTrue([validator validate:@"1" error:nil]);
    XCTAssertTrue([validator validate:@"12" error:nil]);
    XCTAssertFalse([validator validate:@"123" error:nil]);
}

- (void)test_optional_with_max_length
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] initWithMaxLength:2];
    validator.mandatory = NO;
    
    XCTAssertTrue([validator validate:@"" error:nil]);
    XCTAssertTrue([validator validate:@"1" error:nil]);
    XCTAssertTrue([validator validate:@"12" error:nil]);
    XCTAssertFalse([validator validate:@"123" error:nil]);
}

- (void)test_mandatory_with_min_length
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] initWithMinLength:2];
    validator.mandatory = YES;
    
    XCTAssertFalse([validator validate:@"" error:nil]);
    XCTAssertFalse([validator validate:@"1" error:nil]);
    XCTAssertTrue([validator validate:@"12" error:nil]);
    XCTAssertTrue([validator validate:@"123" error:nil]);
}

- (void)test_optional_with_min_length
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] initWithMinLength:2];
    validator.mandatory = NO;
    
    XCTAssertTrue([validator validate:@"" error:nil]);
    XCTAssertFalse([validator validate:@"1" error:nil]);
    XCTAssertTrue([validator validate:@"12" error:nil]);
    XCTAssertTrue([validator validate:@"123" error:nil]);
}

- (void)test_mandatory_with_min_length_and_max_length
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] initWithMinLength:2 maxLength:3];
    validator.mandatory = YES;
    
    XCTAssertFalse([validator validate:@"" error:nil]);
    XCTAssertFalse([validator validate:@"1" error:nil]);
    XCTAssertTrue([validator validate:@"12" error:nil]);
    XCTAssertTrue([validator validate:@"123" error:nil]);
    XCTAssertFalse([validator validate:@"1234" error:nil]);
}

- (void)test_optional_with_min_length_and_max_length
{
    GIGLengthValidator *validator = [[GIGLengthValidator alloc] initWithMinLength:2 maxLength:3];
    validator.mandatory = NO;
    
    XCTAssertTrue([validator validate:@"" error:nil]);
    XCTAssertFalse([validator validate:@"1" error:nil]);
    XCTAssertTrue([validator validate:@"12" error:nil]);
    XCTAssertTrue([validator validate:@"123" error:nil]);
    XCTAssertFalse([validator validate:@"1234" error:nil]);
}

@end
