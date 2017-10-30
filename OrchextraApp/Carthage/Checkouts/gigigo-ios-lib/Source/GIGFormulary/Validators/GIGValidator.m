//
//  GIGValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGValidator.h"


@implementation GIGValidator

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mandatory = YES;
    }
    return self;
}

#pragma mark - PUBLIC

- (BOOL)validate:(id)value error:(NSError * __autoreleasing *)error
{
    if (value == nil && self.mandatory)
    {
        return NO;
    }
    
    return YES;
}

@end
