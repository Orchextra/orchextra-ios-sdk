//
//  ORCLocation.m
//  Orchestra
//
//  Created by Judith Medina on 30/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCLocationManager.h"
#import "ORCLocationStorage.h"
#import "ORCProximityManager.h"
#import "ORCTriggerRegion.h"
#import "ORCTriggerBeacon.h"

#import "NSBundle+ORCBundle.h"
#import "ORCGIGLogManager.h"


@interface ORCLocationManager () <UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) ORCLocationStorage *storage;
@property (strong, nonatomic) ORCTriggerBeacon *lastBeacon;
@property (strong, nonatomic) NSMutableArray *beaconsCMS;

@property (strong, nonatomic) CompletionUserLocation userLocationBlock;
@property (strong, nonatomic) CompletionStateRegion stateRegionBlock;

@property (assign, nonatomic) BOOL isUserLocationUpdated;

@end


@implementation ORCLocationManager

- (instancetype)init
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    ORCLocationStorage *storage = [[ORCLocationStorage alloc] init];
    
    return [self initWithCoreLocationManager:locationManager storage:storage];
}

- (instancetype)initWithCoreLocationManager:(CLLocationManager *)locationManager
                                    storage:(ORCLocationStorage *)storage
{
    self = [super init];
    if (self)
    {
        _locationManager = locationManager;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy =  kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        _locationManager.activityType = CLActivityTypeOther;
        _storage = storage;
        _geocoder = [[CLGeocoder alloc] init];
        _beaconsCMS = [[NSMutableArray alloc] init];
                
        [self requestAlwaysAuthorization];
        [self updateUserLocation];
        
    }
    return self;
}

#pragma mark - PUBLIC

- (void)updateUserLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)updateUserLocationWithCompletion:(CompletionUserLocation)userLocation
{
    self.userLocationBlock = userLocation;
    self.isUserLocationUpdated = NO;
    [self updateUserLocation];
}

- (void)requestStateForRegion:(CLRegion *)region
              completionState:(CompletionStateRegion)completionState
{
    self.stateRegionBlock = completionState;
    [self.locationManager requestStateForRegion:region];
}

- (void)registerGeoRegions:(NSArray *)geoRegions
{
    for (ORCTriggerRegion *region in geoRegions)
    {
        [region registerRegionWithLocationManager:self.locationManager];
        
        if ([region isKindOfClass:[ORCTriggerBeacon class]])
        {
            [self.beaconsCMS addObject:region];
        }
    }
    
    [self.storage storeRegions:geoRegions];
}

- (void)registerRegion:(ORCTriggerRegion *)region
{
    [region registerRegionWithLocationManager:self.locationManager];
}

- (void)stopMonitoringAllRegions
{
    [self.storage storeRegions:nil];

    NSSet *monitorRegions = self.locationManager.monitoredRegions;
    
    for (id region in monitorRegions)
    {
        [self.locationManager stopMonitoringForRegion:region];
        
        if ([[region class] isSubclassOfClass:[CLBeaconRegion class]])
        {
            [self.locationManager stopRangingBeaconsInRegion:region];
        }
    }
    
    [self.locationManager stopUpdatingLocation];
}

- (void)stopMonitoring:(ORCTriggerRegion *)region
{
    [region stopMonitoringRegionWithLocationManager:self.locationManager];
}

- (BOOL)isAuthorized
{
    return ([CLLocationManager locationServicesEnabled] &&
            [self isAuthorizedStatus:[CLLocationManager authorizationStatus]]);
}

- (CLLocationDistance)distanceFromUserLocationTo:(CLCircularRegion *)region
{
    CLLocation *userLocation = [self loadLastLocation];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    
    CLLocationDistance distance = [userLocation distanceFromLocation:location];
    return distance;
}

#pragma mark Public - Storage

- (CLLocation *)loadLastLocation
{
    return [self.storage loadLastLocation];
}

- (CLPlacemark *)loadLastPlacemark
{
    return [self.storage loadLastPlacemark];
}

#pragma mark - PRIVATE


- (void)getGeocodeAddressWithLocation:(CLLocation *)location
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            [ORCGIGLogManager error:@"Error -- Not placemark founded."];
        }
        [self.storage storeLastPlacemark:placemarks.lastObject];
    }];
}

