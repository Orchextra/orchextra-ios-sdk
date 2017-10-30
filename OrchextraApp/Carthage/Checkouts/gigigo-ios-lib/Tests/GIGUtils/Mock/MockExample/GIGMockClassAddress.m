//
//  GIGMockClassAddress.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMockClassAddress.h"

@implementation GIGMockClassAddress

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.street = @"Calle doctor Zamenhoft";
        self.number = 36;
        self.city = @"";
        //self.country  Null
    }
    return self;
}

@end
