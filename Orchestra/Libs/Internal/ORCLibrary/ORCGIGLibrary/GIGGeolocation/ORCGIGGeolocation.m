//
//  GIGGeolocation.m
//  giglibrary
//
//  Created by Sergio Baró on 18/03/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "ORCGIGGeolocation.h"


@interface ORCGIGGeolocation ()
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) GIGGeolocationCompletion completion;

@end


@implementation ORCGIGGeolocation

- (instancetype)init
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    return [self initWithLocationManager:locationManager];
}

- (instancetype)initWithLocationManager:(CLLocationManager *)locationManager
{
    self = [super init];
    if (self)
    {
        _locationManager = locationManager;
        _locationManager.delegate = self;
    }
    return self;
}

#pragma mark - Public

- (BOOL)isAuthorized
{
    return ([CLLocationManager locationServicesEnabled] && [self isAuthorizedStatus:[CLLocationManager authorizationStatus]]);
}

- (void)locateCompletion:(GIGGeolocationCompletion)completion
{
    self.completion = completion;
    [self start];
}

#pragma mark - Private

- (void)start
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void)updateLocation:(CLLocation *)location
{
    if (self.completion)
    {
        self.completion(YES, location, nil);
    }
    
    [self stop];
}

- (void)stop
{
    self.completion = nil;
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Private

- (BOOL)isAuthorizedStatus:(CLAuthorizationStatus)status
{
    return (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways);
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([self isAuthorizedStatus:status])
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[self updateLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	[self updateLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.completion)
    {
        BOOL authorized = [self isAuthorizedStatus:CLLocationManager.authorizationStatus];
        if (self.locationManager.location)
        {
            self.completion(authorized, self.locationManager.location, error);
        }
        else
        {
            self.completion(authorized, nil, error);
        }
    }
    
    [self stop];
}

@end
