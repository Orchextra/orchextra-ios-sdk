//
//  ORCDeviceStorage.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCFormatterParameters.h"
#import "ORCBusinessUnit.h"
#import "ORCCustomField.h"
#import "ORCDevice.h"
#import "ORCUser.h"
#import "ORCTag.h"
#import "ORCUserLocationPersister.h"
#import "ORCSettingsPersister.h"

@interface ORCFormatterParameters()

@property (strong, nonatomic) ORCDevice *device;
@property (strong, nonatomic) ORCUserLocationPersister *userLocationPersister;
@property (strong, nonatomic) ORCSettingsPersister *settingsPersister;

@end

@implementation ORCFormatterParameters

- (instancetype) init
{
    ORCDevice *device = [[ORCDevice alloc] init];
    ORCUserLocationPersister *userLocationPersister = [[ORCUserLocationPersister alloc] init];
    ORCSettingsPersister *settingsPersister = [[ORCSettingsPersister alloc] init];
    
    return [self initWithDevice:device userLocationPersister:userLocationPersister settingsPersister:settingsPersister];
}

- (instancetype)initWithDevice:(ORCDevice *)device
         userLocationPersister:(ORCUserLocationPersister *)userLocationPersister
             settingsPersister:(ORCSettingsPersister *)settingsPersister
{
    self = [super init];
    
    if (self)
    {
        _device = device;
        _userLocationPersister = userLocationPersister;
        _settingsPersister = settingsPersister;
    }
    
    return self;
    
}

#pragma mark - PUBLIC

- (NSDictionary *)formatterParameteresDevice
{
    ORCUser *currentUser = [self.settingsPersister loadCurrentUser];
    NSDictionary *deviceValues = [self formatterDeviceValues];
    NSDictionary *appValues = [self formatterAppValues];
    NSDictionary *userValues= [self formatterUserValues:currentUser];
    NSDictionary *tokenValues = [self formatterTokenValue:currentUser];
    NSDictionary *locationValues = [self formatterLocationValues];
    
    NSMutableDictionary *values = [NSMutableDictionary new];
    
    if (deviceValues)
    {
        [values setValue:deviceValues forKey:@"device"];
    }
    
    if (appValues)
    {
        [values setValue:appValues forKey:@"app"];
    }
    
    if (userValues)
    {
        [values setValue:userValues forKey:@"crm"];
    }
    
    if (tokenValues)
    {
        [values setValue:tokenValues forKey:@"notificationPush"];
    }

    if (locationValues)
    {
        [values setValue:locationValues forKey:@"geoLocation"];
    }
    
    return values;
}

- (NSDictionary *)formattedCurrentUserLocation
{
    CLLocation *lastLocation = [self.userLocationPersister loadLastLocation];
    NSDictionary *dicPoint = @{   @"lat" : [NSNumber numberWithDouble:lastLocation.coordinate.latitude],
                                  @"lng" : [NSNumber numberWithDouble:lastLocation.coordinate.longitude]};
    
    return dicPoint;
}


- (NSDictionary *)formattedUserLocation:(CLLocation *)userLocation;
{
    NSDictionary *dicPoint = @{   @"lat" : [NSNumber numberWithDouble:userLocation.coordinate.latitude],
                                  @"lng" : [NSNumber numberWithDouble:userLocation.coordinate.longitude]};
    
    if (dicPoint)
    {
        return @{@"point" : dicPoint};
    }
    
    return nil;
}

- (NSDictionary *)formattedPlacemark:(CLPlacemark *)placemark
{
    NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
    if (placemark.country)
    {
        [address addEntriesFromDictionary:@{@"country" : placemark.country}];
    }
    if (placemark.ISOcountryCode)
    {
        [address addEntriesFromDictionary:@{@"countryCode" : placemark.ISOcountryCode}];
    }
    if (placemark.locality)
    {
        [address addEntriesFromDictionary:@{@"locality" : placemark.locality}];
    }
    if (placemark.postalCode)
    {
        [address addEntriesFromDictionary:@{@"zip" : placemark.postalCode}];
    }
    if (placemark.thoroughfare) {
        [address addEntriesFromDictionary:@{@"street" : placemark.thoroughfare}];
    }

    return address;
}

- (NSDictionary *)formattedUserData:(ORCUser *)userData
{
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    
    NSDictionary *userValues= [self formatterUserValues:userData];
    NSDictionary *tokenValues = [self formatterTokenValue:userData];
    
    if (userValues)
    {
        [values setValue:userValues forKey:@"crm"];
    }
    
    if (tokenValues)
    {
        [values setValue:tokenValues forKey:@"notificationPush"];
    }
    
    return values;
}

- (NSDictionary *)formattedCustomFields
{
    NSMutableDictionary *formattedCustomFields = [[NSMutableDictionary alloc] init];
    NSArray <ORCCustomField *> *customFieldList = [self.settingsPersister loadCustomFields];
    
    for (ORCCustomField *customField in customFieldList)
    {
        if (customField.value != nil)
        {
            NSDictionary *customFieldDict = [NSDictionary dictionaryWithObject:customField.value
                                                                        forKey:customField.key];
            
            [formattedCustomFields addEntriesFromDictionary:customFieldDict];
        }
    }
    
    return formattedCustomFields;
}

