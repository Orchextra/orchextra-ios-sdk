//
//  NSArray+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 25/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSArray+GIGExtension.h"


@implementation NSArray (GIGExtension)

- (NSArray *)arrayByAddingObject:(id)object atIndex:(NSInteger)index
{
    NSMutableArray *tmp = [self mutableCopy];
    [tmp insertObject:object atIndex:index];
    
    return [tmp copy];
}

- (NSArray *)arrayByRemovingObject:(id)object
{
    NSMutableArray *tmp = [self mutableCopy];
    [tmp removeObject:object];
    
    return [tmp copy];
}

- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)array
{
    NSMutableArray *tmp = [self mutableCopy];
    
    for (id object in array)
    {
        [tmp removeObject:object];
    }
    
    return [tmp copy];
}

+ (NSArray *)arrayWithArrays:(NSArray *)firstArray, ...
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    va_list args;
    va_start(args, firstArray);
    for (NSArray *array = firstArray; array != nil; array = va_arg(args, NSArray*))
    {
        [resultArray addObjectsFromArray:array];
    }
    va_end(args);
    
    return [resultArray copy];
}

- (BOOL)containsArray:(NSArray *)array
{
    for (id element in array)
    {
        if (![self containsObject:element]) return NO;
    }
    
    return YES;
}

- (NSArray *)filteredArrayWithBlock:(BOOL(^)(id obj))block
{
    if (!block) return self;
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (id obj in self)
    {
        if (block(obj))
        {
            [result addObject:obj];
        }
    }
    
    return [result copy];
}

- (NSArray *)transformArrayWithBlock:(id(^)(id obj))block
{
    if (!block) return self;
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (id obj in self)
    {
        id transObj = block(obj);
        if (transObj)
        {
            [result addObject:transObj];
        }
    }
    
    return [result copy];
}

@end
