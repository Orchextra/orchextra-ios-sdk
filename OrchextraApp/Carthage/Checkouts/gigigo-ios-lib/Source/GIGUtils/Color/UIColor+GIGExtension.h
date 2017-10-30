//
//  UIColor+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 03/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


#define GIGColorFromHex(rgbValue) [UIColor colorFromHex:rgbValue]
#define GIGColorToHex(color) [NSString stringWithFormat:@"%06x", color]


@interface UIColor (GIGExtension)

+ (UIColor *)colorFromHex:(NSInteger)hex;
+ (UIColor *)colorFromHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)randomColor;

+ (UIColor *)colorFromRGBString:(NSString *)rgbString; // @"255,255,255,100"
- (NSString *)toRGBString;

@end
