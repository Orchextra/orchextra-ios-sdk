//
//  NSString+GIGSubstring.m
//  giglibrary
//
//  Created by Sergio Baró on 06/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSString+GIGSubstring.h"


@implementation NSString (GIGSubstring)

- (BOOL)isEmpty
{
    return (self.length == 0);
}

- (BOOL)contains:(NSString *)substring
{
	NSRange range = [self rangeOfString:substring];
	
	return (range.location != NSNotFound);
}

- (BOOL)containsSubtring:(NSString *)substring
{
    return [self contains:substring];
}

- (BOOL)insensitiveContains:(NSString *)substring
{
    NSRange range = [self rangeOfString:substring options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    
    return (range.location != NSNotFound);
}

- (BOOL)insensitiveHasPrefix:(NSString *)prefix
{
    NSRange range = [self rangeOfString:prefix options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    
    return  (range.location == 0);
}
@end
