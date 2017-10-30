//
//  NSInvocation+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 29/10/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "NSInvocation+GIGExtension.h"


@implementation NSInvocation (GIGExtension)

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action
{
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = target;
    invocation.selector = action;
    
    return invocation;
}

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action retain:(BOOL)retain
{
    NSInvocation *invocation = [self invocationWithTarget:target action:action];
    if (retain)
    {
        [invocation retainArguments];
    }
    
    return invocation;
}

@end
