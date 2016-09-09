//
//  ORCTagTests.m
//  Orchextra
//
//  Created by Judith Medina on 27/5/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ORCTag.h"


@interface ORCTagTests : XCTestCase


@end

@implementation ORCTagTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_validatePrefix_withValidName_returnTag
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color"];
    
    NSString *tagFormatted = [tag tag];
    
    XCTAssertNotNil(tag);
    XCTAssert([tagFormatted isEqualToString:@"color"]);
}

- (void)test_validatePrefix_whereNameWStartsWithUnderlineS_returnFalse
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"_s"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNotNil(tag);
    XCTAssert([tagFormatted isEqualToString:@"_s"]);
}

- (void)test_vvalidatePrefix_whereNameDoubleColon_returnNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"::color"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validatePrefix_whereNameWithSlash_returnNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"/color"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validatePrefix_whereNameWithSlashinMidle_returnNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"col/or"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validatePrefix_whereNameWStartsWithUnderline_returnFalse
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"_color"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validatePrefix_whereNameLessThanTwoCharacters_returnNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"c"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validateName_whereNameValid_returnTagPrefixAndName
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color" name:@"yellow"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNotNil(tag);
    XCTAssert([tagFormatted isEqualToString:@"color::yellow"]);
}

- (void)test_validateName_whereNameWithDoubleColon_returnTagNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color" name:@"::yellow"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validateName_whereNameInvalidSlash_returnTagNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color" name:@"/yellow"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validateName_whereNameStartWithUnderline_returnTagNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color" name:@"_yellow"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

- (void)test_validateName_whereNameLessThanTwoCharacters_returnTagNil
{
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color" name:@"c"];
    NSString *tagFormatted = [tag tag];
    XCTAssertNil(tagFormatted);
}

@end
