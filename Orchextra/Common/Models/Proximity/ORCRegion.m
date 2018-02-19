//
//  ORCTriggerRegion.m
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCRegion.h"
#import "ORCGIGJSON.h"

NSString *const ORCRegionIdentifier = @"regionIdentifier";
NSString *const ORCRegionCode = @"regionCode";
NSString *const ORCRegionNotifyOnEntry = @"regionNotifyOnEntry";
NSString *const ORCRegionNotifyOnExit = @"regionNotifyOnExit";
NSString *const ORCRegionTimer = @"stayTime";
NSString *const ORCRegionName = @"name";
NSString *const ORCRegionCurrentEvent = @"currentEvent";

@implementation ORCRegion

#pragma mark - INIT

- (instancetype)initWithRegion:(ORCRegion *)region
{
    self = [super init];
    
    if (self)
    {
        _type = (region.type == ORCTypeGeofence) ? ORCTypeGeofence : ORCTypeRegion;
        _identifier     = (region.identifier) ? region.identifier : @"";
        _code           = (region.code) ? region.code : @"";
        _currentEvent   = (region.currentEvent) ? region.currentEvent : ORCTypeEventNone;
        
        [self validateValues];
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    return [self initWithIdentifier:[json stringForKey:@"id"]
                               code:[json stringForKey:@"code"]
                      notifyOnEntry:[json boolForKey:@"notifyOnEntry"]
                       notifyOnExit:[json boolForKey:@"notifyOnExit"]
                        stayTime:[json intForKey:@"stayTime"]
                            name:[json stringForKey:@"name"]
            ];
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                              code:(NSString *)code
                     notifyOnEntry:(BOOL)notifyOnEntry
                      notifyOnExit:(BOOL)notifyOnExit
                          stayTime:(NSInteger)stayTime
                              name:(NSString *)name
{
    self = [super init];
    
    if (self)
    {
        _identifier = identifier;
        _code = code;
        _notifyOnEntry = notifyOnEntry;
        _notifyOnExit = notifyOnExit;
        _timer = stayTime;
        _name = name;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        _identifier = [aDecoder decodeObjectForKey:ORCRegionIdentifier];
        _code = [aDecoder decodeObjectForKey:ORCRegionCode];
        _notifyOnEntry = [aDecoder decodeBoolForKey:ORCRegionNotifyOnEntry];
        _notifyOnExit = [aDecoder decodeBoolForKey:ORCRegionNotifyOnExit];
        _timer = [aDecoder decodeDoubleForKey:ORCRegionTimer];
        _name = [aDecoder decodeObjectForKey:ORCRegionName];
        _currentEvent = [aDecoder decodeIntegerForKey:ORCRegionCurrentEvent];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_identifier forKey:ORCRegionIdentifier];
    [aCoder encodeObject:_code forKey:ORCRegionCode];
    [aCoder encodeBool:_notifyOnEntry forKey:ORCRegionNotifyOnEntry];
    [aCoder encodeBool:_notifyOnExit forKey:ORCRegionNotifyOnExit];
    [aCoder encodeDouble:_timer forKey:ORCRegionTimer];
    [aCoder encodeObject:_name forKey:ORCRegionName];
    [aCoder encodeInteger:_currentEvent forKey:ORCRegionCurrentEvent];
}

- (void)registerRegionWithLocationManager:(CLLocationManager *)locationManager
{
    [self registerRegionWithLocationManager:locationManager];
}

- (CLRegion *)convertToCLRegion
{
    return [self convertToCLRegion];
}

- (void)stopMonitoringRegionWithLocationManager:(CLLocationManager *)locationManager
{
    for (CLRegion *region in locationManager.monitoredRegions)
    {
        if([region.identifier isEqualToString:self.code])
        {
            [locationManager stopMonitoringForRegion:region];
            return;
        }
    }
}

- (void)canPerformRequestWithCompletion:(ORCCompletionStayTime)completion
{
    [self canPerformRequestWithCompletion:completion];
}

- (void)validateValues
{
    if (!self.type) [[ORCLog sharedInstance] logError:@"Region - type: Null"];
    if (!self.identifier) [[ORCLog sharedInstance] logError:@"Region - identifier: Null"];
    if (!self.code) [[ORCLog sharedInstance] logError:@"Region - code: Null"];
    if (!self.currentEvent) [[ORCLog sharedInstance] logError:@"Region - currentEvent: Null"];
}

@end
