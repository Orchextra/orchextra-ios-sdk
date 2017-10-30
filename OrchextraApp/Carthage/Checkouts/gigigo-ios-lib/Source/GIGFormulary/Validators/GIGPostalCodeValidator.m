//
//  GIGPostalCodeValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGPostalCodeValidator.h"


@implementation GIGPostalCodeValidator

- (instancetype)init
{
    return [self initWithRegexpPattern:@"^((0?[1-9]\\d{3})|([1-9]\\d{4}))$"];
}

@end
