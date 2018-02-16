//
//  GIGGeoMarketing.m
//  Orchestra
//
//  Created by Judith Medina on 17/4/15.
//  Copyright (c) 2015 Judith Medina. All rights reserved.
//

#import "ORCProximityManager.h"
#import "ORCActionManager.h"
#import "ORCPushManager.h"

#import "ORCValidatorActionInterator.h"
#import "ORCSettingsInteractor.h"
#import "ORCStayInteractor.h"
#import "ORCConstants.h"

#import "ORCAction.h"
#import "ORCRegion.h"
#import "ORCGeofence.h"
#import "ORCBeacon.h"


@interface ORCProximityManager ()

@property (weak, nonatomic) id<ORCActionInterface> actionInterface;
@property (strong, nonatomic) ORCValidatorActionInterator *validatorInteractor;
@property (strong, nonatomic) ORCSettingsInteractor *settingsInteractor;
@property (strong, nonatomic) ORCLocationManagerWrapper *locationManagerWrapper;
@property (strong, nonatomic) NSArray *regions;
@property (strong, nonatomic) ORCBeacon *lastObservedBeacon;

@end


@implementation ORCProximityManager

#pragma mark - INIT

- (instancetype)initWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCLocationManagerWrapper *orcLocationManager = [[ORCLocationManagerWrapper alloc] init];
    orcLocationManager.delegateLocation = self;
    ORCValidatorActionInterator *validatorInteractor = [[ORCValidatorActionInterator alloc] init];
    ORCSettingsInteractor *settingsInteractor = [[ORCSettingsInteractor alloc] init];

    return [self initWithActionInterface:actionInterface coreLocationManager:orcLocationManager interactor:validatorInteractor settingsInteractor:settingsInteractor];
}

