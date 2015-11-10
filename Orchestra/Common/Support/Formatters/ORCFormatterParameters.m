//
//  ORCDeviceStorage.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCFormatterParameters.h"
#import "ORCDevice.h"
#import "ORCUser.h"
#import "ORCLocationStorage.h"
#import "ORCStorage.h"

@interface ORCFormatterParameters()

@property (strong, nonatomic) ORCDevice *device;
@property (strong, nonatomic) ORCLocationStorage *locationStorage;
@property (strong, nonatomic) ORCStorage *storage;

@end

@implementation ORCFormatterParameters

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        _device = [[ORCDevice alloc] init];
        _locationStorage = [[ORCLocationStorage alloc] init];
        _storage = [[ORCStorage alloc] init];
    }
    
    return self;
    
}


#pragma mark - PUBLIC

- (NSDictionary *)formatterParameteresDevice
{
    ORCUser *currentUser = [self.storage loadCurrentUserData];
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
    CLLocation *lastLocation = [self.locationStorage loadLastLocation];
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
    return [self formatterUserValues:userData];
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
    
    if (user.crmID)
    {
        [userValues setValue:user.crmID forKey:@"crmId"];
    }
    
    if (user.birthday)
    {
        [userValues setValue:[user birthdayFormatted] forKey:@"birthDate"];
    }
    
    if ([user genderUser])
    {
        [userValues setValue:[user genderUser] forKey:@"gender"];
    }
    
    if (user.tags && user.tags.count > 0)
    {
        [userValues setValue:user.tags forKey:@"keywords"];
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
    
    CLPlacemark *lastPlacemark = [self.locationStorage loadLastPlacemark];
    CLLocation *lastLocation = [self.locationStorage loadLastLocation];

    NSDictionary *userLocationValues = [self formattedUserLocation:lastLocation];
    NSDictionary *formattedAddress = [self formattedPlacemark:lastPlacemark];
    

    if (userLocationValues)
    {
        [locationValues addEntriesFromDictionary:userLocationValues];
    }
    
    if (formattedAddress)
    {
        [locationValues addEntriesFromDictionary:formattedAddress];
    }
    
    if (locationValues.count == 0) return nil;
    
    return locationValues;
}


@end
