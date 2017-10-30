//
//  UIColor+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 03/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "UIColor+GIGExtension.h"


@implementation UIColor (GIGExtension)

+ (UIColor *)colorFromHex:(NSInteger)rgbValue
{
    return [self colorFromHex:rgbValue alpha:1.0f];
}

+ (UIColor *)colorFromHex:(NSInteger)rgbValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorFromHex:rgbValue];
}

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)colorFromRGBString:(NSString *)rgbString
{
    UIColor *result = nil;
    
    NSArray *rgbStringComponents = [rgbString componentsSeparatedByString:@","];
    
    if (rgbStringComponents.count == 3 || rgbStringComponents.count == 4)
    {
        NSString *redString = rgbStringComponents[0];
        CGFloat red = [redString floatValue] / 255.0f;
        NSString *greenString = rgbStringComponents[1];
        CGFloat green = [greenString floatValue] / 255.0f;
        NSString *blueString = rgbStringComponents[2];
        CGFloat blue = [blueString floatValue] / 255.0f;
        
        CGFloat alpha = 1.0f;
        if (rgbStringComponents.count == 4)
        {
            NSString *alphaString = rgbStringComponents[3];
            alpha = [alphaString floatValue] / 100.0f;
        }
        
        result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    
    return result;
}

- (NSString *)toRGBString
{
    CGFloat red, green, blue, alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSString *result = [NSString stringWithFormat:@"%.0f,%.0f,%.0f", red * 255.0f, green * 255.0f, blue * 255.0f];
    
    if (alpha < 1.0f)
    {
        result = [NSString stringWithFormat:@"%@,%.0f", result, alpha * 100];
    }
    
    return result;
}

@end
