//
//  ORCTriggerGeofence.m
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCTriggerGeofence.h"
#import "ORCConstants.h"
#import "ORCGIGJSON.h"

NSString *const ORCGeofenceLongitude = @"geofenceLongitude";
NSString *const ORCGeofenceLatitude = @"geofenceLatitude";
NSString *const ORCGeofenceRadius = @"geofenceRadius";


@interface ORCTriggerGeofence()

@end


@implementation ORCTriggerGeofence

- (instancetype)initWithJSON:(NSDictionary *)json
{
    NSDictionary *point = json[@"point"];

    self = [super initWithJSON:json];
    
    if (self)
    {
        _longitude = [point stringForKey:@"lng"];
        _latitude = [point stringForKey:@"lat"];
        _radius = json[@"radius"];
        _currentDistance = @0;
        self.type = ORCTypeGeofence;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _longitude = [aDecoder decodeObjectForKey:ORCGeofenceLongitude];
        _latitude = [aDecoder decodeObjectForKey:ORCGeofenceLatitude];
        _radius = [aDecoder decodeObjectForKey:ORCGeofenceRadius];
        self.type = ORCTypeGeofence;
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_longitude forKey:ORCGeofenceLongitude];
    [aCoder encodeObject:_latitude forKey:ORCGeofenceLatitude];
    [aCoder encodeObject:_radius forKey:ORCGeofenceRadius];
}


#pragma mark - PUBLIC

- (void)registerRegionWithLocationManager:(CLLocationManager *)locationManager
{
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([self.latitude doubleValue],
                                                                           [self.longitude doubleValue]);
    
    double radius = [self.radius doubleValue];
    
    if (radius > locationManager.maximumRegionMonitoringDistance)
    {
        radius = locationManager.maximumRegionMonitoringDistance;
    }
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:locationCoordinate
                                                                 radius:radius identifier:self.identifier];
    
    BOOL isMonitoring = [locationManager.monitoredRegions containsObject:region];
    
    if (region && !isMonitoring)
    {
        if(![CLLocationManager isMonitoringAvailableForClass:[region class]])
        {
            NSLog(@"Region monitoring is not available.");
        }
        else
        {
            region.notifyOnEntry = self.notifyOnEntry;
            region.notifyOnExit = self.notifyOnExit;
            [locationManager startMonitoringForRegion:region];
        }
    }
}

- (CLRegion *)convertToCLRegion
{
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake([self.latitude doubleValue],
                                                                           [self.longitude doubleValue]);
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:locationCoordinate
                                                         radius:[self.radius doubleValue]
                                                     identifier:self.identifier];
    
    if (region)
    {
        region.notifyOnEntry = self.notifyOnEntry;
        region.notifyOnExit = self.notifyOnExit;
    }
    
    return region;
}


@end
