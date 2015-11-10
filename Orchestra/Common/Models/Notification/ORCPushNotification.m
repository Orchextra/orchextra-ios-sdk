//
//  ORCPushNotification.m
//  Orchestra
//
//  Created by Judith Medina on 3/8/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCPushNotification.h"

@implementation ORCPushNotification

- (instancetype)initWithLocalNotification:(UILocalNotification *)notification
{
    self = [super init];
    
    if (self)
    {
        _title = [notification userInfo][@"title"];
        _body = [notification alertBody];
        _type = [notification userInfo][@"type"];
        _url = [notification userInfo][@"url"];
    }
    return self;
}

- (instancetype)initWithRemoteNotification:(NSDictionary *)notification
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *aps = notification[@"aps"];
        id alert = aps[@"alert"];
        NSNumber *badgeNumber = aps[@"badge"];
        _badge = badgeNumber;
        
        if ([alert isKindOfClass:[NSString class]]) {
            _body = alert;
        }else if ([alert isKindOfClass:[NSDictionary class]])
        {
            
        }
    }
    return self;
}


@end
