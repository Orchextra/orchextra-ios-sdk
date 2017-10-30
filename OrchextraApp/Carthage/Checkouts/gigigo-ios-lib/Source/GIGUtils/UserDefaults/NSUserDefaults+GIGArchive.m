//
//  NSUserDefaults+GIGArchive.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSUserDefaults+GIGArchive.h"

@implementation NSUserDefaults (GIGArchive)

- (void)archiveObjects:(NSArray *)objects forKey:(NSString *)key
{
    NSMutableArray *objectsArchived = [[NSMutableArray alloc] init];
    
    for (id object in objects)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        if (data) [objectsArchived addObject:data];
    }
    
    [self setObject:objectsArchived forKey:key];
}

- (void)archiveObject:(id)object forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self setObject:data forKey:key];
}

- (NSArray *)unarchiveObjectsForKey:(NSString *)key
{
    NSMutableArray *objectsUnarchived = [[NSMutableArray alloc] init];
    NSArray *objectsArchived = [self objectForKey:key];
    
    for (NSData *data in objectsArchived)
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (object) [objectsUnarchived addObject:object];
    }
    
    return objectsUnarchived;
}

- (id)unarchiveObjectForKey:(NSString *)key
{
    NSData *data = [self objectForKey:key];
    if (data == nil) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
