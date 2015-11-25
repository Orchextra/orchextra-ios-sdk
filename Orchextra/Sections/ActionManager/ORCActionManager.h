//
//  ORCActionManager.h
//  Orchestra
//
//  Created by Judith Medina on 21/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ORCActionInterface.h"

@class ORCProximityManager;
@class ORCPushManager;
@class ORCAction;

@protocol ORCActionHandlerInterface <NSObject>

- (void)didExecuteActionWithCustomScheme:(NSString *)customScheme;

@end


@interface ORCActionManager : NSObject
<ORCActionInterface>

@property (weak, nonatomic) id<ORCActionHandlerInterface> delegateAction;

+ (instancetype)sharedInstance;
- (instancetype)initWithProximity:(ORCProximityManager *)proximityManager
              notificationManager:(ORCPushManager *)notificationManager;

- (void)startGeoMarketingWithRegions:(NSArray *)geoRegions;
- (void)launchAction:(ORCAction *)action;
- (void)hasLocalNotification:(ORCAction *)action handleAPN:(BOOL)handleAPN;
- (void)updateUserLocation;
- (void)handleLocationEvent:(CLRegion *)region event:(NSInteger)event;

@end
