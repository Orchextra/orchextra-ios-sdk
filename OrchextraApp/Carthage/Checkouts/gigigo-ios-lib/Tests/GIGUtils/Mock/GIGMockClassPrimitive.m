//
//  GIGMockClassPrimitive.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMockClassPrimitive.h"

@implementation GIGMockClassPrimitive

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.intPrimitive = INT_MAX;
        self.longPrimitive = LONG_MAX;
        self.floatPrimitive = 123.432f;
        self.doublePrimitive = -21.09;
        self.boolPrimitive = YES;
        self.charPrimitive = 'a';
    }
    return self;
}

@end