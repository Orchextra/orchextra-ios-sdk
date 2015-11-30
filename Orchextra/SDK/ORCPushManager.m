//
//  ORCNotificationManager.m
//  Orchestra
//
//  Created by Judith Medina on 29/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCPushManager.h"
#import "ORCStorage.h"
#import "ORCUser.h"
#import "ORCPushNotification.h"
#import "NSBundle+ORCBundle.h"
#import "ORCConstants.h"
#import "ORCAction.h"
#import "ORCActionManager.h"
#import "NSDictionary+ORCGIGJSON.h"


NSString * const NOTIFICATION_TITLE = @"title";
NSString * const NOTIFICATION_BODY = @"body";
NSString * const NOTIFICATION_URL = @"url";
NSString * const NOTIFICATION_TYPE = @"type";


@interface ORCPushManager ()
<UIAlertViewDelegate>

@property (strong, nonatomic) CompletionNotification completionNotification;
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
        [self registerPushNotification];
    }
    
    return self;
}

- (void)didReceiveNotification:(ORCPushNotification *)notification
{
    [self showAlertViewWithTitle:notification.title body:notification.body];
}

#pragma mark - PUBLIC

- (void)registerPushNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if(IOS_8_OR_LATER)
    {
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
        }
    }
    else
    {
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)sendLocalPushNotificationWithValues:(NSDictionary *)notificationValues handleAPN:(BOOL)handleAPN
                                 completion:(CompletionNotification)completion
{
    UIApplication *application = [UIApplication sharedApplication];
    
    NSString *title = [notificationValues stringForKey:NOTIFICATION_TITLE];
    NSString *body = [notificationValues stringForKey:NOTIFICATION_BODY];

    if (application.applicationState == UIApplicationStateActive || handleAPN)
    {
        [self showAlertViewWithTitle:title body:body completion:completion];
    }
    else
    {
        NSLog(@"--Send LocalPushNotification : %@", notificationValues);
        UILocalNotification *notification = [self prepareLocalNotificationWithValues:notificationValues];
        [application presentLocalNotificationNow:notification];
    }
}

#pragma mark - Class Methods

+ (void)storeDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [[ORCPushManager sharedPushManager] tokenStringWithData:deviceToken];
    ORCUser *user = [ORCUser currentUser];
    user.deviceToken = deviceTokenString;
    [user saveUser];
}

#pragma mark - HANDLE PUSH NOTIFICATION

+ (void)handlePush:(id)userInfo {

    ORCPushNotification *push = nil;
    if ([userInfo isKindOfClass:[UILocalNotification class]])
    {
        push = [[ORCPushNotification alloc] initWithLocalNotification:(UILocalNotification *)userInfo];
    }
    else
    {
        push = [[ORCPushNotification alloc] initWithRemoteNotification:userInfo];
    }
    
    if (push.type) {
        ORCAction *action = [[ORCAction alloc] initWithType:push.type];
        action.urlString = push.url;
        action.titleNotification = push.title;
        action.messageNotification = push.body;
        
        [[ORCActionManager sharedInstance] hasLocalNotification:action handleAPN:YES];
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    
    if (push.badge) {
        NSInteger number = [push.badge integerValue];
        [application setApplicationIconBadgeNumber:number];
    }
}


#pragma mark - PRIVATE

- (void)showAlertViewWithTitle:(NSString *)title body:(NSString *)body completion:(CompletionNotification)completion
{
    NSString *cancelButtonTitle = ORCLocalizedBundle(@"Ok", nil, nil);
    self.completionNotification = completion;
    self.currentTagAlertView++;

    dispatch_async( dispatch_get_main_queue(), ^{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:body
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
        alert.tag = self.currentTagAlertView;
        [alert show];
    });
}

- (UILocalNotification *)prepareLocalNotificationWithValues:(NSDictionary *)values
{
    NSString *title = [values stringForKey:NOTIFICATION_TITLE];
    NSString *body = [values stringForKey:NOTIFICATION_BODY];
    NSString *url = [values stringForKey:NOTIFICATION_URL];
    NSString *type = [values stringForKey:NOTIFICATION_TYPE];

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (IOS_8_OR_LATER)
    {
        [self setNotificationTypesAllowed];
        
        if (notification)
        {
            if (self.allowsAlert)
            {
                notification.alertBody = body;
                notification.userInfo = @{NOTIFICATION_TITLE : title, NOTIFICATION_URL : url, NOTIFICATION_TYPE : type};
            }
            if (self.allowsSound)
            {
                notification.soundName = UILocalNotificationDefaultSoundName;
            }
        }
    }
    else
    {
        if (notification)
        {
            notification.alertBody = body;
            notification.userInfo = @{NOTIFICATION_TITLE : title, NOTIFICATION_URL : url, NOTIFICATION_TYPE : type};
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

- (void)showAlertViewWithTitle:(NSString *)title body:(NSString *)body
{
    NSString *cancelButtonTitle = ORCLocalizedBundle(@"Ok", nil, nil);
    
    dispatch_async( dispatch_get_main_queue(), ^{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:body
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
        [alert show];
    });
}

#pragma mark - DELEGATE

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.currentTagAlertView == alertView.tag && self.completionNotification)
    {
        self.completionNotification();
    }
}

@end
