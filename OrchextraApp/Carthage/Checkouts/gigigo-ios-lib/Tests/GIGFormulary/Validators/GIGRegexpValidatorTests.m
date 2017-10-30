//
//  GIGRegexpValidatorTests.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GIGRegexp.h"
#import "GIGRegexpValidator.h"


@interface GIGRegexpValidatorTests : XCTestCase

@property (strong, nonatomic) GIGRegexpValidator *validator;

@end

@implementation GIGRegexpValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.validator = [[GIGRegexpValidator alloc] initWithRegexpPattern:@"^.{3}$"];
}

- (void)tearDown
{
    self.validator = nil;
    
    [super tearDown];
}

#pragma mark - TESTS (Initialization)

- (void)test_init_with_pattern
{
    NSString *pattern = @".{3}";
    GIGRegexpValidator *validator = [[GIGRegexpValidator alloc] initWithRegexpPattern:pattern];
    
    XCTAssertTrue(validator.mandatory);
    XCTAssertNotNil(validator.regexp);
    XCTAssertTrue([validator.regexp.pattern isEqualToString:pattern]);
}

- (void)test_init_with_invalid_pattern
{
    NSString *pattern = @".{3";
    GIGRegexpValidator *validator = [[GIGRegexpValidator alloc] initWithRegexpPattern:pattern];
    
    XCTAssertTrue(validator.mandatory);
    XCTAssertNil(validator.regexp);
}

- (void)test_init_with_nil_pattern
{
    GIGRegexpValidator *validator = [[GIGRegexpValidator alloc] initWithRegexpPattern:nil];
    
    XCTAssertTrue(validator.mandatory);
    XCTAssertNil(validator.regexp);
}

- (void)test_init_with_empty_pattern
{
    GIGRegexpValidator *validator = [[GIGRegexpValidator alloc] initWithRegexpPattern:@""];
    
    XCTAssertTrue(validator.mandatory);
    XCTAssertNil(validator.regexp);
}

- (void)test_init_with_nil_regexp
{
    GIGRegexpValidator *validator = [[GIGRegexpValidator alloc] initWithRegexp:nil];
    
    XCTAssertTrue(validator.mandatory);
    XCTAssertNil(validator.regexp);
}

- (void)test_init_with_regexp
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@".{3}"];
    GIGRegexpValidator *validator = [[GIGRegexpValidator alloc] initWithRegexp:regexp];
    
    XCTAssertTrue(validator.mandatory);
    XCTAssertTrue([validator.regexp.pattern isEqualToString:regexp.pattern]);
}

#pragma mark - TESTS (Validation)

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

- (void)test_validate_regexp
{
    XCTAssertFalse([self.validator validate:@"a" error:nil]);
    XCTAssertTrue([self.validator validate:@"aaa" error:nil]);
    XCTAssertFalse([self.validator validate:@"aaaa" error:nil]);
}

@end