- (instancetype)initWithActionInterface:(id<ORCActionInterface>)actionInterface
                    coreLocationManager:(ORCLocationManagerWrapper *)orcLocation
                             interactor:(ORCValidatorActionInterator *)interactor
                     settingsInteractor:(ORCSettingsInteractor *)settingsInteractor
{
    self = [super init];
    
    if (self)
    {
        _locationManagerWrapper = orcLocation;
        _validatorInteractor = interactor;
        _actionInterface = actionInterface;
        _settingsInteractor = settingsInteractor;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)startMonitoringAndRangingOfRegions
{
    NSArray *regions = [self.settingsInteractor loadRegions];
    
    [self clearMonitoringAndRanging];

    if ([self.locationManagerWrapper isAuthorized])
    {
        [self canRegisterRegions:regions];
    }
    else
    {
        [[ORCLog sharedInstance] logError:@"Authorization denied we can't get start location services."];
    }
}

- (void)stopMonitoringAndRangingOfRegions
{
    [self clearMonitoringAndRanging];
}

- (void)updateUserLocation
{
    if ([self.locationManagerWrapper isAuthorized])
    {
        __weak typeof(self) this = self;
        
        [self.locationManagerWrapper updateUserLocationWithCompletion:^(CLLocation *location, CLPlacemark *placemark) {
            
            [this.settingsInteractor saveLastLocation:location completionCallBack:^(BOOL success, NSError *error) {
                if (success)
                {
                    [this startMonitoringAndRangingOfRegions];
                }
            }];
            
            [this.settingsInteractor saveLastPlacemark:placemark];
        }];
    }
}


#pragma mark - PRIVATE (Validate region)

- (void)requestActionWithGeofence:(ORCGeofence *)geofence
{
    __weak typeof(self) this = self;
    
    [self.validatorInteractor validateProximityWithGeofence:geofence
                                                 completion:^(ORCAction *action, NSError *error) {
                                                     
                                                     if (action)
                                                     {
                                                         action.launchedByTriggerCode = geofence.code;
                                                         [this.actionInterface didFireTriggerWithAction:action];
                                                     }
                                                 }];
}

- (void)requestActionWithBeacon:(ORCBeacon *)beacon
{
    __weak typeof(self) this = self;
    
    [self.validatorInteractor validateProximityWithBeacon:beacon
                                               completion:^(ORCAction *action, NSError *error) {
                                                   if (action)
                                                   {
                                                       action.launchedByTriggerCode = beacon.code;
                                                       [this.actionInterface didFireTriggerWithAction:action];
                                                   }
                                               }];
}

- (void)requestActionWithRegion:(ORCRegion *)region
{
    __weak typeof(self) this = self;
    
    [self.validatorInteractor validateProximityWithRegion:region
                                               completion:^(ORCAction *action, NSError *error) {
                                                   
                                                   if (action)
                                                   {
                                                       action.launchedByTriggerCode = region.code;
                                                       [this.actionInterface didFireTriggerWithAction:action];
                                                   }
                                               }];
}


#pragma mark - PRIVATE

- (void)clearMonitoringAndRanging
{
    [self.locationManagerWrapper stopMonitoringAllRegions];
}

- (void)canRegisterRegions:(NSArray *)regions
{
    if (regions.count > 0)
    {
        [self.locationManagerWrapper registerRegions:regions];
    }
    else
    {
        [[ORCLog sharedInstance] logDebug:@"There are not regions to register."];
    }
}

- (ORCRegion *)triggerWithIdentifier:(NSString *)identifier
{
    NSArray *regionsLoaded = [self.settingsInteractor loadRegions];
    
    for (ORCRegion *regionRegistered in regionsLoaded)
    {
        if ([regionRegistered.code isEqualToString:identifier])
        {
            return regionRegistered;
        }
    }
    
    return nil;
}

- (void)scheduleGeofenceIfNeedIt:(ORCGeofence *)geofence
{
    if (geofence.timer > 0)
    {
        [[ORCPushManager sharedPushManager] sendLocalPushNotificationWithGeofence:geofence];
    }
}

- (void)needToHandleStayTimeGeofence:(ORCGeofence *)geofence
{
    ORCStayInteractor *stayInteractor = [[ORCStayInteractor alloc] init];
    
    __weak typeof(self) this = self;
    [stayInteractor performStayRequestWithRegion:geofence completion:^(BOOL success) {
        
        if (success)
        {
            [this locationUserInsideGeofence:geofence completion:^(BOOL isInsideRegion) {
                CLLocationDistance distance = [self distanceFromUserLocationTo:geofence];
                geofence.currentDistance = @(distance);
                geofence.currentEvent = ORCtypeEventStay;
                
                if (isInsideRegion)
                {
                    [this requestActionWithGeofence:geofence];
                }
            }];
        }
    }];
}

- (BOOL)isUserAtRegion:(ORCGeofence *)geofence withLocation:(CLLocation *)lastLocation
{
    BOOL isUserAtRegion = NO;
    
    CLCircularRegion *regionWithGeofence = [[CLCircularRegion alloc]
                                            initWithCenter:CLLocationCoordinate2DMake([geofence.latitude doubleValue],
                                                                                      [geofence.longitude doubleValue])
                                            radius:[geofence.radius doubleValue]
                                            identifier:geofence.code];
    
    if (lastLocation)
    {
        CLLocationCoordinate2D theLocationCoordinate = lastLocation.coordinate;
        isUserAtRegion = [regionWithGeofence containsCoordinate:theLocationCoordinate];
    }
    else
    {
        isUserAtRegion = NO;
    }
    
    return isUserAtRegion;
}

-(void)locationUserInsideGeofence:(ORCGeofence *)geofence completion:(void (^)(BOOL isInsideRegion))completion;
{
    __weak typeof(self) this = self;
    [self.locationManagerWrapper updateUserLocationWithCompletion:^(CLLocation *location, CLPlacemark *placemark) {
        
        BOOL isAtRegion = [this isUserAtRegion:geofence withLocation:location];
        completion(isAtRegion);
    }];
}

- (CLLocationDistance)distanceFromUserLocationTo:(ORCGeofence *)geofence
{
    CLLocation *userLocation = [self.settingsInteractor loadLastLocation];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[geofence.latitude doubleValue]
                                                      longitude:[geofence.longitude doubleValue]];
    CLLocationDistance distance = [userLocation distanceFromLocation:location];
    
    return distance;
}

- (void)handleGeofence:(ORCGeofence *)geofence
{
    CLLocationDistance distance = [self distanceFromUserLocationTo:geofence];
    [geofence setCurrentDistance:@(distance)];
    
    if (geofence.currentEvent == ORCTypeEventEnter)
    {
        [self needToHandleStayTimeGeofence:geofence];
//        [self scheduleGeofenceIfNeedIt:geofence];
    }
}


#pragma mark - DELEGATE

- (void)didRegionHasBeenFired:(CLRegion *)region event:(ORCTypeEvent)event
{
    ORCRegion *triggerRegion = [self triggerWithIdentifier:region.identifier];
    triggerRegion.currentEvent = event;

    if (triggerRegion.type == ORCTypeGeofence)
    {
        [self handleGeofence:(ORCGeofence *)triggerRegion];
    }
    
    [self requestActionWithRegion:triggerRegion];
    
    if (event == ORCTypeEventExit)
    {
        [ORCPushManager removeLocalNotificationWithId:triggerRegion.code];
    }
}

- (void)didBeaconHasBeenFired:(ORCBeacon *)beacon
{
    [self requestActionWithBeacon:beacon];
}

- (void)didAuthorizationStatusChanged:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            [self startMonitoringAndRangingOfRegions];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            [self stopMonitoringAndRangingOfRegions];
        }
        default:
            break;
    }
}

@end
