//
//  NSInvocation+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 29/10/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSInvocation (GIGExtension)

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action;
+ (instancetype)invocationWithTarget:(id)target action:(SEL)action retain:(BOOL)retain;

@end
