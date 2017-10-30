//
//  GIGRandom.h
//  giglibrary
//
//  Created by Sergio Baró on 08/05/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#ifndef GIGLibrary_GIGRandom_h
#define GIGLibrary_GIGRandom_h

#import <Foundation/Foundation.h>
#import <stdlib.h>

#define ARC4RANDOM_MAX 0x100000000

static int const GIGASCIIFirstPrintableCharacter = 0x20;
static int const GIGASCIILastPrintableCharacter = 0x7E;
static int const GIGASCIIFirstDigitCharacter = 0x30;
static int const GIGASCIILastDigitCharacter = 0x39;


__unused static BOOL gig_random_bool()
{
    return (arc4random_uniform(2) > 0);
}

__unused static float gig_random_float(float min, float max)
{
    return ((float)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
}

__unused static int gig_random_int(int min, int max)
{
    return (arc4random() % (max - min + 1)) + min;
}

__unused static NSString* gig_random_string(int length)
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (int i = 0; i < length; i++)
    {
        char character = gig_random_int(GIGASCIIFirstPrintableCharacter,GIGASCIILastPrintableCharacter);
        [string appendFormat:@"%c", character];
    }
    
    return [string copy];
}

__unused static NSString* gig_random_number_string(int length)
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (int i = 0; i < length; i++)
    {
        char character = gig_random_int(GIGASCIIFirstDigitCharacter,GIGASCIILastDigitCharacter);
        [string appendFormat:@"%c", character];
    }
    
    return [string copy];
}

#endif
