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

@class ORCUser;
@class ORCAppConfigCommunicator;

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
- (void)saveRegions:(NSArray *)regions;

// GEOLOCATION
- (void)saveLastLocation:(CLLocation *)location
              completionCallBack:(CompletionProjectSettings)completion;
- (CLLocation *)loadLastLocation;

- (void)saveLastPlacemark:(CLPlacemark *)placemark;
- (CLPlacemark *)loadLastPlacemark;

@end
