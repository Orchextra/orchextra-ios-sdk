//
//  NSDictionary+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 08/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "NSDictionary+GIGExtension.h"


@implementation NSDictionary (GIGExtension)

- (BOOL)containsDictionary:(NSDictionary *)dictionary
{
    __block BOOL result = YES;
    
    for (id key in dictionary.allKeys)
    {
        result = [self[key] isEqual:dictionary[key]];
        
        if (!result) return result;
    }
    
    return result;
}

- (NSDictionary *)dictionaryForKeys:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    va_list args;
    va_start(args, firstKey);
    for (id key = firstKey; key != nil; key = va_arg(args, id))
    {
        result[key] = self[key];
    }
    va_end(args);
    
    return [result copy];
}

- (NSDictionary *)dictionaryForKeysArray:(NSArray *)keys
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:keys.count];
    
    for (id key in keys)
    {
        result[key] = self[key];
    }
    
    return [result copy];
}

- (NSDictionary *)dictionaryAddingEntriesFromDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [self mutableCopy];
    [dict addEntriesFromDictionary:dictionary];
    
    return [dict copy];
}

@end
