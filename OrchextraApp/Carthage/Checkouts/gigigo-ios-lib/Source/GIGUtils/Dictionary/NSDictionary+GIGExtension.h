//
//  NSDictionary+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 08/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (GIGExtension)

- (BOOL)containsDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryForKeys:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;
- (NSDictionary *)dictionaryForKeysArray:(NSArray *)keys;

- (NSDictionary *)dictionaryAddingEntriesFromDictionary:(NSDictionary *)dictionary;

@end
