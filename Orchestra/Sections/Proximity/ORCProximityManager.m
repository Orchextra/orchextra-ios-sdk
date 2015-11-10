//
//  GIGGeoMarketing.m
//  Orchestra
//
//  Created by Judith Medina on 17/4/15.
//  Copyright (c) 2015 Judith Medina. All rights reserved.
//

#import "ORCProximityManager.h"
#import "ORCLocationStorage.h"
#import "ORCAction.h"
#import "ORCActionManager.h"
#import "ORCTriggerRegion.h"
#import "ORCTriggerGeofence.h"
#import "ORCTriggerBeacon.h"
#import "ORCValidatorActionInterator.h"
#import "ORCStayInteractor.h"
#import "ORCGIGLogManager.h"


@interface ORCProximityManager ()

@property (weak, nonatomic) id<ORCActionInterface> actionInterface;
@property (strong, nonatomic) ORCValidatorActionInterator *validatorInteractor;
@property (strong, nonatomic) ORCLocationManager *orcLocation;
@property (strong, nonatomic) NSArray *regions;
@property (strong, nonatomic) ORCTriggerBeacon *lastObservedBeacon;

@end


@implementation ORCProximityManager

#pragma mark - INIT

- (instancetype)initWithActionManager:(id<ORCActionInterface>)actionInterface
{
    ORCLocationManager *orcLocation = [[ORCLocationManager alloc] init];
    orcLocation.delegateLocation = self;
    ORCValidatorActionInterator *interactor = [[ORCValidatorActionInterator alloc] init];
    
    return [self initWithCoreLocationManager:orcLocation actionInterface:actionInterface
                                  interactor:interactor];
}

