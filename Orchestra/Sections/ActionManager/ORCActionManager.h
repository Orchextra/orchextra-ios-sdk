//
//  ORCActionManager.h
//  Orchestra
//
//  Created by Judith Medina on 21/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ORCAction.h"

@class ORCProximityManager;
@class ORCPushManager;

@protocol ORCActionHandlerInterface <NSObject>

- (void)didExecuteActionWithCustomScheme:(NSString *)customScheme;

@end


@interface ORCActionManager : NSObject

@property (weak, nonatomic) id<ORCActionHandlerInterface> delegateAction;

- (instancetype)initWithProximity:(ORCProximityManager *)proximityManager
              notificationManager:(ORCPushManager *)notificationManager;

- (void)startGeoMarketingWithRegions:(NSArray *)geoRegions;
- (void)startWithAction:(ORCAction *)action;
- (void)launchAction:(ORCAction *)action;
- (void)updateUserLocation;
- (void)handleLocationEvent:(CLRegion *)region event:(NSInteger)event;

@end
