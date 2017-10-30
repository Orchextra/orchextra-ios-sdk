//
//  GIGMockClassUser.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMockClassUser.h"

@implementation GIGMockClassUser

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.name = @"Edu";
        self.lastName = @"";
        //self.secondLastName  Null
        self.age = 20;
        
       self.address = [[GIGMockClassAddress alloc] init];
    }
    return self;
}

@end