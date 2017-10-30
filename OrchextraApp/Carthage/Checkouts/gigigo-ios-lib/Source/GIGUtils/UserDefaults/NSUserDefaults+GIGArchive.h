//
//  NSUserDefaults+GIGArchive.h
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults (GIGArchive)

- (void)archiveObjects:(NSArray *)objects forKey:(NSString *)key;
- (void)archiveObject:(id)object forKey:(NSString *)key;
- (id)unarchiveObjectsForKey:(NSString *)key;
- (id)unarchiveObjectForKey:(NSString *)key;

@end
