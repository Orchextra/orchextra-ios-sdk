//
//  GIGCharactersValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGCharactersValidator.h"


@interface GIGCharactersValidator ()

@property (strong, nonatomic) NSCharacterSet *characterSet;

@end


@implementation GIGCharactersValidator

- (instancetype)initWithCharacters:(NSString *)characters
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:characters];
    
    return [self initWithCharacterSet:characterSet];
}

- (instancetype)initWithCharacterSet:(NSCharacterSet *)characterSet
{
    self = [super init];
    if (self)
    {
        self.characterSet = [characterSet invertedSet];
    }
    return self;
}

#pragma mark - OVERRIDE (GIGValidator)

- (BOOL)validate:(NSString *)value error:(NSError *__autoreleasing *)error
{
    if (![super validate:value error:error]) return NO;
    if (value.length == 0 && !self.mandatory) return YES;
    
    NSRange range = [value rangeOfCharacterFromSet:self.characterSet];
    
    return (range.location == NSNotFound);
}

@end
