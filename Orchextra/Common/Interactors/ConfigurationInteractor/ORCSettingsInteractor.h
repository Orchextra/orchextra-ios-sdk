//
//  ConfigurationInteractor.h
//  Orchestra
//
//  Created by Judith Medina on 5/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ORCFormatterParameters.h"
#import "ORCSettingsPersister.h"

@class ORCAppConfigCommunicator;
@class ORCBusinessUnit;
@class ORCUser;
@class ORCTag;

typedef void(^CompletionProjectSettings)(BOOL success, NSError *error);

@interface ORCSettingsInteractor : NSObject

- (instancetype)initWithSettingsPersister:(ORCSettingsPersister *)settingsPersister
                    userLocationPersister:(ORCUserLocationPersister *)userLocationPersister
                             communicator:(ORCAppConfigCommunicator *)communicator
                                formatter:(ORCFormatterParameters *)formatter;

- (void)loadProjectWithApiKey:(NSString *)apiKey
                    apiSecret:(NSString *)apiSecret
                   completion:(CompletionProjectSettings)completion;

// USER
- (void)saveUser:(ORCUser *)user;
- (ORCUser *)currentUser;

// CONFIG
- (NSInteger)backgroundTime;
- (NSArray *)loadRegions;
- (NSArray <ORCCustomField *> *)loadAvailableCustomFields;
- (NSArray <ORCCustomField *> *)loadCustomFields;
- (NSArray <ORCTag *> *)loadUserTags;
- (NSArray <ORCTag *> *)loadDeviceTags;
- (NSArray <ORCBusinessUnit *> *)loadUserBusinessUnits;
- (NSArray <ORCBusinessUnit *> *)loadDeviceBusinessUnits;
- (void)saveRegions:(NSArray *)regions;
- (void)saveOrchextraRunning:(BOOL)orchextraRunning;
- (BOOL)isOrchextraRunning;
- (void)saveCustomFields:(NSArray <ORCCustomField *> *)customFields;
- (void)saveUserTags:(NSArray <ORCTag *> *)userTags;
- (void)saveDeviceTags:(NSArray <ORCTag *> *)deviceTags;
- (void)saveUserBusinessUnits:(NSArray <ORCBusinessUnit *> *)userBusinessUnits;
- (void)saveDeviceBusinessUnits:(NSArray <ORCBusinessUnit *> *)deviceBusinessUnits;
- (BOOL)updateCustomFieldValue:(id)value withKey:(NSString *)key;

// ACCESS TOKEN
- (void)invalidateAccessToken;

// GEOLOCATION
- (void)saveLastLocation:(CLLocation *)location
              completionCallBack:(CompletionProjectSettings)completion;
- (CLLocation *)loadLastLocation;

- (void)saveLastPlacemark:(CLPlacemark *)placemark;
- (CLPlacemark *)loadLastPlacemark;

@end
