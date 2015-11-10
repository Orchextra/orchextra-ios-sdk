
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
#import "ORCActionInterface.h"
#import "ORCWireframe.h"

@interface ORCActionManager()
<ORCActionInterface>

@property (strong, nonatomic) ORCWireframe *wireframe;
@property (strong, nonatomic) ORCProximityManager *proximityManager;
@property (strong, nonatomic) ORCPushManager *notificationManager;

@end


@implementation ORCActionManager

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

- (void)startWithAction:(ORCAction *)action
{
    [self launchAction:action];
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
    [action executeActionWithActionInterface:self];
}

- (void)hasLocalNotification:(ORCAction *)action
{
    if (action.messageNotification.length > 0)
    {
        NSDictionary *notificationValues = @{@"title" : action.titleNotification,
                                             @"body" : action.messageNotification,
                                             @"type" : action.type,
                                             @"url" : action.urlString};

        __weak typeof(self) this = self;

        [self.notificationManager sendLocalPushNotificationWithValues:notificationValues completion:^{
            [this launchAction:action];
        }];
        
    }
    else
    {
        NSLog(@"--Action: %@", action.type);
        [self launchAction:action];
    }
}

#pragma mark - DELEGATES

- (void)didFireTriggerWithAction:(ORCAction *)action fromViewController:(UIViewController *)viewController
{
    __weak typeof (self) this = self;
    [this.wireframe dismissActionWithViewController:viewController completion:^{
        [this hasLocalNotification:action];
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
