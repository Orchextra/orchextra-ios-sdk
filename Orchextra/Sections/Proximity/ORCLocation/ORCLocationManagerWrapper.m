//
//  ORCLocation.m
//  Orchestra
//
//  Created by Judith Medina on 30/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCLocationManagerWrapper.h"
#import "ORCUserLocationPersister.h"
#import "ORCRegion.h"
#import "ORCBeacon.h"
#import "ORCConstants.h"
#import "NSString+MD5.h"
#import "NSBundle+ORCBundle.h"

typedef void(^ORCCompletionPlacemark)(CLPlacemark *placemark, NSError *error);

@interface ORCLocationManagerWrapper () <UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;

@property (strong, nonatomic) ORCUserLocationPersister *userLocationPersister;
@property (strong, nonatomic) ORCBeacon *lastBeacon;

@property (strong, nonatomic) NSMutableArray *regionsRegistered;
@property (strong, atomic) NSMutableArray *beaconsRanging;


@property (strong, nonatomic) ORCCompletionUserLocation userLocationBlock;
@property (strong, nonatomic) CompletionStateRegion stateRegionBlock;

@property (assign, nonatomic) BOOL isUserLocationUpdated;
@property (assign, nonatomic) BOOL isUpdatingBeaconRanging;

@end


@implementation ORCLocationManagerWrapper

- (instancetype)init
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    ORCUserLocationPersister *userLocationPersister = [[ORCUserLocationPersister alloc] init];
    
    return [self initWithCoreLocationManager:locationManager userLocationPersister:userLocationPersister];
}

- (instancetype)initWithCoreLocationManager:(CLLocationManager *)locationManager
                      userLocationPersister:(ORCUserLocationPersister *)userLocationPersister
{
    self = [super init];
    if (self)
    {
        _locationManager = locationManager;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy =  kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        _locationManager.activityType = CLActivityTypeOther;
        _userLocationPersister = userLocationPersister;
        _geocoder = [[CLGeocoder alloc] init];
        _regionsRegistered = [[NSMutableArray alloc] init];
        _beaconsRanging = [[NSMutableArray alloc] init];
                
        [self requestAlwaysAuthorization];
        
    }
    return self;
}

#pragma mark - PUBLIC

- (void)updateUserLocationWithCompletion:(ORCCompletionUserLocation)completionUserLocation
{
    self.userLocationBlock = completionUserLocation;
    self.isUserLocationUpdated = NO;
    [self.locationManager startUpdatingLocation];
}

- (void)requestStateForRegion:(CLRegion *)region
              completionState:(CompletionStateRegion)completionState
{
    self.stateRegionBlock = completionState;
    [self.locationManager requestStateForRegion:region];
}

- (void)registerRegions:(NSArray *)geoRegions
{
    for (ORCRegion *region in geoRegions)
    {
        [region registerRegionWithLocationManager:self.locationManager];
        
        if ([region isKindOfClass:[ORCBeacon class]])
        {
            [self.regionsRegistered addObject:region];
        }
    }
    
    [self.userLocationPersister storeRegions:geoRegions];
}

- (void)registerRegion:(ORCRegion *)region
{
    [region registerRegionWithLocationManager:self.locationManager];
}

- (void)stopMonitoringAllRegions
{
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

- (void)stopMonitoring:(ORCRegion *)region
{
    [region stopMonitoringRegionWithLocationManager:self.locationManager];
}

- (BOOL)isAuthorized
{
    return ([CLLocationManager locationServicesEnabled] &&
            [self isAuthorizedStatus:[CLLocationManager authorizationStatus]]);
}


#pragma mark - PRIVATE

- (void)getGeocodeAddressWithLocation:(CLLocation *)location completionHandler:(ORCCompletionPlacemark)completionHandler
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        completionHandler(placemarks.firstObject, error);
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
        BOOL locationAlertRequiredShowed = [self.userLocationPersister isLocationAlertRequiedShowed];
        
        if (!locationAlertRequiredShowed)
        {
            [self showLocationRequiredAlertForStatus:status];
        }
    }
    else if (status == kCLAuthorizationStatusNotDetermined)
    {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
}

- (void)showLocationRequiredAlertForStatus:(CLAuthorizationStatus)status
{
    NSString *title;
    title = (status == kCLAuthorizationStatusDenied) ?
    LocalizableConstants.kLocaleOrcLocationServiceOffAlertTitle :
    LocalizableConstants.kLocaleOrcBackgroundLocationOffAlertTitle;
    
    NSString *message = LocalizableConstants.kLocaleOrcBackgroundLocationAlertMessage;
    
    NSString *otherButton = LocalizableConstants.kLocaleOrcGlobalSettingsButton;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:LocalizableConstants.kLocaleOrcGlobalCancelButton
                                              otherButtonTitles:otherButton, nil];
    [alertView show];
}

- (void)notifyEnterRegion:(CLRegion *)region
{
    [ORCLog logDebug:@"Did enter region: [%@]", region.identifier];
    [self.delegateLocation didRegionHasBeenFired:region event:ORCTypeEventEnter];
}

