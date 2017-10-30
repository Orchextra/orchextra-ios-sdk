//
//  NSString+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 28/05/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (GIGExtension)

- (NSString *)stringByCapitalizingFirstLetter;
- (NSString *)stringByAddingPrefix:(NSString *)prefix toLength:(NSInteger)length;
- (NSString *)stringByRepeatingTimes:(NSInteger)times;

@end
