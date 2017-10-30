//
//  GIGMultiValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGMultiValidator.h"


@interface GIGMultiValidator ()

@property (strong, nonatomic) NSArray *validators;

@end


@implementation GIGMultiValidator

- (instancetype)initWithValidators:(NSArray *)validators
{
    self = [super init];
    if (self)
    {
        _validators = validators;
    }
    return self;
}

#pragma mark - OVERRIDE (GIGMultiValidator)

- (BOOL)validate:(id)value error:(NSError *__autoreleasing *)error
{
    if (![super validate:value error:error]) return NO;
    
    BOOL result = YES;
    
    for (GIGValidator *validator in self.validators)
    {
        result = [validator validate:value error:error];
        
        if (!result) return NO;
    }
    
    return result;
}

@end
