//
//  GIGAttributedStringFactory.m
//  giglibrary
//
//  Created by Sergio Baró on 16/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "GIGAttributedStringBuilder.h"


@interface GIGAttributedStringBuilder ()

@property (strong, nonatomic) NSMutableDictionary *styles;
@property (strong, nonatomic) NSRegularExpression *tagRegex;

@end


@implementation GIGAttributedStringBuilder

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _styles = [[NSMutableDictionary alloc] init];
        _tagRegex = [NSRegularExpression regularExpressionWithPattern:@"\\$\\{([\\w]*)\\}([^${]+)" options:kNilOptions error:nil];
    }
    return self;
}

#pragma mark - Public (Attributes)

- (void)addStyle:(NSString *)styleName attributes:(NSDictionary *)styleValues
{
    if (styleName != nil && styleValues != nil)
    {
        self.styles[[styleName lowercaseString]] = styleValues;
    }
}

- (void)addStyle:(NSString *)styleName font:(UIFont *)font textColor:(UIColor *)color
{
    NSDictionary *attributes = [self attributesWithFont:font textColor:color];
    [self addStyle:styleName attributes:attributes];
}

- (NSDictionary *)attributesWithFont:(UIFont *)font textColor:(UIColor *)color
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (font) attributes[NSFontAttributeName] = font;
    if (color) attributes[NSForegroundColorAttributeName] = color;
    
    return attributes;
}

#pragma mark - Public (Applying styles)

- (NSAttributedString *)applyStylesToString:(NSString *)string
{
    if (![string hasPrefix:@"${}"])
    {
        string = [NSString stringWithFormat:@"${}%@", string];
    }
    
    NSArray *stylesInfo = [self stylesInfoFromString:string];
    NSAttributedString *attributedString = [self buildAttributedStringWithStylesInfo:stylesInfo];
    
    return attributedString;
}

#pragma mark - Public (Parsing styles)

- (NSArray *)stylesInfoFromString:(NSString *)string
{
    NSMutableArray *stylesInfo = [NSMutableArray array];
    
    if (string)
    {
        NSArray *matches = [self.tagRegex matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
        for (NSTextCheckingResult *match in matches)
        {
            if (match.numberOfRanges == 3)
            {
                NSString *styleName = [string substringWithRange:[match rangeAtIndex:1]];
                NSString *substring = [string substringWithRange:[match rangeAtIndex:2]];
                
                NSDictionary *styleInfo = @{[styleName lowercaseString]:substring};
                [stylesInfo addObject:styleInfo];
            }
        }
    }
    
    return stylesInfo;
}

- (NSAttributedString *)buildAttributedStringWithStylesInfo:(NSArray *)stylesInfo
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    for (NSDictionary *styleInfo in stylesInfo)
    {
        NSString *styleName = [styleInfo allKeys][0];
        NSDictionary *attributes = self.styles[styleName];
        NSString *substring = styleInfo[styleName];
        
        NSAttributedString *attributedSubstring = [[NSAttributedString alloc] initWithString:substring attributes:attributes];
        [attributedString appendAttributedString:attributedSubstring];
    }
    
    return attributedString;
}

@end
