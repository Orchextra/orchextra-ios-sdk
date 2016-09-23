//
//  ORCAppConfigResponse.m
//  Orchextra
//
//  Created by Judith Medina on 17/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCAppConfigResponse.h"
#import "ORCBeacon.h"
#import "ORCBusinessUnit.h"
#import "ORCCustomField.h"
#import "ORCGeofence.h"
#import "ORCTag.h"
#import "ORCThemeSdk.h"
#import "ORCVuforiaConfig.h"
#import "ORCErrorManager.h"


NSString * const PROXIMITY_JSON                 = @"proximity";
NSString * const GEOMARKETING_JSON              = @"geoMarketing";
NSString * const REQUEST_WAIT_TIME              = @"requestWaitTime";
NSString * const THEME_JSON                     = @"theme";
NSString * const VUFORIA_JSON                   = @"vuforia";
NSString * const AVAILABLE_CUSTOM_FIELDS_JSON   = @"availableCustomFields";
NSString * const CRM_JSON                       = @"crm";
NSString * const DEVICE_JSON                    = @"device";
NSString * const CUSTOM_FIELDS_JSON             = @"customFields";
NSString * const TAGS_JSON                      = @"tags";
NSString * const BUSINESS_UNITS_JSON            = @"businessUnits";

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
            self.availableCustomFields = [self parseAvailableCustomFieldsResponse:self.jsonData];
            self.userCustomFields = [self parseCustomFieldsResponse:self.jsonData];
            self.userTags = [self parseUserTagsResponse:self.jsonData];
            self.deviceTags = [self parseDeviceTagsResponse:self.jsonData];
            self.userBusinessUnits = [self parseUserBusinessUnitResponse:self.jsonData];
            self.deviceBusinessUnits = [self parseDeviceBusinessUnitResponse:self.jsonData];
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
    
    if (json[VUFORIA_JSON] && !([json[VUFORIA_JSON] isKindOfClass:[NSNull class]]))
    {
        vuforia = [[ORCVuforiaConfig alloc] initWithJSON:json[VUFORIA_JSON]];
    }
    return vuforia;
}

- (NSArray <ORCCustomField *> *)parseAvailableCustomFieldsResponse:(NSDictionary *)json
{
    NSMutableArray <ORCCustomField *> *customFields = [[NSMutableArray alloc] init];
    NSDictionary *availableCustomFieldsJson = json[AVAILABLE_CUSTOM_FIELDS_JSON];
    
    if (availableCustomFieldsJson && ([availableCustomFieldsJson isKindOfClass:[NSDictionary class]]))
    {
        NSArray *customFieldsKeys = availableCustomFieldsJson.allKeys;
        
        for (NSUInteger i = 0; i < customFieldsKeys.count; i++)
        {
            NSString *key = [customFieldsKeys objectAtIndex:i];
            NSDictionary *customFieldObj = [availableCustomFieldsJson objectForKey:key];
            ORCCustomField *customField = [[ORCCustomField alloc] initWithJSON:customFieldObj
                                                                           key:key];
            [customFields addObject:customField];
        }
    }
    
    return customFields;
}

- (NSArray <ORCCustomField *> *)parseCustomFieldsResponse:(NSDictionary *)json
{
    NSMutableArray <ORCCustomField *> *customFields = [[NSMutableArray alloc] init];
    NSDictionary *crmCustomFieldJson = json[CRM_JSON];
    
    if ([crmCustomFieldJson isKindOfClass:[NSDictionary class]] && crmCustomFieldJson)
    {
         NSDictionary *customFieldsJson = crmCustomFieldJson[CUSTOM_FIELDS_JSON];
        
        if (customFieldsJson  && ([customFieldsJson isKindOfClass:[NSDictionary class]]))
        {
            NSArray *customFieldsKeys = customFieldsJson.allKeys;
            for (NSUInteger i = 0; i < customFieldsKeys.count; i++)
            {
                NSString *key = [customFieldsKeys objectAtIndex:i];
                id value = [customFieldsJson objectForKey:key];
                
                ORCCustomField *customField = [[ORCCustomField alloc] initWithKey:key
                                                                            label:nil
                                                                             type:ORCCustomFieldTypeNone
                                                                            value:value];
                [customFields addObject:customField];
            }
        }
    }
    
    return customFields;
}

