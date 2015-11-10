//
//  ORCLocation.h
//  Orchestra
//
//  Created by Judith Medina on 30/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ORCTriggerRegion.h"

@class ORCLocationStorage;
@class ORCTriggerBeacon;

typedef void(^CompletionUserLocation)(CLLocation *location);
typedef void(^CompletionStateRegion)(CLRegionState state);

@protocol ORCLocationManagerDelegate <NSObject>

- (void)didAuthorizationStatusChanged:(CLAuthorizationStatus)status;
- (void)didRegionHasBeenFiredWithRegion:(CLRegion *)region event:(NSInteger)event;
- (void)didBeaconHasBeenFired:(ORCTriggerBeacon *)beacon;

@end

@interface ORCLocationManager : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id <ORCLocationManagerDelegate> delegateLocation;

- (instancetype)initWithCoreLocationManager:(CLLocationManager *)locationManager
                                    storage:(ORCLocationStorage *)storage;

- (BOOL)isAuthorized;

- (void)updateUserLocation;
- (void)updateUserLocationWithCompletion:(CompletionUserLocation)userLocation;

- (void)stopMonitoringAllRegions;
- (void)stopMonitoring:(ORCTriggerRegion *)region;

- (void)registerRegion:(ORCTriggerRegion *)region;
- (void)registerGeoRegions:(NSArray *)geoRegions;

- (CLLocation *)loadLastLocation;
- (CLPlacemark *)loadLastPlacemark;
- (CLLocationDistance)distanceFromUserLocationTo:(CLCircularRegion *)region;



@end
