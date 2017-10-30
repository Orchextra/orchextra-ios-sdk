//
//  NSString+GIGRegexp.h
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (GIGRegexp)

- (BOOL)match:(NSString *)regexpPattern;
- (NSArray *)matches:(NSString *)regexpPattern;
- (NSString *)stringByReplacing:(NSString *)regexpPattern template:(NSString *)templateString;

- (NSString *)substringWithResult:(NSTextCheckingResult *)result;
- (NSArray *)substringsWithResult:(NSTextCheckingResult *)result;

@end
