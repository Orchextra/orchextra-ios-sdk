//
//  ORCTriggerBeacon.m
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCBeacon.h"
#import <CoreLocation/CoreLocation.h>
#import "ORCSettingsPersister.h"
#import "ORCGIGJSON.h"
#import "ORCConstants.h"


NSString *const ORCBeaconUUID = @"beaconUUID";
NSString *const ORCBeaconMajor = @"beaconMajor";
NSString *const ORCBeaconMinor = @"beaconMinor";


@interface ORCBeacon()

@property (strong, nonatomic) NSTimer *farTimer;
@property (strong, nonatomic) NSTimer *nearTimer;
@property (strong, nonatomic) NSTimer *immediateTimer;

@property (assign, nonatomic) BOOL canUseImmediate;
@property (assign, nonatomic) BOOL canUseNear;
@property (assign, nonatomic) BOOL canUseFar;

@end


@implementation ORCBeacon

#pragma mark - INIT

- (instancetype)initWithUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor
{
    self = [super init];
    
    if (self)
    {
        _uuid = uuid;
        _major = major;
        _minor = minor;
        _currentProximity = CLProximityUnknown;
        _canUseFar = YES;
        _canUseImmediate = YES;
        _canUseNear = YES;
        
        self.type = ORCTypeBeacon;
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super initWithJSON:json];
    
    if (self)
    {
        NSUUID *uuidTmp = [[NSUUID alloc] initWithUUIDString:json[@"uuid"]];
        _uuid = uuidTmp;
        
        if ([json[@"major"] isKindOfClass:[NSNull class]])
        {
            _major = nil;
        }
        else
        {
            _major = json[@"major"];
        }
        
        if ([json[@"minor"] isKindOfClass:[NSNull class]])
        {
            _minor = nil;
        }
        else
        {
            _minor = json[@"minor"];
        }
        
        _currentProximity = CLProximityUnknown;
        _canUseFar = YES;
        _canUseImmediate = YES;
        _canUseNear = YES;
        
        self.type = ORCTypeBeacon;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _uuid = [aDecoder decodeObjectForKey:ORCBeaconUUID];
        _major = [aDecoder decodeObjectForKey:ORCBeaconMajor];
        _minor = [aDecoder decodeObjectForKey:ORCBeaconMinor];
        self.type = ORCTypeBeacon;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_uuid forKey:ORCBeaconUUID];
    [aCoder encodeObject:_major forKey:ORCBeaconMajor];
    [aCoder encodeObject:_minor forKey:ORCBeaconMinor];
}

#pragma mark - PUBLIC

- (BOOL)setNewProximity:(CLProximity)newProximity
{
    if ([self canUseProximity:newProximity] && newProximity != CLProximityUnknown)
    {
        [self usingProximity:newProximity];
        self.currentProximity = newProximity;
       
        return YES;
    }
    
    return NO;
}

- (void)registerRegionWithLocationManager:(CLLocationManager *)locationManager
{
    CLBeaconRegion* beaconRegion = nil;
    
    if(self.uuid && self.major && self.minor)
    {
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid
                                                               major:[self.major shortValue]
                                                               minor:[self.minor shortValue]
                                                          identifier:self.code];
    }
    else if(self.uuid && self.major)
    {
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[self.major shortValue]
                                                          identifier:self.code];
    }
    else if(self.uuid)
    {
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:self.code];
    }
    
    BOOL isMonitoring = [locationManager.rangedRegions containsObject:beaconRegion];
    
    if (beaconRegion && !isMonitoring)
    {
        beaconRegion.notifyOnEntry = self.notifyOnEntry;
        beaconRegion.notifyOnExit = self.notifyOnExit;
        beaconRegion.notifyEntryStateOnDisplay = YES;
        
        if(![CLLocationManager isRangingAvailable])
        {
            [ORCLog logError:@"-- ERROR: Ranging beacons is not available.--"];
        }
        else
        {
            [locationManager startMonitoringForRegion:beaconRegion];
            [locationManager startRangingBeaconsInRegion:beaconRegion];
            
            [ORCLog logDebug:@"Monitoring Beacon: %@_%@_%@ -> Remaining: %lu",
             beaconRegion.proximityUUID.UUIDString,
             beaconRegion.major,
             beaconRegion.minor,
             (20 - locationManager.monitoredRegions.count)];
        }
    }
}

- (CLRegion *)convertToCLRegion
{
    CLBeaconRegion* beaconRegion = nil;
    
    if(self.uuid && self.major && self.minor)
    {
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[self.major shortValue]
                                                               minor:[self.minor shortValue] identifier:self.code];
    }
    else if(self.uuid && self.major)
    {
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[self.major shortValue]
                                                          identifier:self.code];
    }
    else if(self.uuid)
    {
        beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:self.code];
    }
    
    if (beaconRegion)
    {
        beaconRegion.notifyOnEntry = self.notifyOnEntry;
        beaconRegion.notifyOnExit = self.notifyOnExit;
        beaconRegion.notifyEntryStateOnDisplay = YES;
    }
    return beaconRegion;
}

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon
{
    if ([beacon.proximityUUID isEqual:self.uuid] &&
        [beacon.major isEqualToNumber:self.major] &&
        [beacon.minor isEqualToNumber:self.minor])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - TIMER

- (BOOL)canUseProximity:(CLProximity)proximity
{
    switch (proximity)
    {
        case CLProximityFar:
            return self.canUseFar;
        case CLProximityNear:
            return self.canUseNear;
        case CLProximityImmediate:
            return self.canUseImmediate;
        default:
            return NO;
    }
}

- (void)usingProximity:(CLProximity)proximity
{
    switch (proximity)
    {
        case CLProximityFar:
            self.canUseFar = NO;
            [self createTimerProximity:self.farTimer proximity:proximity];
            break;
        case CLProximityNear:
            self.canUseNear = NO;
            [self createTimerProximity:self.nearTimer proximity:proximity];
            break;
        case CLProximityImmediate:
            self.canUseImmediate = NO;
            [self createTimerProximity:self.immediateTimer proximity:proximity];
            break;
        default:
            break;
    }
}

- (void)createTimerProximity:(NSTimer *)proximityTimer proximity:(CLProximity)proximity
{
    if (proximityTimer != nil)
    {
        [self invalidateTimerProximity:proximityTimer];
    }
    
    NSInteger requestWaitTime = [[[ORCSettingsPersister alloc] init] loadRequestWaitTime];

    [NSTimer
     scheduledTimerWithTimeInterval:requestWaitTime
     target:self selector:@selector(resetProximityStatus:)
     userInfo:@{@"proximity" : @(proximity)} repeats:NO];
}

- (void)invalidateTimerProximity:(NSTimer *)proximityTimer
{
    [proximityTimer invalidate];
}

- (void)resetProximityStatus:(NSTimer *)timer
{
    NSInteger proximity = [timer.userInfo[@"proximity"] integerValue];
    
    switch (proximity) {
        case CLProximityFar:
            self.canUseFar = YES;
            break;
        case CLProximityNear:
            self.canUseNear = YES;
            break;
        case CLProximityImmediate:
            self.canUseImmediate = YES;
            break;
        default:
            break;
    }
}

@end
