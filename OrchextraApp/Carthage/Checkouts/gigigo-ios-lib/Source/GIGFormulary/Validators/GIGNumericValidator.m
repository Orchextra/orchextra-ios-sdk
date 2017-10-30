//
//  GIGNumericValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGNumericValidator.h"


@implementation GIGNumericValidator

- (instancetype)init
{
    return [super initWithRegexpPattern:@"^\\d+$"];
}

@end
