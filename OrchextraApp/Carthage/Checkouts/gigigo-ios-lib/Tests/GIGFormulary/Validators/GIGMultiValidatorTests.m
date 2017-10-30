//
//  GIGMultiValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGValidators.h"


@interface GIGMultiValidatorTests : XCTestCase

@property (strong, nonatomic) GIGMultiValidator *validator;
@end


@implementation GIGMultiValidatorTests

- (void)setUp
{
    [super setUp];
    
    GIGValidator *numericValidator = [[GIGNumericValidator alloc] init];
    GIGValidator *lengthValidator = [[GIGLengthValidator alloc] initWithMaxLength:3];
    NSArray *validators = @[numericValidator, lengthValidator];
    
    self.validator = [[GIGMultiValidator alloc] initWithValidators:validators];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)test_multi_valid
{
    XCTAssertTrue([self.validator validate:@"123" error:nil]);
    XCTAssertTrue([self.validator validate:@"12" error:nil]);
    XCTAssertTrue([self.validator validate:@"1" error:nil]);
}

- (void)test_multi_invalid
{
    XCTAssertFalse([self.validator validate:nil error:nil]);
    XCTAssertFalse([self.validator validate:@"" error:nil]);
    XCTAssertFalse([self.validator validate:@"ab" error:nil]);
    XCTAssertFalse([self.validator validate:@"1234" error:nil]);
}

@end
