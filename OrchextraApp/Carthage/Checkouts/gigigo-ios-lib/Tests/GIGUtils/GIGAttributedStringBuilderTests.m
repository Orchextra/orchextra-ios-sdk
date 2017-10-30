//
//  GIGAttributedStringBuilderTests.m
//  giglibrary
//
//  Created by Sergio Baró on 10/7/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GIGAttributedStringBuilder.h"


@interface GIGAttributedStringBuilderTests : XCTestCase

@property (strong, nonatomic) GIGAttributedStringBuilder *factory;

@end


@implementation GIGAttributedStringBuilderTests

- (void)setUp
{
    [super setUp];
    
    self.factory = [[GIGAttributedStringBuilder alloc] init];
}

- (void)tearDown
{
    self.factory = nil;
    
    [super tearDown];
}

#pragma mark - Test stylesInfoFromString:

- (void)testStylesInfoFromNilString
{
    NSArray *stylesInfo = [self.factory stylesInfoFromString:nil];
    XCTAssertTrue(stylesInfo.count == 0, @"%d", (int)stylesInfo.count);
}

- (void)testStylesInfoFromEmptyString
{
    NSArray *stylesInfo = [self.factory stylesInfoFromString:@""];
    XCTAssertTrue(stylesInfo.count == 0, @"%d", (int)stylesInfo.count);
}

- (void)testStylesInfoFromStringWithoutStyle
{
    NSArray *stylesInfo = [self.factory stylesInfoFromString:@"string without styles"];
    XCTAssertTrue(stylesInfo.count == 0, @"%d", (int)stylesInfo.count);
}

- (void)testStylesInfoFromStringWithOneStyle
{
    NSString *string = @"${style}string with styles";
    
    NSArray *stylesInfo = [self.factory stylesInfoFromString:string];
    XCTAssertTrue(stylesInfo.count == 1, @"%d", (int)stylesInfo.count);
    
    if (stylesInfo.count == 1)
    {
        [self assertStyleInfo:stylesInfo[0] hasStyleName:@"style" andSubstring:@"string with styles"];
    }
}

- (void)testStylesInfoFromStringWithTwoStyles
{
    NSString *string = @"${style1}string with ${style2}two styles";
    
    NSArray *stylesInfo = [self.factory stylesInfoFromString:string];
    XCTAssertTrue(stylesInfo.count == 2, @"%d", (int)stylesInfo.count);
    
    if (stylesInfo.count == 2)
    {
        [self assertStyleInfo:stylesInfo[0] hasStyleName:@"style1" andSubstring:@"string with "];
        [self assertStyleInfo:stylesInfo[1] hasStyleName:@"style2" andSubstring:@"two styles"];
    }
}

- (void)testStylesInfoFromStringWithEmptyStyle
{
    NSString *string = @"${}string empty style";
    
    NSArray *stylesInfo = [self.factory stylesInfoFromString:string];
    XCTAssertTrue(stylesInfo.count == 1, @"%d", (int)stylesInfo.count);
}

- (void)testStyleInfoWithStyleInTheMiddle
{
    NSString *string = @"${}pre ${bold}bold${} post";
    
    NSArray *stylesInfo = [self.factory stylesInfoFromString:string];
    XCTAssertTrue(stylesInfo.count == 3, @"%d", (int)stylesInfo.count);
    
    if (stylesInfo.count == 3)
    {
        [self assertStyleInfo:stylesInfo[0] hasStyleName:@"" andSubstring:@"pre "];
        [self assertStyleInfo:stylesInfo[1] hasStyleName:@"bold" andSubstring:@"bold"];
        [self assertStyleInfo:stylesInfo[2] hasStyleName:@"" andSubstring:@" post"];
    }
}

#pragma mark - Text buildAttributedStringWithStylesInfo:

- (void)testBuildAttributedStringWithNilStyles
{
    NSAttributedString *attributedString = [self.factory buildAttributedStringWithStylesInfo:nil];
    XCTAssertTrue(attributedString.length == 0, @"");
}

- (void)testBuildAttributedStringWithNoStyles
{
    NSArray *stylesInfo = @[];
    NSAttributedString *attributedString = [self.factory buildAttributedStringWithStylesInfo:stylesInfo];
    XCTAssertTrue(attributedString.length == 0, @"");
}

- (void)testBuildAttributedStringWithOneStyle
{
    NSString *string = @"${style}substring";
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    UIColor *textColor = [UIColor redColor];
    [self.factory addStyle:@"style" font:font textColor:textColor];
    
    NSAttributedString *attributedString = [self.factory applyStylesToString:string];
    XCTAssertTrue([attributedString.string isEqualToString:@"substring"], @"%@", attributedString.string);
    
    [self assertAttributedString:attributedString attributesAtIndex:0 length:@"substring".length font:font textColor:textColor];
}

