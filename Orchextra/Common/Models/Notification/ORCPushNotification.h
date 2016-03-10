//
//  ORCPushNotification.h
//  Orchestra
//
//  Created by Judith Medina on 3/8/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORCPushNotification : NSObject

@property (strong, nonatomic) NSString *type;

// ACTION
@property (strong, nonatomic) NSString *trackerId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber *badge;
@property (strong, nonatomic) NSString *launchedBy;

// TRIGGER
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *event;


- (instancetype)initWithLocalNotification:(UILocalNotification *)notification;
- (instancetype)initWithRemoteNotification:(NSDictionary *)notification;

@end
