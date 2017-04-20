//
//  ORCLocationStorage.h
//  Orchestra
//
//  Created by Judith Medina on 1/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ORCUserLocationPersister : NSObject

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

- (CLLocation *)loadLastLocation;
- (void)storeLastLocation:(CLLocation *)location;

- (CLPlacemark *)loadLastPlacemark;
- (void)storeLastPlacemark:(CLPlacemark *)placemark;

- (BOOL)loadUserLocationPermission;
- (void)storeUserLocationPermission:(BOOL)hasPermission;
- (BOOL)isLocationAlertRequiedShowed;
- (void)storeLocationAlertRequiedShowed:(BOOL)locationAlertRequiedShowed;

- (NSArray *)loadRegions;
- (void)storeRegions:(NSArray *)regions;

@end