- (BOOL)isAuthorizedStatus:(CLAuthorizationStatus)status
{
    return (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways);
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied)
    {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ?
        ORCLocalizedBundle(@"Location_services_are_off", nil, nil) :
        ORCLocalizedBundle(@"Background_location_is_not_enabled", nil, nil);
        
        NSString *message = ORCLocalizedBundle(@"Turn_on_background_location_service", nil, nil);
        
        NSString *otherButton = (IOS_8_OR_LATER) ? ORCLocalizedBundle(@"Settings", nil, nil) : nil;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:ORCLocalizedBundle(@"cancel_button", nil, nil)
                                                  otherButtonTitles:otherButton, nil];
        [alertView show];
    }
    else if (status == kCLAuthorizationStatusNotDetermined)
    {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
}

#pragma mark - PRIVATE

- (void)fireProximityWithManager:(CLLocationManager *)manager region:(CLRegion *)region event:(NSInteger)event
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        for (ORCTriggerBeacon *itemBeacon in self.beaconsCMS)
        {
            if ([itemBeacon isEqualToCLBeacon:(CLBeacon *)region])
            {
                itemBeacon.currentEvent = event;
                [self.delegateLocation didBeaconHasBeenFired:itemBeacon];
                break;
            }
        }
    }
    else
    {
        [self.delegateLocation didRegionHasBeenFiredWithRegion:region event:event];
    }
}

#pragma mark - DELEGATES

#pragma mark - LocationDelegate

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [manager requestStateForRegion:region];
    [ORCGIGLogManager log:@"Monitoring region: %@", region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self fireProximityWithManager:manager region:region event:ORCTypeEventEnter];
    [ORCGIGLogManager log:@"Did enter region: %@", region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self fireProximityWithManager:manager region:region event:ORCTypeEventExit];
    [ORCGIGLogManager log:@"Did exit region: %@", region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons)
    {
        for (ORCTriggerBeacon *itemBeacon in self.beaconsCMS)
        {
            if ([itemBeacon isEqualToCLBeacon:beacon] && itemBeacon.notifyOnEntry)
            {
                BOOL changeProximity = [itemBeacon setNewProximity:beacon.proximity];
                
                if (changeProximity)
                {
                    itemBeacon.currentEvent = ORCtypeEventStay;
                    [self.delegateLocation didBeaconHasBeenFired:itemBeacon];
                }
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.isUserLocationUpdated)
    {
        [self.storage storeLastLocation:locations.lastObject];
        [self getGeocodeAddressWithLocation:locations.lastObject];
        [self.locationManager stopUpdatingLocation];
        
        if (self.userLocationBlock)
        {
            self.userLocationBlock(locations.lastObject);
            self.isUserLocationUpdated = YES;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
        {
            
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            if ([self.storage loadUserLocationPermission] != YES)
            {
                [self.storage storeUserLocationPermission: YES];
                [self.delegateLocation didAuthorizationStatusChanged:status];
            }
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            
        }
            break;
            
        case kCLAuthorizationStatusDenied:
        {
            if ([self.storage loadUserLocationPermission] == YES)
            {
                [self.storage storeUserLocationPermission: NO];
                [self.delegateLocation didAuthorizationStatusChanged:status];
            }
        }
        default:
            break;
    }
}

#pragma mark - Handling Errors

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    [self locationErrorCode:error.code region:region];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    [self locationErrorCode:error.code region:region];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [ORCGIGLogManager error:@"Location manager failed: %@", error];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && IOS_8_OR_LATER)
    {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - Error Helper

- (void)locationErrorCode:(NSUInteger)errorCode region:(CLRegion *)region
{
    switch (errorCode)
    {
        case kCLErrorLocationUnknown: //0
            [ORCGIGLogManager error:@"-- ERROR: %lu kCLErrorLocationUnknown: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorDenied: //1
            [ORCGIGLogManager error:@"-- ERROR: %lu kCLErrorDenied: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorNetwork: //2
            [ORCGIGLogManager error:@"-- ERROR: %lu kCLErrorNetwork: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorRegionMonitoringDenied: //4
            [ORCGIGLogManager error:@"-- ERROR: %lu kCLErrorRegionMonitoringDenied: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorRegionMonitoringFailure: //5
            [ORCGIGLogManager error:@"-- ERROR: %lu kCLErrorRegionMonitoringFailure: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorRangingUnavailable: //16
            [ORCGIGLogManager error:@"-- ERROR: %lu kCLErrorRangingUnavailable: Bluetooth might be off %@ --",(unsigned long)errorCode, region.identifier];
            break;
        default:
            [ORCGIGLogManager error:@"-- ERROR: %lu: %@ --, ",(unsigned long)errorCode, region.identifier];
            break;
    }
}

@end
