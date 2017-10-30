//
//  NSRegularExpression+GIGRegexp.h
//  giglibrary
//
//  Created by Sergio Baró on 10/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSRegularExpression (GIGRegexp)

+ (NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern;

- (BOOL)matchesString:(NSString *)string;
- (NSUInteger)numberOfMatchesInString:(NSString *)string;
- (NSArray *)matchesInString:(NSString *)string;
- (NSString *)stringByReplacingMatchesInString:(NSString *)string withTemplate:(NSString *)templateString;

@end