- (void)notifyExitRegion:(CLRegion *)region
{
    [ORCLog logDebug:@"Did exit region: [%@]", region.identifier];
    [self.delegateLocation didRegionHasBeenFired:region event:ORCTypeEventExit];
}

- (void)notifyStateRegion:(ORCBeacon *)region
{
    [ORCLog logDebug:@"Did change state: [%@ _ %@ _ %@] to %@",
     region.uuid.UUIDString,
     region.major,
     region.minor,
     [self nameForProximity:region.currentProximity]];
    [self.delegateLocation didBeaconHasBeenFired:region];
}

- (ORCBeacon *)isAlreadyABeaconRanged:(CLBeacon *)beacon
{
    ORCBeacon *beaconAlreadyRegistered = nil;
    
    for (ORCBeacon *beaconRanging in self.beaconsRanging)
    {
        if ([beaconRanging isEqualToCLBeacon:beacon])
        {
            beaconAlreadyRegistered = beaconRanging;
        }
    }
    return beaconAlreadyRegistered;
}

- (NSMutableArray *)deleteAllBeaconWithinRegion:(CLRegion *)region
{
    NSMutableArray *beaconsRanged = [NSMutableArray arrayWithArray:self.beaconsRanging];

    for(int i = 0; i < beaconsRanged.count; i++)
    {
        ORCBeacon *beaconRanged = beaconsRanged[i];

        if ([beaconRanged.code isEqualToString:region.identifier])
        {
            [beaconsRanged removeObject:beaconRanged];
        }
    }
    
    return beaconsRanged;
}


#pragma mark - DELEGATES

#pragma mark - LocationDelegate

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [manager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self notifyEnterRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self notifyExitRegion:region];
    self.beaconsRanging = [self deleteAllBeaconWithinRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons)
    {
        
        ORCBeacon *beaconRanged = [self isAlreadyABeaconRanged:beacon];
        
        if ( beaconRanged == nil)
        {
            ORCBeacon *newBeaconRanged = [[ORCBeacon alloc]
                                                 initWithUUID:beacon.proximityUUID
                                                 major:beacon.major
                                                 minor:beacon.minor];
            newBeaconRanged.code = region.identifier;
            [newBeaconRanged setNewProximity:beacon.proximity];
            
            [self.beaconsRanging addObject:newBeaconRanged];
            [self notifyStateRegion:newBeaconRanged];
        }
        else
        {
            BOOL changeProximity = [beaconRanged setNewProximity:beacon.proximity];
            
            if (changeProximity)
            {
                [self notifyStateRegion:beaconRanged];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.isUserLocationUpdated)
    {
        [self.locationManager stopUpdatingLocation];

        [self getGeocodeAddressWithLocation:locations.lastObject completionHandler:^(CLPlacemark *placemark, NSError *error) {
        
            if (self.userLocationBlock)
            {
                if (error)
                {
                    self.userLocationBlock(locations.lastObject, nil);
                }
                else
                {
                    self.userLocationBlock(locations.lastObject, placemark);
                }
                
                self.isUserLocationUpdated = YES;
            }
        }];
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
            if ([self.userLocationPersister loadUserLocationPermission] != YES)
            {
                [self.userLocationPersister storeUserLocationPermission: YES];
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
            if ([self.userLocationPersister loadUserLocationPermission] == YES)
            {
                [self.userLocationPersister storeUserLocationPermission: NO];
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
    [ORCLog logError:@"ERROR: Location manager didFailWithError: %@", error];
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.userLocationPersister storeLocationAlertRequiedShowed:YES];
    }
    else if (buttonIndex == 1)
    {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}


#pragma mark - HELPERS

- (NSString *)nameForProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityUnknown:
            return @"unknown";
            break;
        case CLProximityImmediate:
            return @"immediate";
            break;
        case CLProximityNear:
            return @"near";
            break;
        case CLProximityFar:
            return @"far";
            break;
    }
}

- (void)locationErrorCode:(NSUInteger)errorCode region:(CLRegion *)region
{
    switch (errorCode)
    {
        case kCLErrorLocationUnknown: //0
            [ORCLog logError:@"Location Error: %lu kCLErrorLocationUnknown: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorDenied: //1
            [ORCLog logError:@"Location Error: %lu kCLErrorDenied: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorNetwork: //2
            [ORCLog logError:@"Location Error:: %lu kCLErrorNetwork: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorRegionMonitoringDenied: //4
            [ORCLog logError:@"Location Error:: %lu kCLErrorRegionMonitoringDenied: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorRegionMonitoringFailure: //5
            [ORCLog logError:@"Location Error:: %lu kCLErrorRegionMonitoringFailure: %@ --",(unsigned long)errorCode, region.identifier];
            break;
        case kCLErrorRangingUnavailable: //16
            [ORCLog logError:@"Location Error:: %lu kCLErrorRangingUnavailable: Bluetooth might be off",(unsigned long)errorCode, region.identifier];
            break;
        default:
            [ORCLog logError:@"Location Error: %lu: %@ --, ",(unsigned long)errorCode, region.identifier];
            break;
    }
}

@end
