
//
//  ORCActionManager.m
//  Orchestra
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

@interface ORCActionManager()

@property (strong, nonatomic) ORCWireframe *wireframe;
@property (strong, nonatomic) ORCProximityManager *proximityManager;
@property (strong, nonatomic) ORCPushManager *notificationManager;

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
    ORCProximityManager *proximityManager = [[ORCProximityManager alloc] initWithActionManager:self];
    ORCPushManager *notificationManager = [ORCPushManager sharedPushManager];

    return [self initWithProximity:proximityManager notificationManager:notificationManager];
}

- (instancetype)initWithProximity:(ORCProximityManager *)proximityManager
              notificationManager:(ORCPushManager *)notificationManager
{

    self = [super init];
    
    if (self)
    {
        _proximityManager = proximityManager;
        _notificationManager = notificationManager;
        _wireframe = [[ORCWireframe alloc] init];
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)startGeoMarketingWithRegions:(NSArray *)geoRegions
{
    if(geoRegions.count > 0)
    {
        [self.proximityManager startProximityWithRegions:geoRegions];
    }
    else
    {
        [self.proximityManager stopProximity];
    }
}

- (void)updateUserLocation
{
    [self.proximityManager updateUserLocation];
}

- (void)handleLocationEvent:(CLRegion *)region event:(NSInteger)event
{
    [self.proximityManager loadActionWithLocationEvent:region event:event];
}

#pragma mark - Parse Actions

#pragma mark - PRIVATE

- (void)launchAction:(ORCAction *)action
{
    [ORCGIGLogManager log:@"[Orchextra] - Launch Action : %@", action.type];
    [action executeActionWithActionInterface:self];
}

- (void)hasLocalNotification:(ORCAction *)action handleAPN:(BOOL)handleAPN
{
    if (action.messageNotification.length > 0)
    {
        [ORCGIGLogManager log:@"[Orchextra] - Action With notification: %@", action.type];
        NSDictionary *notificationValues = @{@"title" : action.titleNotification,
                                             @"body" : action.messageNotification,
                                             @"type" : action.type,
                                             @"url" : action.urlString};

        __weak typeof(self) this = self;
        [self.notificationManager sendLocalPushNotificationWithValues:notificationValues handleAPN:handleAPN completion:^{
            [this launchAction:action];
        }];
        
    }
    else
    {
        [self launchAction:action];
    }
}

#pragma mark - DELEGATES

- (void)didFireTriggerWithAction:(ORCAction *)action fromViewController:(UIViewController *)viewController
{
    __weak typeof (self) this = self;
    [self.wireframe dismissActionWithViewController:viewController completion:^{
        [this hasLocalNotification:action handleAPN:NO];
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
