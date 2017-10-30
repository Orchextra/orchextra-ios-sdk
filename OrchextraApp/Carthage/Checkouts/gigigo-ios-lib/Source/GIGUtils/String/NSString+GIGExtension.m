//
//  NSString+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 28/05/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "NSString+GIGExtension.h"


@implementation NSString (GIGExtension)

- (NSString *)stringByCapitalizingFirstLetter
{
    NSString *capitalizedLetter = [[self substringToIndex:1] capitalizedString];
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:capitalizedLetter];
}

- (NSString *)stringByAddingPrefix:(NSString *)prefix toLength:(NSInteger)length
{
    if (prefix.length == 0) return @"";
    if (length <= self.length) return self;
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSInteger times = (length - self.length) / prefix.length;
    for (; times > 0; times--)
    {
        [result appendString:prefix];
    }
    [result appendString:self];
    
    return [result copy];
}

- (NSString *)stringByRepeatingTimes:(NSInteger)times
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:self];
    
    for (NSInteger i = 1; i < times; i++)
    {
        [result appendString:self];
    }
    
    return result;
}

@end
