//
//  NSError+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 09/04/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "NSError+GIGExtension.h"


@implementation NSError (GIGExtension)

+ (instancetype)errorWithMessage:(NSString *)message
{
    return [self errorWithCode:0 message:message];
}

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message
{
    return [self errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:code message:message];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message
{
    NSDictionary *userInfo = nil;
    if (message)
    {
        userInfo = @{NSLocalizedDescriptionKey:message};
    }
    
    return [self errorWithDomain:domain code:code userInfo:userInfo];
}

@end
