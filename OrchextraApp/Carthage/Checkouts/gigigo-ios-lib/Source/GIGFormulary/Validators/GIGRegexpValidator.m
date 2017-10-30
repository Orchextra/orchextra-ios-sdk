//
//  GIGRegexpValidator.m
//  GiGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGRegexpValidator.h"

#import "GIGRegexp.h"


@interface GIGRegexpValidator ()

@property (strong, nonatomic, readwrite) NSRegularExpression *regexp;

@end


@implementation GIGRegexpValidator

- (instancetype)initWithRegexp:(NSRegularExpression *)regexp
{
    self = [super init];
    if (self)
    {
        _regexp = regexp;
    }
    return self;
}

- (instancetype)initWithRegexpPattern:(NSString *)regexpPattern
{
    self = [super init];
    if (self)
    {
        if (regexpPattern != nil)
        {
            _regexp = [NSRegularExpression regularExpressionWithPattern:regexpPattern];
        }
    }
    return self;
}

#pragma mark - OVERRIDE (GIGValidator)

- (BOOL)validate:(NSString *)value error:(NSError *__autoreleasing *)error
{
    if (![super validate:value error:error]) return NO;
    if (value.length == 0 && !self.mandatory) return YES;
    
    return [self.regexp matchesString:value];
}

@end
