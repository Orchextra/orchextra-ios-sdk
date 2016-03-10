//
//  ORCPushManager.h
//  Orchestra
//
//  Created by Judith Medina on 29/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ORCPushNotification;
@class ORCAction;
@class ORCGeofence;

typedef void(^CompletionNotification)(void);


@interface ORCPushManager : NSObject

+ (ORCPushManager *)sharedPushManager;
+ (void)storeDeviceToken:(NSData *)deviceToken;
+ (void)handlePush:(id)userInfo;
+ (void)removeLocalNotificationWithId:(NSString *)identifier;

- (void)sendLocalPushNotificationWithAction:(ORCAction *)action;
- (void)sendLocalPushNotificationWithGeofence:(ORCGeofence *)geofence;

- (void)showAlertViewWithTitle:(NSString *)title body:(NSString *)body
                    cancelable:(BOOL)cancelable
                    completion:(CompletionNotification)completion;
@end