- (instancetype)initWithCoreLocationManager:(ORCLocationManager *)orcLocation
                              actionInterface:(id<ORCActionInterface>)actionInterface
                                 interactor:(ORCValidatorActionInterator *)interactor
{
    self = [super init];
    
    if (self)
    {
        _orcLocation = orcLocation;
        _validatorInteractor = interactor;
        _actionInterface = actionInterface;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)startProximityWithRegions:(NSArray *)geoRegions
{
    [ORCGIGLogManager log:@"Start proximity with %lu", (unsigned long)geoRegions.count];
    
    self.regions = [[NSArray alloc] initWithArray:geoRegions];

    [self.orcLocation stopMonitoringAllRegions];
    
    if ([self.orcLocation isAuthorized])
    {
        [self.orcLocation registerGeoRegions:geoRegions];
        [self.orcLocation updateUserLocation];
    }
    else
    {
        [ORCGIGLogManager error: @"Authorization denied we can't get start location services"];
    }
}

- (void)stopProximity
{
    [self.orcLocation stopMonitoringAllRegions];
}

- (void)updateUserLocation
{
    if ([self.orcLocation isAuthorized])
    {
        [self.orcLocation updateUserLocation];
    }
}

- (void)loadActionWithLocationEvent:(CLRegion *)region event:(NSInteger)event
{
    [self didRegionHasBeenFiredWithRegion:region event:event];
}

#pragma mark - PRIVATE

- (void)startMonitoringRegion:(ORCTriggerRegion *)region
{
    [self.orcLocation registerRegion:region];
}

- (void)stopMonitoringRegion:(ORCTriggerRegion *)region
{
    [self.orcLocation stopMonitoring:region];
}

- (ORCTriggerRegion *)getORCTriggerWithIdentifier:(NSString *)identifier
{
    NSArray *regionsLoaded = [[[ORCLocationStorage alloc] init] loadRegions];
    
    for (ORCTriggerRegion *regionRegistered in regionsLoaded)
    {
        if ([regionRegistered.identifier isEqualToString:identifier])
        {
            return regionRegistered;
        }
    }
    
    return nil;
}

- (BOOL)isUserAtRegion:(CLRegion *)region withLocation:(CLLocation *)lastLocation
{
    BOOL isUserAtRegion = NO;
    
    if (lastLocation)
    {
        CLLocationCoordinate2D theLocationCoordinate = lastLocation.coordinate;
        CLCircularRegion * enterRegion = (CLCircularRegion*)region;
        isUserAtRegion = [enterRegion containsCoordinate:theLocationCoordinate];
    }
    else
    {
        isUserAtRegion = NO;
    }
    
    return isUserAtRegion;
}

-(void)userIsInRegion:(CLRegion *)region completion:(void (^)(BOOL isInsideRegion))completion;
{
    __weak typeof(self) this = self;
    [this.orcLocation updateUserLocationWithCompletion:^(CLLocation *location) {
        
        BOOL isAtRegion = [this isUserAtRegion:region withLocation:location];
        completion(isAtRegion);
    }];
}

#pragma mark - PRIVATE (Validate region)

- (void)requestActionWithGeofence:(ORCTriggerGeofence *)geofence
{
    __weak typeof(self) this = self;
    
    [this.validatorInteractor validateProximityWithGeofence:geofence completion:^(ORCAction *action, NSError *error) {
        
        if (action)
        {
            [this.actionInterface didFireTriggerWithAction:action fromViewController:nil];
        }
    }];
}

- (void)requestActionWithBeacon:(ORCTriggerBeacon *)beacon
{
    __weak typeof(self) this = self;
    
    [this.validatorInteractor validateProximityWithBeacon:beacon completion:^(ORCAction *action, NSError *error) {
        
        if (action)
        {
            [this.actionInterface didFireTriggerWithAction:action fromViewController:nil];
        }

    }];
}

#pragma mark - DELEGATE

- (void)didRegionHasBeenFiredWithRegion:(CLRegion *)region event:(NSInteger)event;
{
    ORCTriggerGeofence *orctrigger = (ORCTriggerGeofence *)[self getORCTriggerWithIdentifier:region.identifier];
    orctrigger.currentEvent = event;
    
    ORCStayInteractor *stayInteractor = [[ORCStayInteractor alloc] init];
    __weak typeof(self) this = self;
    
    CLLocationDistance distance = [self.orcLocation distanceFromUserLocationTo:(CLCircularRegion*)region];
    orctrigger.currentDistance = @(distance);
    [self requestActionWithGeofence:orctrigger];
    
    [stayInteractor performStayRequestWithRegion:orctrigger completion:^(BOOL success) {
        
        if (success)
        {
            [this userIsInRegion:region completion:^(BOOL isInsideRegion) {
                
                CLLocationDistance distance = [self.orcLocation distanceFromUserLocationTo:(CLCircularRegion*)region];
                orctrigger.currentDistance = @(distance);
                orctrigger.currentEvent = ORCtypeEventStay;
                
                if (isInsideRegion)
                {
                    [this requestActionWithGeofence:orctrigger];
                }
            }];
        }
    }];
}

- (void)didBeaconHasBeenFired:(ORCTriggerBeacon *)beacon
{
    
    if (beacon.currentEvent != ORCtypeEventStay)
    {
        [self requestActionWithBeacon:beacon];
    }
    else
    {
        CLProximity proximityBeacon = beacon.currentProximity;
        
        __weak typeof(self) this = self;
        
        ORCStayInteractor *stayInteractor = [[ORCStayInteractor alloc] init];
        
        [stayInteractor performStayRequestWithRegion:beacon completion:^(BOOL success) {
            
            if (success && proximityBeacon == beacon.currentProximity)
            {
                [this.validatorInteractor validateProximityWithBeacon:beacon completion:^(ORCAction *action, NSError *error) {
                    
                }];
            }
        }];
    }
}

- (void)didAuthorizationStatusChanged:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            [self startProximityWithRegions:self.regions];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            [self stopProximity];
        }
        default:
            break;
    }
}

@end
