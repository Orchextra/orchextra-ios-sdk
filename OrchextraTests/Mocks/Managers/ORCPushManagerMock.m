//
//  ORCPushManagerMock.m
//  Orchextra
//
//  Created by Judith Medina on 12/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCPushManagerMock.h"

@implementation ORCPushManagerMock

- (void)sendLocalPushNotificationWithAction:(ORCAction *)action
{
    self.outSendLocalPushNotificationCalled = YES;
}

- (void)showAlertViewWithTitle:(NSString *)title body:(NSString *)body cancelable:(BOOL)cancelable
                    completion:(CompletionNotification)completion
{
    self.outShowAlertViewWithTitleCalled = YES;

}

@end
