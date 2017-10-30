//
//  NSString+GIGReplace.m
//  giglibrary
//
//  Created by Sergio Baró on 14/01/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "NSString+GIGReplace.h"

@implementation NSString (GIGReplace)

- (NSString *)stringByReplacingCharactersInString:(NSString *)charactersString withString:(NSString *)string
{
    NSString *result = [self copy];
    
    NSArray *charactersArray = [charactersString toCharactersArray];
    for (NSString *character in charactersArray)
    {
        result = [result stringByReplacingOccurrencesOfString:character withString:string];
    }
    
    return result;
}

- (NSArray *)toCharactersArray
{
    NSMutableArray *characters = [NSMutableArray array];
    
    for (int i = 0; i < self.length; i++)
    {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        [characters addObject:character];
    }
    
    return characters;
}

@end
