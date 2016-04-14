//
//  ORCSettingsDataManager.m
//  Orchestra
//
//  Created by Judith Medina on 10/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCSettingsDataManager.h"
#import "ORCUserLocationPersister.h"
#import "ORCSettingsPersister.h"

#import "ORCRegion.h"
#import "ORCVuforiaConfig.h"
#import "ORCThemeSdk.h"
#import "ORCUser.h"
#import "ORCConstants.h"

#import "ORCAppConfigCommunicator.h"
#import "ORCAppConfigResponse.h"



@interface ORCSettingsDataManager()

@property (strong, nonatomic) ORCSettingsPersister *settingsPersister;
@property (strong, nonatomic) ORCUserLocationPersister *locationPersister;

@end

@implementation ORCSettingsDataManager

- (instancetype)init
{
    ORCSettingsPersister *settingsPersister = [[ORCSettingsPersister alloc] init];
    ORCUserLocationPersister *userLocationPersister = [[ORCUserLocationPersister alloc] init];

    return [self initWithSettingsPersister:settingsPersister userLocationPersister:userLocationPersister];
}

- (instancetype)initWithSettingsPersister:(ORCSettingsPersister *)settingsPersister
               userLocationPersister:(ORCUserLocationPersister *)userLocationPersister
{
    self = [super init];
    
    if (self)
    {
        _settingsPersister = settingsPersister;
        _locationPersister = userLocationPersister;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)setEnvironment:(NSString *)environment
{
    [self.settingsPersister storeURLEnvironment:environment];
}

#pragma mark - Orchextra Output Delegate

- (BOOL)isOrchextraRunning
{
    return [self.settingsPersister loadOrchextraState];
}

- (ORCVuforiaConfig *)fetchVuforiaCredentials
{
    return [self.settingsPersister loadVuforiaConfig];
}

- (ORCThemeSdk *)fetchThemeSdk
{
    return [self.settingsPersister loadThemeSdk];
}

- (NSArray *)fetchGeofencesRegistered
{
    return [self fetchRegionsWithType:ORCTypeGeofence];
}

- (NSArray *)fetchBeaconsRegistered
{
    return [self fetchRegionsWithType:ORCTypeBeacon];
}

- (BOOL)extendBackgroundTime:(NSInteger)backgroundTime
{
    BOOL extendedBackgroundTime = YES;
    
    if (backgroundTime > DEFAULT_BACKGROUND_TIME)
    {
        if (backgroundTime <= MAX_BACKGROUND_TIME)
        {
            [self.settingsPersister storeBackgroundTime:backgroundTime];
        }
        else
        {
            extendedBackgroundTime = NO;
            [self.settingsPersister storeBackgroundTime:DEFAULT_BACKGROUND_TIME];
        }
    }
    else
    {
        extendedBackgroundTime = NO;
        [self.settingsPersister storeBackgroundTime:DEFAULT_BACKGROUND_TIME];
    }
    
    [self extendBackgroundTimeInfo:extendedBackgroundTime seconds:backgroundTime];
    return extendedBackgroundTime;
}

#pragma mark - PRIVATE

- (NSArray *)fetchRegionsWithType:(NSString *)type
{
    NSArray *regions = [self loadWithRegionType:type];
    
    NSMutableArray *regionWithType = [[NSMutableArray alloc] init];
    
    for (ORCRegion *region in regions)
    {
        CLRegion *clregion = [region convertToCLRegion];

        if (clregion) [regionWithType addObject:clregion];
    }
    return regionWithType;
}

- (NSArray *)loadWithRegionType:(NSString *)type
{
    NSArray *regions = [self.locationPersister loadRegions];
    
    NSMutableArray *geofences = [[NSMutableArray alloc] init];
    
    for (ORCRegion *region in regions)
    {
        if([region.type isEqualToString:type])
        {
            [geofences addObject:region];
        }
    }
    
    return geofences;
}

#pragma mark - PRIVATE

- (void)extendBackgroundTimeInfo:(BOOL)extended seconds:(NSInteger)seconds
{
    if (extended)
    {
        [ORCLog logDebug:@"New background time setup to %lu", seconds];
    }
    else
    {
        [ORCLog logError:@"You have exceeded the maximum backgroundTime, MAX_BACKGROUND_TIME 180."];
    }
}

@end
