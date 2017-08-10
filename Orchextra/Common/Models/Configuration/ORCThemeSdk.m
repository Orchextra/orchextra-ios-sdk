//
//  ORCConfigData.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCThemeSdk.h"
#import "NSBundle+ORCBundle.h"
#import <GIGLibrary/UIColor+GIGExtension.h>
#import <GIGLibrary/NSDictionary+GIGJSON.h>

NSString * const ORCPrimaryColorKey = @"primaryColor";
NSString * const ORCSecondaryColorKey = @"secondaryColor";

@interface ORCThemeSdk ()

@property (assign, nonatomic) BOOL isFontInstalled;

@end

@implementation ORCThemeSdk

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        if (json && ![json[@"primaryColor"] isKindOfClass:[NSNull class]])
        {
            _primaryColor = [UIColor colorFromHexString:json[@"primaryColor"]];
        }
        if (![json[@"secondaryColor"] isKindOfClass:[NSNull class]])
        {
            _secondaryColor = [UIColor colorFromHexString:json[@"secondaryColor"]];
        }
    }
    return self;
}

#pragma mark - CODING

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _primaryColor = [aDecoder decodeObjectForKey:ORCPrimaryColorKey];
        _secondaryColor = [aDecoder decodeObjectForKey:ORCSecondaryColorKey];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_primaryColor forKey:ORCPrimaryColorKey];
    [aCoder encodeObject:_secondaryColor forKey:ORCSecondaryColorKey];
}


@end
