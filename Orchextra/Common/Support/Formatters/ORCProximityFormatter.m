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
            return @"enter";
        case 1:
            return @"exit";
        default:
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

@end
