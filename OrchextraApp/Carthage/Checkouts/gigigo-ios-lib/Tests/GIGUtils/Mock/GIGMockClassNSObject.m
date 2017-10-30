//
//  GIGMockClassNSObject.m
//  GiGLibrary
//
//  Created by  Eduardo Parada on 6/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGMockClassNSObject.h"

NSString * const GIGStringNSObjectKey   = @"GIGStringNSObjectKey";
NSString * const GIGIntegerNSObjectKey  = @"GIGIntegerNSObjectKey";

@implementation GIGMockClassNSObject

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.stringNSObject     = @"NSstring text";
        self.integerNSObject    = INT_MAX;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        
        _stringNSObject     = [aDecoder decodeObjectForKey:GIGStringNSObjectKey];
        _integerNSObject    = [aDecoder decodeIntegerForKey:GIGIntegerNSObjectKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.stringNSObject forKey:GIGStringNSObjectKey];
    [aCoder encodeInteger:self.integerNSObject forKey:GIGIntegerNSObjectKey];
}

@end