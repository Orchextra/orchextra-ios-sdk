//
//  GIGFormField.m
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGFormField.h"

#import "GIGValidator.h"


@implementation GIGFormField

- (BOOL)validate
{
    if (self.validator == nil)
    {
        return YES;
    }
    
    return [self.validator validate:self.fieldValue error:nil];
}

@end
