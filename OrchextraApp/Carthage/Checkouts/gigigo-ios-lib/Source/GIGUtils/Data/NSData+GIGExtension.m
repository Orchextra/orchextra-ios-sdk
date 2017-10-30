//
//  NSData+GIGExtension.m
//  GIGLibrary
//
//  Created by Sergio Baró on 04/11/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "NSData+GIGExtension.h"

#import "GIGRandom.h"


@implementation NSData (GIGExtension)

+ (NSData *)randomData
{
    NSInteger numberOfBytes = gig_random_int(1, 256);
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:numberOfBytes];
    
    for (NSInteger i = 0; i < numberOfBytes; i++)
    {
        u_int32_t randomBits = arc4random();
        [data appendBytes:(void*)&randomBits length:4];
    }
    
    return [data copy];
}

@end
