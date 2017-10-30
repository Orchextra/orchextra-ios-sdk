//
//  NSString+GIGSubstring.h
//  giglibrary
//
//  Created by Sergio Baró on 06/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (GIGSubstring)

- (BOOL)isEmpty;

- (BOOL)contains:(NSString *)substring;
- (BOOL)containsSubtring:(NSString *)substring;
- (BOOL)insensitiveContains:(NSString *)substring;
- (BOOL)insensitiveHasPrefix:(NSString *)prefix;

@end
