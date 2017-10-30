//
//  GIGStringValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGStringValidator.h"


@implementation GIGStringValidator

- (BOOL)validate:(NSString *)value error:(NSError * __autoreleasing *)error
{
    if (value == nil && self.mandatory)
    {
        return NO;
    }
    else if (value != nil)
    {
        if (![value isKindOfClass:[NSString class]]) return NO;
        if (value.length == 0 && self.mandatory) return NO;
    }
    
    return YES;
}

@end
