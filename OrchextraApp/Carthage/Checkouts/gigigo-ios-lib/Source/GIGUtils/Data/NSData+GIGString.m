//
//  NSData+GIGString.m
//  giglibrary
//
//  Created by Sergio Baró on 10/25/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "NSData+GIGString.h"


@implementation NSData (GIGString)

- (NSString *)toStringWithEncoding:(NSStringEncoding)encoding
{
    return [[NSString alloc] initWithData:self encoding:encoding];
}

- (NSString *)toUTF8String
{
    return [self toStringWithEncoding:NSUTF8StringEncoding];
}

- (NSString *)toASCIIString
{
    return [self toStringWithEncoding:NSASCIIStringEncoding];
}

@end
