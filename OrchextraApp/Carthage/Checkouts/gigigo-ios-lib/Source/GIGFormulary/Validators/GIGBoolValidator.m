//
//  GIGBoolValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 30/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGBoolValidator.h"


@implementation GIGBoolValidator

- (BOOL)validate:(id)value error:(NSError *__autoreleasing *)error
{
    if (![super validate:value error:nil]) return NO;
    if ([value isKindOfClass:[NSNumber class]]) return [value boolValue];
    
    return NO;
}

@end
