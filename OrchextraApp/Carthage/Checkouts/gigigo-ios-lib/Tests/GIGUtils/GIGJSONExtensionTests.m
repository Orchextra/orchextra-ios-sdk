//
//  GIGJSONExtensionTests.m
//  giglibrary
//
//  Created by Sergio Baró on 22/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSDictionary+GIGJSON.h"


@interface GIGJSONExtensionTests : XCTestCase

@end


@implementation GIGJSONExtensionTests

#pragma mark - TESTS (Bool)

- (void)test_bool_yes
{
    NSDictionary *json = @{@"key": @(YES)};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertTrue(result);
}

- (void)test_bool_no
{
    NSDictionary *json = @{@"key": @(NO)};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertFalse(result);
}

- (void)test_bool_number
{
    NSDictionary *json = @{@"key": @(5)};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertTrue(result);
}

- (void)test_bool_true_string
{
    NSDictionary *json = @{@"key": @"true"};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertTrue(result);
}

- (void)test_bool_false_string
{
    NSDictionary *json = @{@"key": @"false"};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertFalse(result);
}

- (void)test_bool_string_one
{
    NSDictionary *json = @{@"key": @"1"};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertTrue(result);
}

- (void)test_bool_string_zero
{
    NSDictionary *json = @{@"key": @"0"};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertFalse(result);
}

- (void)test_bool_string_number
{
    NSDictionary *json = @{@"key": @"5"};
    BOOL result = [json boolForKey:@"key"];
    
    XCTAssertTrue(result);
}

#pragma mark - TESTS (String)

- (void)test_string_nil
{
    NSDictionary *json = @{};
    NSString *result = [json stringForKey:@"key"];
    
    XCTAssertTrue([result isEqualToString:@""]);
}

- (void)test_string_null
{
    NSDictionary *json = @{@"key": [NSNull null]};
    NSString *result = [json stringForKey:@"key"];
    
    XCTAssertTrue([result isEqualToString:@""]);
}

- (void)test_string_number
{
    NSDictionary *json = @{@"key": @(1)};
    NSString *result = [json stringForKey:@"key"];
    
    XCTAssertTrue([result isEqualToString:@"1"]);
}

- (void)test_string_valid
{
    NSDictionary *json = @{@"key": @"string"};
    NSString *result = [json stringForKey:@"key"];
    
    XCTAssertTrue([result isEqualToString:@"string"]);
}

- (void)test_string_trim
{
    NSDictionary *json = @{@"key": @"  string  "};
    NSString *result = [json stringTrimForKey:@"key"];
    
    XCTAssertTrue([result isEqualToString:@"string"]);
}

#pragma mark - TESTS (Array)

- (void)test_array_null
{
    NSDictionary *json = @{@"key": [NSNull null]};
    NSArray *result = [json arrayForKey:@"key"];
    
    XCTAssertNil(result);
}

- (void)test_array_nil
{
    NSDictionary *json = @{};
    NSArray *result = [json arrayForKey:@"key"];
    
    XCTAssertNil(result);
}

- (void)test_array_invalid
{
    NSDictionary *json = @{@"key": @"string"};
    NSArray *result = [json arrayForKey:@"key"];
    
    XCTAssertNil(result);
}

- (void)test_array_empty
{
    NSDictionary *json = @{@"key": @[]};
    NSArray *result = [json arrayForKey:@"key"];
    
    XCTAssertNotNil(result);
    XCTAssertTrue(result.count == 0);
}

- (void)test_array_with_null
{
    NSDictionary *json = @{@"key": @[[NSNull null]]};
    NSArray *result = [json arrayForKey:@"key"];
    
    XCTAssertNotNil(result);
    XCTAssertTrue(result.count == 0);
}

- (void)test_array_non_empty
{
    NSDictionary *json = @{@"key": @[@"string", @(3)]};
    NSArray *result = [json arrayForKey:@"key"];
    
    XCTAssertTrue(result.count == 2);
}

#pragma mark - TESTS (Date)

- (void)test_date_nil
{
    NSDictionary *json = @{};
    NSDate *date = [json dateForKey:@"key" format:@"dd/MM/yyyy"];
    
    XCTAssertNil(date);
}

- (void)test_date_null
{
    NSDictionary *json = @{@"key": [NSNull null]};
    NSDate *date = [json dateForKey:@"key" format:@"dd/MM/yyyy"];
    
    XCTAssertNil(date);
}

- (void)test_date_format
{
    NSDictionary *json = @{@"key": @"12/04/2013"};
    NSDate *date = [json dateForKey:@"key" format:@"dd/MM/yyyy"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy";
    
    XCTAssertNotNil(date);
    XCTAssertTrue([@"12/04/2013" isEqualToString:[formatter stringFromDate:date]]);
}

#pragma mark - TESTS (URL)

- (void)test_url_nil
{
    NSDictionary *json = @{};
    NSURL *URL = [json URLForKey:@"key"];
    
    XCTAssertNil(URL);
}

- (void)test_url_null
{
    NSDictionary *json = @{@"key": [NSNull null]};
    NSURL *URL = [json URLForKey:@"key"];
    
    XCTAssertNil(URL);
}

- (void)test_url_number
{
    NSDictionary *json = @{@"key": @(3)};
    NSURL *URL = [json URLForKey:@"key"];
    
    XCTAssertNil(URL);
}

- (void)test_url_valid
{
    NSDictionary *json = @{@"key": @"http://www.gigigo.com"};
    NSURL *URL = [json URLForKey:@"key"];
    
    XCTAssertTrue(URL);
}

#pragma mark - TESTS (Integer)

- (void)test_integer_nil
{
    NSDictionary *json = @{};
    NSInteger result = [json integerForKey:@"key"];
    
    XCTAssertTrue(result == 0);
}

- (void)test_integer_null
{
    NSDictionary *json = @{@"key": [NSNull null]};
    NSInteger result = [json integerForKey:@"key"];
    
    XCTAssertTrue(result == 0);
}

- (void)test_integer_string_invalid
{
    NSDictionary *json = @{@"key": @"value"};
    NSInteger result = [json integerForKey:@"key"];
    
    XCTAssertTrue(result == 0);
}

- (void)test_integer_string_valid
{
    NSDictionary *json = @{@"key": @"1"};
    NSInteger result = [json integerForKey:@"key"];
    
    XCTAssertTrue(result == 1);
}

- (void)test_integer_number
{
    NSDictionary *json = @{@"key":@(1)};
    NSInteger result = [json integerForKey:@"key"];
    
    XCTAssertTrue(result == 1);
}

@end
