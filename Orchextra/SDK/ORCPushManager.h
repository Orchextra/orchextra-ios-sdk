//
//  ORCNotificationManager.h
//  Orchestra
//
//  Created by Judith Medina on 29/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ORCPushNotification;

typedef void(^NotificationButtonClicked)(NSInteger buttonIndex, UIAlertView *alertView);
typedef void(^CompletionNotification)(void);


@interface ORCPushManager : NSObject


+ (ORCPushManager *)sharedPushManager;
+ (void)storeDeviceToken:(NSData *)deviceToken;
+ (void)handlePush:(id)userInfo;

- (void)sendLocalPushNotificationWithValues:(NSDictionary *)notificationValues
                                  handleAPN:(BOOL)handleAPN
                                 completion:(CompletionNotification)completion;


@end
