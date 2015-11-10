//
//  ORCAppConfigResponse.m
//  Orchestra
//
//  Created by Judith Medina on 17/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCAppConfigResponse.h"
#import "ORCTriggerBeacon.h"
#import "ORCTriggerGeofence.h"
#import "ORCThemeSdk.h"
#import "ORCVuforiaConfig.h"


NSString * const PROXIMITY_JSON = @"proximity";
NSString * const GEOMARKETING_JSON = @"geoMarketing";
NSString * const REQUEST_WAIT_TIME = @"requestWaitTime";
NSString * const THEME_JSON = @"theme";
NSString * const VUFORIA_JSON = @"vuforia";


NSInteger MAX_GEOFENCES = 20;


@implementation ORCAppConfigResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    
    if (self)
    {
        if (self.success)
        {
            self.geoRegions = [self parseGeoMarketingResponse:self.jsonData];
            self.themeSDK = [self parseThemeWithJSON:self.jsonData];
            self.requestWaitTime = [self.jsonData integerForKey:REQUEST_WAIT_TIME];
            self.vuforiaConfig = [self parseVuforiaCredentials:self.jsonData];
        }
    }
    
    return self;
}

#pragma mark - PRIVATE 

- (NSArray *)parseGeoMarketingResponse:(NSDictionary *)json
{
    NSMutableArray *geoRegions = [[NSMutableArray alloc] init];
    
    if ([json isKindOfClass:[NSDictionary class]] && json[PROXIMITY_JSON])
    {
        for (NSDictionary *beaconObj in json[PROXIMITY_JSON])
        {
            ORCTriggerBeacon *beacon = [[ORCTriggerBeacon alloc] initWithJSON:beaconObj];
            [geoRegions addObject:beacon];
        }
    }
    
    if ([json isKindOfClass:[NSDictionary class]] && json[GEOMARKETING_JSON])
    {
        int countGeofence = 0;
        
        for (NSDictionary *geofenceObj in  json[GEOMARKETING_JSON])
        {
            ORCTriggerGeofence *geofence = [[ORCTriggerGeofence alloc] initWithJSON:geofenceObj];
            [geoRegions addObject:geofence];
            if (countGeofence > MAX_GEOFENCES) break;
            countGeofence++;
        }
    }
    
    return geoRegions;
}

- (ORCThemeSdk *)parseThemeWithJSON:(NSDictionary *)json
{
    ORCThemeSdk *theme = nil;
    
    if (json[THEME_JSON])
    {
        theme = [[ORCThemeSdk alloc] initWithJSON:json[THEME_JSON]];
    }
    return theme;
}


- (ORCVuforiaConfig *)parseVuforiaCredentials:(NSDictionary *)json
{
    ORCVuforiaConfig *vuforia = nil;
    
    if (json[VUFORIA_JSON])
    {
        vuforia = [[ORCVuforiaConfig alloc] initWithJSON:json[VUFORIA_JSON]];
    }
    return vuforia;
}

@end