- (NSArray <ORCTag *> *)parseUserTagsResponse:(NSDictionary *)json
{
    NSDictionary *crmUserTagsJson = json[CRM_JSON];

    return [self parseTags:crmUserTagsJson];
}

- (NSArray <ORCTag *> *)parseDeviceTagsResponse:(NSDictionary *)json
{
    NSDictionary *deviceTagsJson = json[DEVICE_JSON];
    
    return [self parseTags:deviceTagsJson];
}

- (NSArray <ORCTag *> *)parseTags:(NSDictionary *)json
{
    NSMutableArray <ORCTag *> *tags = [[NSMutableArray alloc] init];
    
    if (json && [json isKindOfClass:[NSDictionary class]])
    {
        NSArray *tagsJson = json[TAGS_JSON];
        
        if (tagsJson && tagsJson.count > 0)
        {
            for (NSString *tagUnformatted in tagsJson)
            {
                ORCTag *tag = nil;
                NSArray *tagComponents = [tagUnformatted componentsSeparatedByString:@"::"];
                
                if (tagComponents.count == 1)
                {
                    NSString *prefix = [tagComponents objectAtIndex:0];
                    tag = [[ORCTag alloc] initWithPrefix:prefix];
                    
                } else if (tagComponents.count == 2)
                {
                    NSString *prefix = [tagComponents objectAtIndex:0];
                    NSString *name = [tagComponents objectAtIndex:1];
                    tag = [[ORCTag alloc] initWithPrefix:prefix
                                                    name:name];
                }
                
                if (tag)
                {
                    [tags addObject:tag];
                }
                
            }
        }
    }
    
    return tags;
}

- (NSArray <ORCBusinessUnit *> *)parseUserBusinessUnitResponse:(NSDictionary *)json
{
    NSDictionary *crmUserBusinessUnitJson = json[CRM_JSON];
    
    return [self parseBusinessUnits:crmUserBusinessUnitJson];
}

- (NSArray <ORCBusinessUnit *> *)parseDeviceBusinessUnitResponse:(NSDictionary *)json
{
    NSDictionary *deviceTagsJson = json[DEVICE_JSON];
    
    return [self parseBusinessUnits:deviceTagsJson];
}

- (NSArray <ORCBusinessUnit *> *)parseBusinessUnits:(NSDictionary *)json
{
    NSMutableArray <ORCBusinessUnit *> *businessUnits = [[NSMutableArray alloc] init];
    
    if (json && [json isKindOfClass:[NSDictionary class]])
    {
        NSArray *businessUnitsJson = json[BUSINESS_UNITS_JSON];
        
        if (businessUnitsJson && businessUnitsJson.count > 0)
        {
            for (NSString *businessUnitsUnformatted in businessUnitsJson)
            {
                ORCBusinessUnit *businessUnit = nil;
                NSArray *businessUnitComponents = [businessUnitsUnformatted componentsSeparatedByString:@"::"];
                
                if (businessUnitComponents.count == 1)
                {
                    NSString *prefix = [businessUnitComponents objectAtIndex:0];
                    businessUnit = [[ORCBusinessUnit alloc] initWithPrefix:prefix];
                    
                } else if (businessUnitComponents.count == 2)
                {
                    NSString *prefix = [businessUnitComponents objectAtIndex:0];
                    NSString *name = [businessUnitComponents objectAtIndex:1];
                    businessUnit = [[ORCBusinessUnit alloc] initWithPrefix:prefix
                                                    name:name];
                }
                
                if (businessUnit)
                {
                    [businessUnits addObject:businessUnit];
                }
                
            }
        }
    }
    
    return businessUnits;
}


@end
