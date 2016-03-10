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
#import "ORCRegion.h"
#import "ORCConstants.h"

@class ORCUserLocationPersister;
@class ORCBeacon;

typedef void(^CompletionStateRegion)(CLRegionState state);

@protocol ORCLocationManagerDelegate <NSObject>

- (void)didAuthorizationStatusChanged:(CLAuthorizationStatus)status;
- (void)didRegionHasBeenFired:(CLRegion *)region event:(ORCTypeEvent)event;
- (void)didBeaconHasBeenFired:(ORCBeacon *)beacon;

@end

@interface ORCLocationManagerWrapper : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id <ORCLocationManagerDelegate> delegateLocation;

- (instancetype)initWithCoreLocationManager:(CLLocationManager *)locationManager
                      userLocationPersister:(ORCUserLocationPersister *)userLocationPersister;

- (BOOL)isAuthorized;
- (void)updateUserLocationWithCompletion:(ORCCompletionUserLocation)completionUserLocation;

- (void)stopMonitoringAllRegions;
- (void)registerRegions:(NSArray *)geoRegions;

@end
