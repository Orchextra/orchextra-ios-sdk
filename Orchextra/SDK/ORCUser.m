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

@end

@implementation ORCUser

#pragma mark - INIT

- (instancetype)initWithConfigurationInteractor:(ORCConfigurationInteractor *)interactor
{
    self = [super init];
    
    if (self)
    {
        _interactor = interactor;
        _gender = ORCGenderMale;
    }
    
    return self;
}

- (instancetype)init
{
    ORCConfigurationInteractor *interactor = [[ORCConfigurationInteractor alloc] init];
    return [self initWithConfigurationInteractor:interactor];
}

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
    if ([user.crmID isEqualToString:self.crmID] &&
        [user.birthday isEqualToDate:self.birthday] &&
        [user.tags isEqualToArray:self.tags] &&
        [user.deviceToken isEqualToString:self.deviceToken] &&
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
    ORCUser *user = [[self alloc] init];
    
    if ([user.interactor currentUser])
    {
        ORCUser *tmpUser = [user.interactor currentUser];
        tmpUser.interactor = user.interactor;
        return tmpUser;
    }
    else
    {
        return user;
    }
}

@end
