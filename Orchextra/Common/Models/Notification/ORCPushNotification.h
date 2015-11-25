//
//  ORCPushNotification.h
//  Orchestra
//
//  Created by Judith Medina on 3/8/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORCPushNotification : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *badge;


- (instancetype)initWithLocalNotification:(UILocalNotification *)notification;
- (instancetype)initWithRemoteNotification:(NSDictionary *)notification;

@end
