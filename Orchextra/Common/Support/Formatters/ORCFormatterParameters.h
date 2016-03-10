//
//  ORCDeviceStorage.h
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ORCUser;
@class ORCDevice;
@class ORCUserLocationPersister;
@class ORCSettingsPersister;

@interface ORCFormatterParameters : NSObject

- (instancetype)initWithDevice:(ORCDevice *)device
         userLocationPersister:(ORCUserLocationPersister *)userLocationPersister
             settingsPersister:(ORCSettingsPersister *)settingsPersister;

- (NSDictionary *)formatterParameteresDevice;
- (NSDictionary *)formattedPlacemark:(CLPlacemark *)placemark;
- (NSDictionary *)formattedUserLocation:(CLLocation *)userLocation;
- (NSDictionary *)formattedUserData:(ORCUser *)userData;

- (NSDictionary *)formattedCurrentUserLocation;

@end