#pragma mark - PRIVATE

- (NSDictionary *)formatterDeviceValues
{
    NSMutableDictionary *deviceValues = [NSMutableDictionary new];
    
    if (self.device.versionIOS)
    {
        [deviceValues setValue:self.device.versionIOS forKey:@"osVersion"];
    }
    
    if (self.device.handset)
    {
        [deviceValues setValue:self.device.handset forKey:@"handset"];
    }
    
    if (self.device.language)
    {
        [deviceValues setValue:self.device.language forKey:@"languaje"];
    }
    if (self.device.deviceOS)
    {
        [deviceValues setValue:self.device.deviceOS forKey:@"os"];
    }
    
    if (self.device.timeZone)
    {
        [deviceValues setValue:self.device.timeZone forKey:@"timeZone"];
    }
    
    if (self.device.advertisingID)
    {
        [deviceValues setValue:self.device.advertisingID forKey:@"advertiserId"];
    }
    if (self.device.vendorID)
    {
        [deviceValues setValue:self.device.vendorID forKey:@"vendorId"];
    }
    
    NSArray <ORCTag *> *deviceTags = [self.settingsPersister loadDeviceTags];
    [deviceValues setValue:[self tagsFormatted:deviceTags] forKey:@"tags"];
    
    NSArray <ORCBusinessUnit *> *deviceBusinessUnits = [self.settingsPersister loadDeviceBusinessUnits];
    [deviceValues setValue:[self tagsFormatted:deviceBusinessUnits] forKey:@"businessUnits"];
    
    if (deviceValues.count == 0) return nil;
    
    return deviceValues;
}

- (NSDictionary *)formatterAppValues
{
    NSMutableDictionary *appValues = [NSMutableDictionary new];
     
    if (self.device.appVersion)
    {
        [appValues setValue:self.device.appVersion forKey:@"appVersion"];
    }
    
    if (self.device.buildVersion)
    {
        [appValues setValue:self.device.buildVersion forKey:@"buildVersion"];
    }
    
    if (self.device.bundleId)
    {
        [appValues setValue:self.device.bundleId forKey:@"bundleId"];
    }
    
    if (appValues.count == 0) return nil;
    
    return appValues;
}

- (NSDictionary *)formatterUserValues:(ORCUser *)user
{
    NSMutableDictionary *userValues = [[NSMutableDictionary alloc] init];
    
    if (user.birthday)
    {
        [userValues setValue:[self birthdayUserFormatted:user.birthday] forKey:@"birthDate"];
    }
    
    if (user.crmID)
    {
        [userValues setValue:user.crmID forKey:@"crmId"];
        
        NSArray *userTags = [self tagsFormatted:[user tags]];
        [userValues setValue:userTags forKey:@"tags"];
        
        NSArray *userBusinessUnits = [self tagsFormatted:[user businessUnits]];
        [userValues setValue:userBusinessUnits forKey:@"businessUnits"];
        
        NSDictionary *customFields = [self formattedCustomFields];
        
        if (customFields)
        {
            [userValues setValue:customFields forKey:@"customFields"];

        }
    }
    
    NSString *genderString = [self convertGenderUsertoString:user.gender];
    
    if (genderString)
    {
        [userValues setValue:genderString forKey:@"gender"];
    }
    
    if (userValues.count == 0) return nil;
    
    return userValues;
}

- (NSDictionary *)formatterTokenValue:(ORCUser *)user
{
    if (user.deviceToken)
    {
        return @{@"token" : user.deviceToken};
    }
    
    return nil;
}

- (NSDictionary *)formatterLocationValues
{
    NSMutableDictionary *locationValues = [[NSMutableDictionary alloc] init];
    
    CLPlacemark *lastPlacemark = [self.userLocationPersister loadLastPlacemark];
    CLLocation *lastLocation = [self.userLocationPersister loadLastLocation];


    if (lastLocation)
    {
        NSDictionary *userLocationValues = [self formattedUserLocation:lastLocation];
        [locationValues addEntriesFromDictionary:userLocationValues];
    }
    
    if (lastPlacemark)
    {
        NSDictionary *formattedAddress = [self formattedPlacemark:lastPlacemark];
        [locationValues addEntriesFromDictionary:formattedAddress];
    }
    
    if (locationValues.count == 0) return nil;
    
    return locationValues;
}

- (NSString *)birthdayUserFormatted:(NSDate *)birthdayDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [dateFormatter stringFromDate:birthdayDate];
    return dateString;
}

- (NSString *)convertGenderUsertoString:(ORCUserGender)gender
{
    switch (gender)
    {
        case ORCGenderFemale:
            return @"f";
        case ORCGenderMale:
            return @"m";
        case ORCGenderNone:
            return nil;
    }
}

- (NSMutableArray <NSString *> *)tagsFormatted:(NSArray <ORCTag *> *)tags
{
    NSMutableArray <NSString *> *tagsFormatted = [[NSMutableArray alloc] init];
    
    for (ORCTag *tag in tags)
    {
        if ([tag isKindOfClass:[ORCTag class]])
        {
            NSString *tagFormatted = [tag tag];
            
            if (tagFormatted)
            {
                [tagsFormatted addObject:tagFormatted];
            }
        }
    }
    
    return tagsFormatted;
}

@end
