//
//  NSString+GIGRegexp.m
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSString+GIGRegexp.h"

#import "NSRegularExpression+GIGRegexp.h"


@implementation NSString (GIGRegexp)

- (BOOL)match:(NSString *)regexpPattern
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regexpPattern];
    
    return [regexp matchesString:self];
}

- (NSArray *)matches:(NSString *)regexpPattern
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regexpPattern];
    
    NSArray *matches = [regexp matchesInString:self];
    NSMutableArray *substrings = [[NSMutableArray alloc] initWithCapacity:matches.count];
    for (NSTextCheckingResult *match in matches)
    {
        if (match.numberOfRanges > 1)
        {
            NSArray *substringsMatch = [self substringsWithResult:match];
            [substrings addObjectsFromArray:substringsMatch];
        }
        else
        {
            NSString *substring = [self substringWithResult:match];
            [substrings addObject:substring];
        }
    }
    
    return [substrings copy];
}

- (NSString *)stringByReplacing:(NSString *)regexpPattern template:(NSString *)templateString
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regexpPattern];
    
    return [regexp stringByReplacingMatchesInString:self withTemplate:templateString];
}

- (NSString *)substringWithResult:(NSTextCheckingResult *)result
{
    return [self substringWithRange:result.range];
}

- (NSArray *)substringsWithResult:(NSTextCheckingResult *)result
{
    NSMutableArray *substrings = [[NSMutableArray alloc] initWithCapacity:result.numberOfRanges];
    
    for (int i = 1; i < result.numberOfRanges; i++)
    {
        NSRange range = [result rangeAtIndex:i];
        NSString *substring = [self substringWithRange:range];
        [substrings addObject:substring];
    }
    
    return [substrings copy];
}

@end
