//
//  ORCTriggerGeofence.h
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ORCRegion.h"

@interface ORCGeofence : ORCRegion <NSCoding>

@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSNumber *radius;
@property (strong, nonatomic) NSNumber *currentDistance;

- (instancetype)initWithGeofence:(ORCGeofence *)geofence;
- (instancetype)initWithJSON:(NSDictionary *)json;
- (void)registerRegionWithLocationManager:(CLLocationManager *)locationManager;
- (CLRegion *)convertToCLRegion;
- (NSDictionary *)toDictionary;

@end
