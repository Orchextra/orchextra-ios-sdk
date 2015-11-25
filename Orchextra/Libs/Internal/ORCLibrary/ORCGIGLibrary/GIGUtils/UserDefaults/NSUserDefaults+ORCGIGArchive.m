//
//  NSUserDefaults+GIGArchive.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "NSUserDefaults+ORCGIGArchive.h"


@implementation NSUserDefaults (ORCGIGArchive)

- (void)archiveObject:(id)object forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self setObject:data forKey:key];
}

- (id)unarchiveObjectForKey:(NSString *)key
{
    NSData *data = [self objectForKey:key];
    if (data == nil) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
