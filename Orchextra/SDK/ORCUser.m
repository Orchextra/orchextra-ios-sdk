//
//  ORCUser.m
//  Orchestra
//
//  Created by Judith Medina on 7/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCUser.h"


NSString * const ORCCrmIdKey = @"ORCCrmId";
NSString * const ORCBirthdayKey = @"ORCBirthday";
NSString * const ORCGenderKey = @"ORCGender";
NSString * const ORCTagsKey = @"ORCTags";
NSString * const ORCDeviceTokenKey = @"ORCDeviceToken";


@implementation ORCUser

#pragma mark - NSCODING

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _crmID      = [aDecoder decodeObjectForKey:ORCCrmIdKey];
        _birthday   = [aDecoder decodeObjectForKey:ORCBirthdayKey];
        _tags       = [aDecoder decodeObjectForKey:ORCTagsKey];
        _deviceToken = [aDecoder decodeObjectForKey:ORCDeviceTokenKey];
        
        NSNumber *genderNumber = [aDecoder decodeObjectForKey:ORCGenderKey];
        _gender = [self genderUser:genderNumber];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_crmID forKey:ORCCrmIdKey];
    [aCoder encodeObject:_birthday forKey:ORCBirthdayKey];
    [aCoder encodeObject:_tags forKey:ORCTagsKey];
    [aCoder encodeObject:_deviceToken forKey:ORCDeviceTokenKey];
    [aCoder encodeObject:@(_gender) forKey:ORCGenderKey];
}

#pragma mark - PUBLIC

- (BOOL)isSameUser:(ORCUser *)user
{
    if ([self equalCRM:user.crmID] &&
        [self equalBirthday:user.birthday] &&
        [self equalTags:user.tags] &&
        [self equalDeviceToken:user.deviceToken] &&
        [self equalGender:user.gender])
    {
        return YES;
    }

    return NO;
}

- (BOOL)crmHasChanged:(ORCUser *)user
{
    if([self equalCRM:user.crmID])
    {
        return NO;
    }
    return YES;
}

#pragma mark - PRIVATE

- (ORCUserGender)genderUser:(NSNumber *)genderNumber
{
    if ([genderNumber integerValue] == 0)
    {
        return ORCGenderNone;
    }
    else if ([genderNumber integerValue] == 1)
    {
        return ORCGenderFemale;
    }
    else
    {
        return ORCGenderMale;
    }
}

- (BOOL)equalCRM:(NSString *)crm
{
    if (crm)
    {
        return [crm isEqualToString:self.crmID];
    }
    else
    {
        return (self.crmID == nil);
    }
}

- (BOOL)equalBirthday:(NSDate *)birthday
{
    if (birthday)
    {
        return [birthday isEqualToDate:self.birthday];
    }
    else
    {
        return (self.birthday == nil);
    }
}

- (BOOL)equalTags:(NSArray *)tags
{
    if (tags)
    {
        return [tags isEqualToArray:self.tags];
    }
    else
    {
        return (self.tags == nil);
    }
}

- (BOOL)equalDeviceToken:(NSString *)deviceToken
{
    if (deviceToken)
    {
        return [deviceToken isEqualToString:self.deviceToken];
    }
    else
    {
        return (self.deviceToken == nil);
    }
}

- (BOOL)equalGender:(ORCUserGender)gender
{
    return (gender == self.gender);
}

@end
