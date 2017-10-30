//
//  GIGRegexpMatchingTests.m
//  giglibrary
//
//  Created by Sergio Baró on 10/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSString+GIGRegexp.h"
#import "NSRegularExpression+GIGRegexp.h"


@interface GIGRegexpMatchingTests : XCTestCase

@end


@implementation GIGRegexpMatchingTests

- (void)testMatchesString
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"hello" options:kNilOptions error:nil];
    
    XCTAssertTrue([regexp matchesString:@"hello"]);
    XCTAssertFalse([regexp matchesString:@"bye"]);
    
    XCTAssertTrue([@"hello" match:@"hello"]);
    XCTAssertFalse([@"bye" match:@"hello"]);
}

- (void)testNumberOfMatches
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"hello" options:kNilOptions error:nil];
    
    XCTAssertTrue([regexp numberOfMatchesInString:@"hello"] == 1);
    XCTAssertTrue([regexp numberOfMatchesInString:@"hello hello"] == 2);
    XCTAssertTrue([regexp numberOfMatchesInString:@"bye"] == 0);
    
    XCTAssertTrue([@"hello" matches:@"hello"].count == 1);
    XCTAssertTrue([@"hello hello" matches:@"hello"].count == 2);
    XCTAssertTrue([@"bye" matches:@"hello"].count == 0);
}

- (void)testMatchesInStringWithNSRegularExpression
{
    NSString *string = @" hello hello ";
    NSString *regexpString = @"(hello)";
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regexpString];
    
    NSArray *matches = [regexp matchesInString:string];
    
    XCTAssertTrue(matches.count == 2);
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match range];
        NSRange firstRange = [match rangeAtIndex:1];
        
        XCTAssertTrue(matchRange.location == firstRange.location);
        NSString *stringMatch = [string substringWithRange:matchRange];
        XCTAssertTrue([stringMatch isEqualToString:@"hello"], @"%@", stringMatch);
    }
}

- (void)testMatchesInStringWithNSString
{
    NSArray *matches = [@" hello hello " matches:@"hello"];
    
    NSArray *expected = @[@"hello", @"hello"];
    XCTAssertTrue([matches isEqualToArray:expected]);
    
    matches = [@"01/12/2015" matches:@"(\\d\\d)/(\\d\\d)/(\\d\\d\\d\\d)"];
    expected = @[@"01", @"12", @"2015"];
    XCTAssertTrue([matches isEqualToArray:expected], @"%@", matches);
}

@end
