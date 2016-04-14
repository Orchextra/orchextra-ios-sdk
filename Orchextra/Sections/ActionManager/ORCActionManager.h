//
//  ORCActionManager.h
//  Orchextra
//
//  Created by Judith Medina on 21/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ORCActionInterface.h"
#import "ORCConstants.h"

@class ORCStatisticsInteractor;
@class ORCProximityManager;
@class ORCPushManager;
@class ORCWireframe;
@class ORCAction;
@class ORCRegion;
@class ORCGeofence;
@class ORCValidatorActionInterator;

@protocol ORCActionHandlerInterface <NSObject>

- (void)didExecuteActionWithCustomScheme:(NSString *)customScheme;

@end


@interface ORCActionManager : NSObject
<ORCActionInterface>

@property (weak, nonatomic) id<ORCActionHandlerInterface> delegateAction;

+ (instancetype)sharedInstance;
- (instancetype)initWithProximity:(ORCProximityManager *)proximityManager
              notificationManager:(ORCPushManager *)notificationManager
             statisticsInteractor:(ORCStatisticsInteractor *)statisticsInteractor
                        wireframe:(ORCWireframe *)wireframe;

- (instancetype)initWithProximity:(ORCProximityManager *)proximityManager
              notificationManager:(ORCPushManager *)notificationManager
             statisticsInteractor:(ORCStatisticsInteractor *)statisticsInteractor
              validatorInteractor:(ORCValidatorActionInterator *)validatorInteractor
                        wireframe:(ORCWireframe *)wireframe;

- (void)startWithAppConfiguration;
- (void)stopMonitoringAndRanging;
- (void)launchAction:(ORCAction *)action;

- (void)prepareActionToBeExecute:(ORCAction *)action;
- (void)actionFromPushNotification:(ORCAction *)action;
- (void)findActionFromGeofence:(ORCGeofence *)geofence;

- (void)performUpdateUserLocation;
- (void)updateMonitoringAndRangingOfRegions;

@end
