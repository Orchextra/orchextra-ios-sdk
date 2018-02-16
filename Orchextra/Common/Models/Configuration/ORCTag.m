//
//  ORCTag.m
//  Orchextra
//
//  Created by Judith Medina on 27/5/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCTag.h"
#import "ORCGIGRegexp.h"

NSString * const ORCTagPrefix = @"ORCTagPrefix";
NSString * const ORCTagName = @"ORCTagName";

@interface ORCTag ()

@property (assign, nonatomic) BOOL hasPrefix;
@property (assign, nonatomic) BOOL hasName;

@end

@implementation ORCTag

#pragma mark - INIT

- (instancetype)initWithPrefix:(NSString *)prefix
{
    self = [super init];
    
    if (self)
    {
        if([self validatePrefix:prefix])
        {
            self.prefix = prefix;
        }
        
        self.hasPrefix = YES;
        self.hasName = NO;
        
    }
    return self;
}

- (instancetype)initWithPrefix:(NSString *)prefix name:(NSString *)name
{
    self = [super init];
    
    if (self)
    {
        if([self validatePrefix:prefix])
        {
            self.prefix = prefix;
        }
        
        if([self validateName:name])
        {
            self.name = name;
        }
        
        self.hasPrefix = YES;
        self.hasName = YES;
    }
    
    return self;
}

#pragma mark - NSCODING

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aDecoder decodeObjectForKey:ORCTagName];
        _prefix = [aDecoder decodeObjectForKey:ORCTagPrefix];
        
        _hasName = _name ? YES : NO;
        _hasPrefix = _prefix ? YES : NO;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:ORCTagName];
    [aCoder encodeObject:_prefix forKey:ORCTagPrefix];
}

#pragma mark - PUBLIC

- (NSString *)tag
{
    NSString *tag = nil;
    
    if (self.hasPrefix && self.prefix && self.hasName && self.name)
    {
        tag = [NSString stringWithFormat:@"%@::%@", self.prefix, self.name];
    }
    else if (self.hasPrefix && self.prefix && !self.hasName)
    {
        tag = [NSString stringWithFormat:@"%@", self.prefix];
    }
    
    return tag;
}

#pragma mark - PRIVATE

/*
 
 Name: (::|\\/|^_|^.{0,1}$)
 
 * Cant use :: (double colon)
 * Cant use / (slash)
 * Cant start with _
 * Must have minimum 2 characters
*/

- (BOOL)validateName:(NSString *)name
{
    NSString *regexString = @"(::|\\/|^_|^.{0,1}$)";

    NSInteger matches = [self matchestTex:name withRegexString:regexString];
    
    if (matches > 0)
    {
        [[ORCLog sharedInstance] logWarning:@"Name does not comply with the rules: %@", name];
        return FALSE;
    }
    return YES;
}

/*
 
Prefix: (::|/|^_(?!(s$|b$))|^[^_].{0}$)

* Cant use :: (double colon)
* Cant use / (slash)
* Cant start with _ except _s|_b
* Must have minimum 2 characters

*/

- (BOOL)validatePrefix:(NSString *)prefix
{
    NSString *regexString = @"(::|/|^_(?!(s$|b$))|^[^_].{0}$)";
    
    NSInteger matches = [self matchestTex:prefix withRegexString:regexString];
    
    if (matches > 0)
    {
        [[ORCLog sharedInstance] logWarning:@"Prefix does not comply with the rules: %@", prefix];
        return NO;
    }
    return YES;
}

- (NSUInteger)matchestTex:(NSString*)text withRegexString:(NSString *)regexString
{
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:0 error:nil];
    
    NSArray *matches = [regexp matchesInString:text
                                       options:kNilOptions
                                         range:NSMakeRange(0, text.length)];
    
    return matches.count;
}

@end
