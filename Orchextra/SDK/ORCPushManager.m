//
//  ORCPushManager.m
//  Orchextra
//
//  Created by Judith Medina on 29/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCPushManager.h"
#import "Orchextra.h"
#import "ORCPushNotification.h"
#import "ORCActionManager.h"
#import "ORCConstants.h"
#import "ORCUser.h"
#import "ORCAction.h"
#import "ORCGeofence.h"

#import "ORCSettingsInteractor.h"
#import "ORCValidatorActionInterator.h"

#import "NSDictionary+ORCGIGJSON.h"
#import "NSBundle+ORCBundle.h"

#import <UserNotifications/UserNotifications.h>

NSString * const NOTIFICATION_ACTION_ID = @"id";
NSString * const NOTIFICATION_TITLE = @"title";
NSString * const NOTIFICATION_BODY = @"body";
NSString * const NOTIFICATION_URL = @"url";
NSString * const NOTIFICATION_TYPE = @"type";


@interface ORCPushManager ()
<UIAlertViewDelegate>

@property (strong, nonatomic) CompletionNotification completionNotification;
@property (strong, nonatomic) NSMutableArray *notificationCompletions;

@property (assign, nonatomic) BOOL allowsNotification;
@property (assign, nonatomic) BOOL allowsSound;
@property (assign, nonatomic) BOOL allowsBadge;
@property (assign, nonatomic) BOOL allowsAlert;
@property (assign, nonatomic) NSInteger currentTagAlertView;

@end

@implementation ORCPushManager

+ (ORCPushManager *)sharedPushManager
{
    static ORCPushManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ORCPushManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _currentTagAlertView = 0;
        _notificationCompletions = [[NSMutableArray alloc] init];

        [self registerPushNotification];
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)registerPushNotification
{
    UIApplication *application = [UIApplication sharedApplication];

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType types =  UIUserNotificationTypeBadge |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:types
                                                categories:nil];
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
}

- (void)sendLocalPushNotificationWithAction:(ORCAction *)action
{
    [self scheduleLocalPushNotificationWithAction:action];
}

- (void)sendLocalPushNotificationWithGeofence:(ORCGeofence *)geofence
{
    [self scheduleLocalPushNotificationWithGeofence:geofence];
}

+ (void)removeLocalNotificationWithId:(NSString *)identifier
{
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *localNotifications = [app scheduledLocalNotifications];
    [ORCLog logDebug:@"Local Notifications: %d", localNotifications.count];
    
    for (UILocalNotification *localNotification in localNotifications) {
        
        NSString *idNotification = localNotification.userInfo[@"launchedById"];
        
        if ([idNotification isEqualToString:identifier])
        {
            BOOL cancelable = [localNotification.userInfo boolForKey:@"cancelable"];
            if (cancelable)
            {
                [app cancelLocalNotification:localNotification];
                [ORCLog logDebug:@"Removed localNotification with id: %@", idNotification];
            }
            
            break;
        }
    }
}

#pragma mark - Class Methods

+ (void)storeDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [[ORCPushManager sharedPushManager]
                                   tokenStringWithData:deviceToken];
    
    Orchextra *orchextra = [Orchextra sharedInstance];
    ORCUser *user = [orchextra currentUser];
    
    if (!user)
    {
        user = [[ORCUser alloc] init];
    }
    user.deviceToken = deviceTokenString;
    [orchextra bindUser:user];
}

#pragma mark - HANDLE PUSH NOTIFICATION

