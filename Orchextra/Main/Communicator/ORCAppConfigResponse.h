//
//  ORCAppConfigResponse.h
//  Orchextra
//
//  Created by Judith Medina on 17/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLJSONResponse.h"

@class ORCBusinessUnit;
@class ORCCustomField;
@class ORCTag;
@class ORCThemeSdk;
@class ORCVuforiaConfig;

@interface ORCAppConfigResponse : ORCGIGURLJSONResponse

@property (strong, nonatomic) NSArray *geoRegions;
@property (strong, nonatomic) NSArray *beaconRegions;
@property (strong, nonatomic) NSArray <ORCCustomField *> *availableCustomFields;
@property (strong, nonatomic) NSArray <ORCCustomField *> *userCustomFields;
@property (strong, nonatomic) NSArray <ORCBusinessUnit *> *userBusinessUnits;
@property (strong, nonatomic) NSArray <ORCTag *> *userTags;
@property (strong, nonatomic) NSArray <ORCTag *> *deviceTags;
@property (strong, nonatomic) NSArray <ORCBusinessUnit *> *deviceBusinessUnits;
@property (strong, nonatomic) ORCThemeSdk *themeSDK;
@property (strong, nonatomic) ORCVuforiaConfig *vuforiaConfig;
@property (assign, nonatomic) NSInteger requestWaitTime;

@end
