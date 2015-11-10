//
//  ORCConfigurationSdk.m
//  Orchestra
//
//  Created by Judith Medina on 7/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCUser.h"
#import "ORCConfigurationInteractor.h"


NSString * const ORCCrmIdKey = @"ORCCrmId";
NSString * const ORCBirthdayKey = @"ORCBirthday";
NSString * const ORCGenderKey = @"ORCGender";
NSString * const ORCTagsKey = @"ORCTags";
NSString * const ORCDeviceTokenKey = @"ORCDeviceToken";

@interface ORCUser ()

@property (strong, nonatomic) NSString *genderString;
@property (strong, nonatomic) ORCConfigurationInteractor *interactor;

@end

@implementation ORCUser


#pragma mark - NSCODING

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _interactor = [[ORCConfigurationInteractor alloc] init];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _crmID      = [aDecoder decodeObjectForKey:ORCCrmIdKey];
        _birthday   = [aDecoder decodeObjectForKey:ORCBirthdayKey];
        _tags       = [aDecoder decodeObjectForKey:ORCTagsKey];
        _deviceToken = [aDecoder decodeObjectForKey:ORCDeviceTokenKey];
        _genderString = [aDecoder decodeObjectForKey:ORCGenderKey];

    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_crmID forKey:ORCCrmIdKey];
    [aCoder encodeObject:_birthday forKey:ORCBirthdayKey];
    [aCoder encodeObject:_tags forKey:ORCTagsKey];
    [aCoder encodeObject:_deviceToken forKey:ORCDeviceTokenKey];
    [aCoder encodeObject:_genderString forKey:ORCGenderKey];
}

#pragma mark - PUBLIC

- (NSString *)birthdayFormatted
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [dateFormatter stringFromDate:self.birthday];
    return dateString;
}

- (void)setGenderUser:(ORCUserGender)gender
{
    switch (gender) {
        case ORCGenderFemale:
            self.genderString = @"f";
            break;
        case ORCGenderMale:
            self.genderString = @"m";
            break;
        default:
            self.genderString = @"m";
            break;
    }
}

- (NSString *)genderUser
{
    switch (self.gender) {
        case ORCGenderFemale:
            self.genderString = @"f";
            break;
        case ORCGenderMale:
            self.genderString = @"m";
            break;
        default:
            self.genderString = @"m";
            break;
    }
    
    return self.genderString;
}

- (BOOL)isSameUser:(ORCUser *)user
{
    if ([user.crmID isEqualToString:self.crmID] ||
        [user.birthday isEqualToDate:self.birthday] ||
        [user.tags isEqualToArray:self.tags] ||
        [user.deviceToken isEqualToString:self.deviceToken] ||
        [[user genderUser] isEqualToString:[self genderUser]])
    {
        return YES;
    }
    
    return NO;
}

- (void)saveUser
{
    [self.interactor saveUserData:self];
}

+ (ORCUser *)currentUser
{
    ORCConfigurationInteractor *interactor = [[ORCConfigurationInteractor alloc] init];
    
    if ([interactor currentUser])
    {
        return [interactor currentUser];
    }
    else
    {
        return [[[self class] alloc] init];
    }
}

+ (ORCUser *)user
{
    ORCConfigurationInteractor *interactor = [[ORCConfigurationInteractor alloc] init];
    return [interactor currentUser];
}

@end
