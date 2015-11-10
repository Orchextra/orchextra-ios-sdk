//
//  ORCDataStorage.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCStorage.h"
#import "ORCLocationStorage.h"
#import "ORCFormatterParameters.h"
#import "ORCTriggerRegion.h"
#import "ORCUser.h"

#import "NSUserDefaults+ORCGIGArchive.h"

NSString * const ORCApiKey = @"ORCApiKey";
NSString * const ORCApiSecret = @"ORCApiSecret";
NSString * const ORCUserKey = @"ORCUserKey";
NSString * const ORCConfigDataKey = @"ORCConfigDataKey";
NSString * const ORCRequestWaitTimeKey = @"ORCRequestWaitTimeKey";
NSString * const ORCGIGURLManagerApiKey = @"ORCGIGURLManagerApiKey";
NSString * const ORCGIGURLManagerApiSecret = @"ORCGIGURLManagerApiSecret";
NSString * const ORCEnvironment = @"ORCEnvironment";

NSString * const ORCGIGURLManagerClientTokenKey = @"ORCGIGURLManagerClientTokenKey";
NSString * const ORCGIGURLManagerAccessTokenKey = @"ORCGIGURLManagerAccessTokenKey";

NSString * const ORCVuforiaConfigDetails = @"ORCVuforiaConfigDetails";

@interface ORCStorage()

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) ORCLocationStorage *locationStorage;

@end

@implementation ORCStorage

- (instancetype)init
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ORCLocationStorage *locationStorage = [[ORCLocationStorage alloc] init];

    return [self initWithUserDefaults:userDefaults locationStorage:locationStorage];
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
                     locationStorage:(ORCLocationStorage *)locationStorage
{
    self = [super init];
    
    if (self)
    {
        _userDefaults = userDefaults;
        _locationStorage = locationStorage;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)storeApiKey:(NSString *)apiKey
{

    [self.userDefaults setValue:apiKey forKey:ORCApiKey];
    [self.userDefaults synchronize];
}

- (NSString *)loadApiKey
{
    return [self.userDefaults valueForKey:ORCApiKey];
}

- (void)storeApiSecret:(NSString *)apiSecret
{
    [self.userDefaults setValue:apiSecret forKey:ORCApiSecret];
    [self.userDefaults synchronize];
}

- (NSString *)loadApiSecret
{
    return [self.userDefaults valueForKey:ORCApiSecret];
}

- (void)storeUserData:(ORCUser *)user
{
    [self.userDefaults archiveObject:user forKey:ORCUserKey];
    [self.userDefaults synchronize];
}

- (ORCUser *)loadCurrentUserData
{
    return [self.userDefaults unarchiveObjectForKey:ORCUserKey];
}

- (void)storeThemeSdk:(ORCThemeSdk *)theme
{
    [self.userDefaults archiveObject:theme forKey:ORCConfigDataKey];
    [self.userDefaults synchronize];
}

- (ORCThemeSdk *)loadThemeSdk
{
    return [self.userDefaults unarchiveObjectForKey:ORCConfigDataKey];
}

- (void)storeRequestWaitTime:(NSInteger)requestWaitTime
{
    [self.userDefaults setInteger:requestWaitTime forKey:ORCRequestWaitTimeKey];
    [self.userDefaults synchronize];
}

- (NSInteger)loadRequestWaitTime
{
    return [self.userDefaults integerForKey:ORCRequestWaitTimeKey];
}

- (NSString *)loadURLEnvironment
{
    return [self.userDefaults valueForKey:ORCEnvironment];
}

- (void)storeURLEnvironment:(NSString *)environment
{
    [self.userDefaults setValue:environment forKey:ORCEnvironment];
    [self.userDefaults synchronize];
}
#pragma mark - PUBLIC (Authentication)

- (NSString *)loadAccessToken
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerAccessTokenKey];
}

- (void)storeAcessToken:(NSString *)accessToken
{
    [self.userDefaults archiveObject:accessToken forKey:ORCGIGURLManagerAccessTokenKey];
    [self.userDefaults synchronize];
}

- (NSString *)loadClientToken
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerClientTokenKey];
}

- (void)storeClientToken:(NSString *)clientToken
{
    [self.userDefaults archiveObject:clientToken forKey:ORCGIGURLManagerClientTokenKey];
    [self.userDefaults synchronize];
}

- (ORCVuforiaConfig *)loadVuforiaConfig
{
    return [self.userDefaults unarchiveObjectForKey:ORCVuforiaConfigDetails];

}
- (void)storeVuforiaConfig:(ORCVuforiaConfig *)vuforiaConfig
{
    [self.userDefaults archiveObject:vuforiaConfig forKey:ORCVuforiaConfigDetails];
    [self.userDefaults synchronize];
}

- (NSArray *)loadBeacons
{
    NSArray *regions = [self.locationStorage loadRegions];
    NSMutableArray *beacons = [[NSMutableArray alloc] init];
    
    for (ORCTriggerRegion *region in regions)
    {
        if([region.type isEqualToString:ORCTypeBeacon])
        {
            [beacons addObject:region];
        }
    }
    
    return beacons;
}

- (NSArray *)loadGeofences
{
    NSArray *regions = [self.locationStorage loadRegions];
    NSMutableArray *geofences = [[NSMutableArray alloc] init];
    
    for (ORCTriggerRegion *region in regions)
    {
        if([region.type isEqualToString:ORCTypeGeofence])
        {
            [geofences addObject:region];
        }
    }
    
    return geofences;
}

@end
