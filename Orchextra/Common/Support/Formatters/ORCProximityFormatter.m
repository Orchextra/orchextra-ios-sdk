//
//  ORCProximityFormatter.m
//  Orchextra
//
//  Created by Judith Medina on 1/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCProximityFormatter.h"

@implementation ORCProximityFormatter

#pragma mark - FORMATTER

+ (NSString *)proximityEventToString:(NSInteger)typeEvent
{
    switch (typeEvent)
    {
        case 0:
            return @"none";
        case 1:
            return @"enter";
        case 2:
            return @"exit";
        default:
            return @"stay";
    }
}

+ (NSString *)eddystoneRegionEventToString:(regionEvent)typeEvent
{
    switch (typeEvent)
    {
        case regionEventUndetected:
            return @"undetected";
        case regionEventEnter:
            return @"enter";
        case regionEventExit:
            return @"exit";
        case regionEventStay:
            return @"stay";
    }
}

+ (NSString *)applicationStateString
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    switch ( appState )
    {
        case UIApplicationStateActive:
            return @"foreground";
        case UIApplicationStateBackground:
            return @"background";
        default:
            return @"inactive";
    }
}

+ (NSString *)proximityDistanceToString:(CLProximity)proximity
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

+ (NSString *)eddystoneProximityDistanceToString:(proximity)proximity
{
    switch (proximity) {
        case proximityUnknown:
            return @"unknown";
            break;
        case proximityInmediate:
            return @"immediate";
            break;
        case proximityNear:
            return @"near";
            break;
        case proximityFar:
            return @"far";
            break;
    }
}


@end