- (void)testBuildAttributeStringUppercase
{
    NSString *string = [@"${style}substring" uppercaseString];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    UIColor *textColor = [UIColor redColor];
    [self.factory addStyle:@"style" font:font textColor:textColor];
    
    NSAttributedString *attributedString = [self.factory applyStylesToString:string];
    XCTAssertTrue([attributedString.string isEqualToString:@"SUBSTRING"], @"%@", attributedString.string);
    
    [self assertAttributedString:attributedString attributesAtIndex:0 length:@"substring".length font:font textColor:textColor];
}

- (void)testBuildAttributedStringWithTwoStyles
{
    NSString *string = @"${style}substring ${style2}substring2";
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    UIColor *textColor = [UIColor redColor];
    [self.factory addStyle:@"style" font:font textColor:textColor];
    UIColor *textColor2 = [UIColor blackColor];
    [self.factory addStyle:@"style2" font:font textColor:textColor2];
    
    NSAttributedString *attributedString = [self.factory applyStylesToString:string];
    XCTAssertTrue([attributedString.string isEqualToString:@"substring substring2"], @"%@", attributedString.string);
    
    [self assertAttributedString:attributedString attributesAtIndex:0 length:@"substring ".length font:font textColor:textColor];
    [self assertAttributedString:attributedString attributesAtIndex:@"substring ".length length:@"substring2".length font:font textColor:textColor2];
}

- (void)testBuildAttributedStringWithStyleInTheMiddle
{
    NSString *string = @"${}pre ${bold}bold${} post";
    
    UIColor *textColor = [UIColor whiteColor];
    [self.factory addStyle:@"bold" font:nil textColor:textColor];
    
    NSAttributedString *attributedString = [self.factory applyStylesToString:string];
    XCTAssertTrue([attributedString.string isEqualToString:@"pre bold post"], @"%@", attributedString.string);
    
    [self assertAttributedString:attributedString attributesAtIndex:0 length:@"pre ".length font:nil textColor:nil];
    [self assertAttributedString:attributedString attributesAtIndex:@"pre ".length length:@"bold".length font:nil textColor:textColor];
    [self assertAttributedString:attributedString attributesAtIndex:@"pre bold".length length:@" post".length font:nil textColor:nil];
}

- (void)testBuildAttributedStringWithStyleInTheMiddleAndNoStyleAtTheBeginning
{
    NSString *string = @"pre ${bold}bold${} post";
    
    UIColor *textColor = [UIColor whiteColor];
    [self.factory addStyle:@"bold" font:nil textColor:textColor];
    
    NSAttributedString *attributedString = [self.factory applyStylesToString:string];
    XCTAssertTrue([attributedString.string isEqualToString:@"pre bold post"], @"%@", attributedString.string);
    
    [self assertAttributedString:attributedString attributesAtIndex:0 length:@"pre ".length font:nil textColor:nil];
    [self assertAttributedString:attributedString attributesAtIndex:@"pre ".length length:@"bold".length font:nil textColor:textColor];
    [self assertAttributedString:attributedString attributesAtIndex:@"pre bold".length length:@" post".length font:nil textColor:nil];
}

#pragma mark - Helpers

- (void)assertAttributedString:(NSAttributedString *)attributedString attributesAtIndex:(NSUInteger)index length:(NSUInteger)length font:(UIFont *)font textColor:(UIColor *)textColor
{
    NSRange range;
    NSDictionary *attributes = [attributedString attributesAtIndex:index effectiveRange:&range];
    [self assertRange:range location:index length:length];
    [self assertAttributes:attributes font:font textColor:textColor];
}

- (void)assertStyleInfo:(NSDictionary *)styleInfo hasStyleName:(NSString *)styleName andSubstring:(NSString *)substring
{
    XCTAssertNotNil(styleInfo, @"");
    
    if (styleInfo != nil)
    {
        NSArray *keys = [styleInfo allKeys];
        XCTAssertTrue(keys.count == 1, @"%d", (int)keys.count);
        
        if (keys.count == 1)
        {
            NSString *key = keys[0];
            XCTAssertTrue([key isEqualToString:styleName], @"%@", key);
            
            XCTAssertTrue([styleInfo[key] isEqualToString:substring], @"%@", styleInfo[key]);
        }
    }
}

- (void)assertRange:(NSRange)range location:(NSUInteger)location length:(NSUInteger)length
{
    XCTAssertTrue(range.location == location, @"%d", (int)range.location);
    XCTAssertTrue(range.length == length, @"%d", (int)range.length);
}

- (void)assertAttributes:(NSDictionary *)attributes font:(UIFont *)font textColor:(UIColor *)textColor
{
    UIFont *attributedFont = attributes[NSFontAttributeName];
    XCTAssertTrue(attributedFont == font, @"%@", attributedFont);
    
    UIColor *attributedTextColor = attributes[NSForegroundColorAttributeName];
    XCTAssertTrue(attributedTextColor == textColor, @"%@", attributedTextColor);
}

@end
