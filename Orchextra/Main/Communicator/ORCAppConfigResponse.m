//
//  ORCAppConfigResponse.m
//  Orchextra
//
//  Created by Judith Medina on 17/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCAppConfigResponse.h"
#import "ORCBeacon.h"
#import "ORCGeofence.h"
#import "ORCThemeSdk.h"
#import "ORCVuforiaConfig.h"
#import "ORCErrorManager.h"


NSString * const PROXIMITY_JSON = @"proximity";
NSString * const GEOMARKETING_JSON = @"geoMarketing";
NSString * const REQUEST_WAIT_TIME = @"requestWaitTime";
NSString * const THEME_JSON = @"theme";
NSString * const VUFORIA_JSON = @"vuforia";

@implementation ORCAppConfigResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    
    if (self)
    {
        if (self.success)
        {
            [self parseGeoMarketingResponse:self.jsonData];
            self.themeSDK = [self parseThemeWithJSON:self.jsonData];
            self.requestWaitTime = [self.jsonData integerForKey:REQUEST_WAIT_TIME];
            self.vuforiaConfig = [self parseVuforiaCredentials:self.jsonData];
        }
        else
        {
            self.error = [ORCErrorManager errorWithResponse:self];
        }
    }
    
    return self;
}

#pragma mark - PRIVATE 

- (void)parseGeoMarketingResponse:(NSDictionary *)json
{
    // Parse Beacons
    if ([json isKindOfClass:[NSDictionary class]] && json[PROXIMITY_JSON])
    {
        NSMutableArray *beaconRegions = [[NSMutableArray alloc] init];

        for (NSDictionary *beaconObj in json[PROXIMITY_JSON])
        {
            ORCBeacon *beacon = [[ORCBeacon alloc] initWithJSON:beaconObj];
            [beaconRegions addObject:beacon];
        }
        
        if (!self.beaconRegions) self.beaconRegions = [[NSArray alloc] init];
        self.beaconRegions = beaconRegions;
    }
    
    // Parse Geofences
    if ([json isKindOfClass:[NSDictionary class]] && json[GEOMARKETING_JSON])
    {
        NSMutableArray *geoRegions = [[NSMutableArray alloc] init];

        for (NSDictionary *geofenceObj in  json[GEOMARKETING_JSON])
        {
            ORCGeofence *geofence = [[ORCGeofence alloc] initWithJSON:geofenceObj];
            [geoRegions addObject:geofence];
        }
        
        if (!self.geoRegions) self.geoRegions = [[NSArray alloc] init];
        self.geoRegions = geoRegions;
    }
}

- (ORCThemeSdk *)parseThemeWithJSON:(NSDictionary *)json
{
    ORCThemeSdk *theme = nil;
    
    if ([json isKindOfClass:[NSDictionary class]] && json[THEME_JSON])
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
