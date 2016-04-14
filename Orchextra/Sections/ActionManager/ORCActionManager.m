
//
//  ORCActionManager.m
//  Orchextra
//
//  Created by Judith Medina on 21/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCActionManager.h"
#import "ORCProximityManager.h"
#import "ORCPushManager.h"
#import "ORCWireframe.h"
#import "ORCAction.h"
#import "ORCGIGLogManager.h"
#import "ORCStatisticsInteractor.h"
#import "ORCValidatorActionInterator.h"


@interface ORCActionManager()

@property (strong, nonatomic) ORCWireframe *wireframe;
@property (strong, nonatomic) ORCProximityManager *proximityManager;
@property (strong, nonatomic) ORCPushManager *pushManager;
@property (strong, nonatomic) ORCStatisticsInteractor *statisticsInteractor;
@property (strong, nonatomic) ORCValidatorActionInterator *validatorInteractor;

@end


@implementation ORCActionManager

+ (instancetype)sharedInstance
{
    static ORCActionManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ORCActionManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    ORCProximityManager *proximityManager = [[ORCProximityManager alloc] initWithActionInterface:self];
    ORCPushManager *notificationManager = [ORCPushManager sharedPushManager];
    ORCStatisticsInteractor *statisticsInteractor = [[ORCStatisticsInteractor alloc] init];
    ORCWireframe *wireframe = [[ORCWireframe alloc] init];
    ORCValidatorActionInterator *validatorInteractor = [[ORCValidatorActionInterator alloc] init];

    return [self initWithProximity:proximityManager
               notificationManager:notificationManager
              statisticsInteractor:statisticsInteractor
               validatorInteractor:validatorInteractor
                         wireframe:wireframe];
}

- (instancetype)initWithProximity:(ORCProximityManager *)proximityManager
              notificationManager:(ORCPushManager *)notificationManager
             statisticsInteractor:(ORCStatisticsInteractor *)statisticsInteractor
                        wireframe:(ORCWireframe *)wireframe
{
    ORCValidatorActionInterator *validatorInteractor = [[ORCValidatorActionInterator alloc] init];
    return [self initWithProximity:proximityManager
               notificationManager:notificationManager
              statisticsInteractor:statisticsInteractor
               validatorInteractor:validatorInteractor
                         wireframe:wireframe];
}

- (instancetype)initWithProximity:(ORCProximityManager *)proximityManager
              notificationManager:(ORCPushManager *)notificationManager
             statisticsInteractor:(ORCStatisticsInteractor *)statisticsInteractor
             validatorInteractor:(ORCValidatorActionInterator *)validatorInteractor
                        wireframe:(ORCWireframe *)wireframe
{
    self = [super init];
    
    if (self)
    {
        _proximityManager = proximityManager;
        _pushManager = notificationManager;
        _validatorInteractor = validatorInteractor;
        _statisticsInteractor = statisticsInteractor;
        _wireframe = wireframe;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)startWithAppConfiguration
{
    [self performUpdateUserLocation];
    [self updateMonitoringAndRangingOfRegions];
}

- (void)performUpdateUserLocation
{
    [self.proximityManager updateUserLocation];
}

- (void)updateMonitoringAndRangingOfRegions
{
    [self.proximityManager startMonitoringAndRangingOfRegions];
}

- (void)stopMonitoringAndRanging
{
    [self.proximityManager stopMonitoringAndRangingOfRegions];
}

- (void)launchAction:(ORCAction *)action
{
    [self.statisticsInteractor trackActionHasBeenLaunched:action];
    [action executeActionWithActionInterface:self];
}

- (void)prepareActionToBeExecute:(ORCAction *)action
{
    if (action.bodyNotification.length > 0)
    {
        [self checkActionWithApplicationState:action];
    }
    else
    {
        [self launchAction:action];
    }
}

- (void)findActionFromGeofence:(ORCGeofence *)geofence
{
    [self.validatorInteractor validateProximityWithGeofence:geofence completion:^(ORCAction *action, NSError *error) {
        
        if (action)
        {
            [self actionFromPushNotification:action];
        }
    }];
}


#pragma mark - PRIVATE

- (void)checkActionWithApplicationState:(ORCAction *)action
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [self executeActionBasedOnScheduleTime:action];
    }
    else
    {
        [self.pushManager sendLocalPushNotificationWithAction:action];
    }
}

- (void)actionFromPushNotification:(ORCAction *)action
{
    __weak typeof(self) this = self;
    [self.pushManager
     showAlertViewWithTitle:action.titleNotification
     body:action.bodyNotification
     cancelable:action.actionWithUserInteraction
                completion:^{
                        [this launchAction:action];
     }];
}

- (void)executeActionBasedOnScheduleTime:(ORCAction *)action
{
    if(action.scheduleTime > 0)
    {
        [self.pushManager sendLocalPushNotificationWithAction:action];
    }
    else
    {
        [self actionFromPushNotification:action];
    }
}

#pragma mark - DELEGATES

- (void)didFireTriggerWithAction:(ORCAction *)action
{
    [self prepareActionToBeExecute:action];
}

- (void)didFireTriggerWithAction:(ORCAction *)action
              fromViewController:(UIViewController *)viewController
{
    __weak typeof (self) this = self;
    [self.wireframe dismissActionWithViewController:viewController completion:^{
        [this prepareActionToBeExecute:action];
    }];
}

#pragma mark - PRIVATE (Navigation)

- (void)presentViewController:(UIViewController *)toViewController
{
    [self.wireframe presentViewController:toViewController];
}

- (void)pushActionToViewController:(UIViewController *)toViewController
{
    [self.wireframe pushActionToViewController:toViewController];
}

- (void)presentActionWithCustomScheme:(NSString *)customScheme
{
    if ([self.delegateAction conformsToProtocol:@protocol(ORCActionHandlerInterface)])
    {
        [self.delegateAction didExecuteActionWithCustomScheme:customScheme];
    }
}


@end
