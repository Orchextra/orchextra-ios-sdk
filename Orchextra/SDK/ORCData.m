//
//  ORCDataSource.m
//  Orchestra
//
//  Created by Judith Medina on 10/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCData.h"
#import "ORCLocationStorage.h"
#import "ORCStorage.h"

#import "ORCTriggerRegion.h"
#import "ORCTriggerGeofence.h"
#import "ORCVuforiaConfig.h"
#import "ORCThemeSdk.h"

NSString * const ORC_STAGING_BASE_URL = @"https://sdk.s.orchextra.io";
NSString * const ORC_QUALITY_BASE_URL = @"https://sdk.q.orchextra.io";
NSString * const ORC_PRODUCTION_BASE_URL = @"https://sdk.orchextra.io";

@interface ORCData()

@property (strong, nonatomic) ORCStorage *storage;

@end


@implementation ORCData

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _storage = [[ORCStorage alloc] init];
    }
    
    return self;
}

#pragma mark - DEBUG ENVIROMENT

- (void)setEnvironment:(NSString *)environment
{
    if ([environment isEqualToString:@"Staging"])
    {
        [self.storage storeURLEnvironment:ORC_STAGING_BASE_URL];
    }
    else if ([environment isEqualToString:@"Quality"])
    {
        [self.storage storeURLEnvironment:ORC_QUALITY_BASE_URL];
    }
    else if ([environment isEqualToString:@"Production"])
    {
        [self.storage storeURLEnvironment:ORC_PRODUCTION_BASE_URL];
    }
}

- (void)resetOrchextraConfigurationDetails
{
    [self.storage storeAcessToken:nil];
}

#pragma mark - Orchextra Output Delegate

- (ORCVuforiaConfig *)fetchVuforiaCredentials
{
    return [self.storage loadVuforiaConfig];
}

- (ORCThemeSdk *)fetchThemeSdk
{
    return [self.storage loadThemeSdk];
}

- (NSArray *)fetchGeofencesRegistered
{
    NSArray *regions = [self.storage loadGeofences];
    NSMutableArray *geofences = [[NSMutableArray alloc] init];
    
    for (ORCTriggerRegion *region in regions)
    {
        CLRegion *clregion = [region convertToCLRegion];
        [geofences addObject:clregion];
    }
    return geofences;
}

- (NSArray *)fetchBeaconsRegistered
{
    NSArray *regions = [self.storage loadBeacons];
    NSMutableArray *beacons = [[NSMutableArray alloc] init];
    
    for (ORCTriggerRegion *region in regions)
    {
        CLRegion *clregion = [region convertToCLRegion];
        if (clregion) [beacons addObject:clregion];
    }
    return beacons;
}

@end
