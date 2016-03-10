//
//  ORCPushManagerMock.h
//  Orchextra
//
//  Created by Judith Medina on 12/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Orchextra/Orchextra.h>

@interface ORCPushManagerMock : ORCPushManager

@property (assign, nonatomic) BOOL outSendLocalPushNotificationCalled;
@property (assign, nonatomic) BOOL outShowAlertViewWithTitleCalled;

@end
