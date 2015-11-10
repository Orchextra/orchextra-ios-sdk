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


NSString * const NOTIFICATION_TITLE = @"title";
NSString * const NOTIFICATION_BODY = @"body";



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
    if(IOS_8_OR_LATER)
    {
        if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)sendLocalPushNotificationWithValues:(NSDictionary *)notificationValues completion:(CompletionNotification)completion
{
    UIApplication *application = [UIApplication sharedApplication];
    
    NSString *title = notificationValues[NOTIFICATION_TITLE];
    NSString *body = notificationValues[NOTIFICATION_BODY];

    if (application.applicationState == UIApplicationStateActive)
    {
        [self showAlertViewWithTitle:title body:body completion:completion];
    }
    else
    {
        UILocalNotification *notification = [self prepareLocalNotificationWithTitle:title body:body];
        [application presentLocalNotificationNow:notification];
    }
}

#pragma mark - Class Methods

+ (void)storeDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [[ORCPushManager sharedPushManager] tokenStringWithData:deviceToken];
    ORCStorage *storage = [[ORCStorage alloc] init];
    ORCUser *user = [storage loadCurrentUserData];
    user.deviceToken = deviceTokenString;
    [storage storeUserData:user];
}

#pragma mark - HANDLE PUSH NOTIFICATION

+ (void)handlePush:(id)userInfo {

    ORCPushNotification *pushNotification = nil;
    
    if ([userInfo isKindOfClass:[UILocalNotification class]])
    {
        pushNotification = [[ORCPushNotification alloc]
                                                 initWithLocalNotification:(UILocalNotification *)userInfo];
    }
    else
    {
        pushNotification = [[ORCPushNotification alloc] initWithRemoteNotification:userInfo];
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    
    if (pushNotification.body) {
        [[ORCPushManager sharedPushManager] showAlertViewWithTitle:pushNotification.title body:pushNotification.body];

    }
    
    if (pushNotification.badge) {
        NSInteger number = [pushNotification.badge integerValue];
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

- (UILocalNotification *)prepareLocalNotificationWithTitle:(NSString *)title body:(NSString *)body
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (IOS_8_OR_LATER)
    {
        [self setNotificationTypesAllowed];
        
        if (notification)
        {
            if (self.allowsAlert)
            {
                notification.alertBody = body;
                notification.userInfo = @{NOTIFICATION_TITLE : title};
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
            notification.userInfo = @{NOTIFICATION_TITLE : title};
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

- (void)showDefaultAlertView
{
    UILocalNotification *notification = [self
                                         prepareLocalNotificationWithTitle:ORCLocalizedBundle(@"title_default_local_notification", nil, nil)
                                         body:ORCLocalizedBundle(@"body_default_local_notification", nil, nil)];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
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
