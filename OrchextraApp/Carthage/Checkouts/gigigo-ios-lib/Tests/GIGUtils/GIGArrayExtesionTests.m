//
//  GIGArrayExtesionTests.m
//  giglibrary
//
//  Created by Sergio Baró on 26/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSArray+GIGExtension.h"


@interface GIGArrayExtesionTests : XCTestCase

@end

@implementation GIGArrayExtesionTests

- (void)test_array_removing_object
{
    NSArray *array = @[@"1", @"2", @"3"];
    NSArray *result = [array arrayByRemovingObject:@"2"];
    NSArray *expected = @[@"1", @"3"];
    
    XCTAssertTrue([expected isEqualToArray:result]);
}

- (void)test_array_removing_objects
{
    NSArray *array = @[@"1", @"2", @"3"];
    NSArray *result = [array arrayByRemovingObjectsFromArray:@[@"1", @"2"]];
    NSArray *expected = @[@"3"];
    
    XCTAssertTrue([expected isEqualToArray:result]);
}

@end