+ (void)handlePush:(id)userInfo {

    ORCPushNotification *push = nil;
    
    Orchextra *orchextra = [Orchextra sharedInstance];
    BOOL isRunningOrchextra = [orchextra orchextraRunning];
    
    if (isRunningOrchextra)
    {
        if ([userInfo isKindOfClass:[UILocalNotification class]])
        {
            push = [[ORCPushNotification alloc] initWithLocalNotification:(UILocalNotification *)userInfo];
        }
        else if ([userInfo isKindOfClass:[UNNotification class]])
        {
            push = [[ORCPushNotification alloc] initWithNotification:(UNNotification *)userInfo];
        }
        else
        {
            push = [[ORCPushNotification alloc] initWithRemoteNotification:userInfo];
        }
        
        if (![push.type isEqualToString:ORCTypeGeofence])
        {
            ORCAction *action = [[ORCAction alloc] initWithType:push.type];
            action.urlString = push.url;
            action.titleNotification = push.title;
            action.bodyNotification = push.body;
            action.trackId = push.trackerId;
            action.launchedByTriggerCode = push.launchedBy;
            
            [[ORCActionManager sharedInstance] actionFromPushNotification:action];
        }
        else
        {
            ORCGeofence *geofence = [[ORCGeofence alloc] init];
            geofence.type = ORCTypeGeofence;
            geofence.code = push.code;
            geofence.currentEvent = ORCtypeEventStay;
            geofence.currentDistance = @([push.distance doubleValue]);
            
            [[ORCActionManager sharedInstance] findActionFromGeofence:geofence];
        }
        
        UIApplication *application = [UIApplication sharedApplication];
        
        if (push.badge)
        {
            NSInteger number = [push.badge integerValue];
            [application setApplicationIconBadgeNumber:number];
        }

    }
}

#pragma mark - PRIVATE

- (void)scheduleLocalPushNotificationWithAction:(ORCAction *)action
{
    NSDictionary *values = [action toDictionary];
    NSDate *fireDate = [[NSDate date] dateByAddingTimeInterval:action.scheduleTime];

    [ORCLog logDebug:@"--SCHEDULE LOCAL PUSH NOTIFICATION: \n%@ ", values];
    UILocalNotification *notification = [self prepareLocalNotificationWithUserInfo:values];
    notification.fireDate = fireDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)scheduleLocalPushNotificationWithGeofence:(ORCGeofence *)geofence
{
    NSDictionary *values = [geofence toDictionary];
    NSDate *fireDate = [[NSDate date] dateByAddingTimeInterval:geofence.timer];
    [ORCLog logDebug:@"--SCHEDULE LOCAL PUSH NOTIFICATION WITH GEOFENCE: \n%@", values];
    UILocalNotification *notification = [self prepareLocalNotificationWithUserInfo:values];
    notification.fireDate = fireDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)showAlertViewWithTitle:(NSString *)title body:(NSString *)body
                    cancelable:(BOOL)cancelable
                    completion:(CompletionNotification)completion
{
    NSString *cancelButtonTitle = LocalizableConstants.kLocaleOrcGlobalCancelButton;
    NSString *okButtonTitle = LocalizableConstants.kLocaleOrcGlobalOkUppercasedButton;

    [self.notificationCompletions addObject:completion];
    self.completionNotification = completion;

    dispatch_async( dispatch_get_main_queue(), ^{
        
        UIAlertView *alert = nil;
        
        if (cancelable)
        {
           alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:body
                                                           delegate:self
                                                  cancelButtonTitle:okButtonTitle
                                                  otherButtonTitles:cancelButtonTitle, nil];
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:title
                                               message:body
                                              delegate:self
                                     cancelButtonTitle:okButtonTitle
                                     otherButtonTitles:nil];
        }

        alert.tag = self.currentTagAlertView;
        self.currentTagAlertView++;
        [alert show];
    });
}

- (UILocalNotification *)prepareLocalNotificationWithUserInfo:(NSDictionary *)userInfo
{
    NSString *body = [userInfo stringForKey:NOTIFICATION_BODY];

    UILocalNotification *notification = [[UILocalNotification alloc] init];

    [self setNotificationTypesAllowed];
    
    if (notification)
    {
        if (self.allowsAlert)
        {
            notification.alertBody = body;
            notification.userInfo =userInfo;
        }
        if (self.allowsSound)
        {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
    }
    
    return notification;
}

- (void)setNotificationTypesAllowed
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    self.allowsNotification = (currentSettings.types != UIUserNotificationTypeNone);
    self.allowsSound = (currentSettings.types & UIUserNotificationTypeSound) != 0;
    self.allowsBadge = (currentSettings.types & UIUserNotificationTypeBadge) != 0;
    self.allowsAlert = (currentSettings.types & UIUserNotificationTypeAlert) != 0;
}

- (NSString *)tokenStringWithData:(NSData *)data
{
    NSString *token = [data description];
    
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return token;
}

#pragma mark - DELEGATE

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        CompletionNotification completion = self.notificationCompletions[alertView.tag];
        if (completion)
        {
            completion();
        }
    }
}

@end
