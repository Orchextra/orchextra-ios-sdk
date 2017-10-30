//
//  NSRegularExpression+GIGRegexp.m
//  giglibrary
//
//  Created by Sergio Baró on 10/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSRegularExpression+GIGRegexp.h"


@implementation NSRegularExpression (GIGRegexp)

+ (NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern
{
    return [NSRegularExpression regularExpressionWithPattern:pattern
                                                     options:kNilOptions
                                                       error:nil];
}

- (BOOL)matchesString:(NSString *)string
{
    return ([self numberOfMatchesInString:string] > 0);
}

- (NSUInteger)numberOfMatchesInString:(NSString *)string
{
    return [self numberOfMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
}

- (NSArray *)matchesInString:(NSString *)string
{
    return [self matchesInString:string
                         options:0
                           range:NSMakeRange(0, string.length)];
}

- (NSString *)stringByReplacingMatchesInString:(NSString *)string withTemplate:(NSString *)templateString
{
    return [self stringByReplacingMatchesInString:string
                                          options:0
                                            range:NSMakeRange(0, string.length)
                                     withTemplate:templateString];
}

@end
