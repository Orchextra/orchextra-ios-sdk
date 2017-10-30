//
//  GIGRegexpReplacingTests.m
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSString+GIGRegexp.h"
#import "NSRegularExpression+GIGRegexp.h"


@interface GIGRegexpReplacingTests : XCTestCase

@end


@implementation GIGRegexpReplacingTests

- (void)testReplacing
{
    NSString *string = @" hello hello ";
    NSString *regexpString = @"hello";
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regexpString];
    
    NSString *newString = [regexp stringByReplacingMatchesInString:string withTemplate:@"bye"];
    XCTAssertTrue([newString isEqualToString:@" bye bye "]);
}

- (void)testReplaceWithNSString
{
    NSString *newString = [@" hello hello " stringByReplacing:@"hello" template:@"bye"];
    
    XCTAssertTrue([newString isEqualToString:@" bye bye "]);
}

@end
