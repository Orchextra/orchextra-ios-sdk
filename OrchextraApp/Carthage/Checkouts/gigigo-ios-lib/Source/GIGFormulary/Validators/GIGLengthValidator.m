//
//  GIGLengthValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGLengthValidator.h"


@interface GIGLengthValidator ()

@property (assign, nonatomic, readwrite) NSInteger minLength;
@property (assign, nonatomic, readwrite) NSInteger maxLength;

@end


@implementation GIGLengthValidator

- (instancetype)initWithMinLength:(NSInteger)minLength
{
    return [self initWithMinLength:minLength maxLength:0];
}

- (instancetype)initWithMaxLength:(NSInteger)maxLength
{
    return [self initWithMinLength:0 maxLength:maxLength];
}

- (instancetype)initWithMinLength:(NSInteger)minLength maxLength:(NSInteger)maxLength
{
    self = [super init];
    if (self)
    {
        _minLength = minLength;
        _maxLength = maxLength;
    }
    return self;
}

#pragma mark - OVERRIDE (GIGValidator)

- (BOOL)validate:(NSString *)value error:(NSError *__autoreleasing *)error
{
    if (![super validate:value error:error]) return NO;
    if (value.length == 0 && !self.mandatory) return YES;
    
    if (self.maxLength == 0)
    {
        return (value.length >= self.minLength);
    }
    
    return (value.length >= self.minLength && value.length <= self.maxLength);
}

@end
