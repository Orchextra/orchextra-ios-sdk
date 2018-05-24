//
//  ORCBusinessUnit.m
//  Orchextra
//
//  Created by Carlos Vicente on 17/6/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCBusinessUnit.h"

NSString * const ORCBusinessUnitName = @"ORCBusinessUnitName";

@implementation ORCBusinessUnit

#pragma mark - INIT

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self)
    {
        self.name = name;
    }
    return self;
}

#pragma mark - NSCODING

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aDecoder decodeObjectForKey:ORCBusinessUnitName];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:ORCBusinessUnitName];
}

@end
