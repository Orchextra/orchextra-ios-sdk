//
//  NSArray+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 25/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (GIGExtension)

- (NSArray *)arrayByAddingObject:(id)object atIndex:(NSInteger)index;

- (NSArray *)arrayByRemovingObject:(id)object;
- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)array;

+ (NSArray *)arrayWithArrays:(NSArray *)firstArray, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)containsArray:(NSArray *)array;
- (NSArray *)filteredArrayWithBlock:(BOOL(^)(id obj))block;
- (NSArray *)transformArrayWithBlock:(id(^)(id obj))block;

@end
