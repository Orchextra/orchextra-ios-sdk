//
//  GIGAttributedStringBuilder.h
//  giglibrary
//
//  Created by Sergio Baró on 16/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GIGAttributedStringBuilder : NSObject

// building styles
- (void)addStyle:(NSString *)styleName attributes:(NSDictionary *)styleValues;
- (void)addStyle:(NSString *)styleName font:(UIFont *)font textColor:(UIColor *)color;
- (NSDictionary *)attributesWithFont:(UIFont *)font textColor:(UIColor *)color;

// applying styles
- (NSAttributedString *)applyStylesToString:(NSString *)string;

// parsing styles
- (NSArray *)stylesInfoFromString:(NSString *)string;
- (NSAttributedString *)buildAttributedStringWithStylesInfo:(NSArray *)stylesInfo;

@end
