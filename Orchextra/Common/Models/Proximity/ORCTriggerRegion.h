//
//  ORCTriggerRegion.h
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ORCAction.h"

@class CLLocationManager;

typedef NS_ENUM(NSInteger, ORCTypeEvent)
{
    ORCTypeEventEnter,
    ORCTypeEventExit,
    ORCtypeEventStay
};

typedef void(^ORCCompletionStayTime)(BOOL success);

@interface ORCTriggerRegion : NSObject <NSCoding>

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL notifyOnEntry;
@property (assign, nonatomic) BOOL notifyOnExit;
@property (assign, nonatomic) NSTimeInterval timer;
@property (assign, nonatomic) NSInteger currentEvent;


- (instancetype)initWithJSON:(NSDictionary *)json;
- (void)registerRegionWithLocationManager:(CLLocationManager *)locationManager;
- (void)stopMonitoringRegionWithLocationManager:(CLLocationManager *)locationManager;
- (CLRegion *)convertToCLRegion;
- (void)canPerformRequestWithCompletion:(ORCCompletionStayTime)completion;


@end
