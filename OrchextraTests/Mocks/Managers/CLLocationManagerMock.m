//
//  CLLocationManagerMock.m
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "CLLocationManagerMock.h"

@implementation CLLocationManagerMock

- (void)startMonitoringForRegion:(CLRegion *)region
{
    self.outStartMonitoringRegionCalled = YES;
}

- (void)startRangingBeaconsInRegion:(CLBeaconRegion *)region
{
    self.outStartRangingBeaconCalled = YES;
}

- (void)startUpdatingLocation
{
    self.outstartUpdatingLocationCalled = YES;
}

- (void)stopUpdatingLocation
{
    self.outstopUpdatingLocationCalled = YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.outDidUpdateLocationCalled = YES;
    self.didLocationUpdate = locations.lastObject;
}

+ (BOOL)isRangingAvailable
{
    return YES;
}

- (NSSet<CLRegion *> *)rangedRegions
{
    return self.inRangedBeacons;
}

@end
