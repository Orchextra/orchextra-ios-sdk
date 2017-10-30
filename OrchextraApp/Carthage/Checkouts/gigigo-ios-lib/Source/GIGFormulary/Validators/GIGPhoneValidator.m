
//
//  GIGPhoneValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGPhoneValidator.h"


@implementation GIGPhoneValidator

- (instancetype)init
{
    return [self initWithRegexpPattern:@"^(\\+\\d{1,3})?\\d{9}$"];
}

@end
