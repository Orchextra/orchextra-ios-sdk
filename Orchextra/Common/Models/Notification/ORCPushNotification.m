//
//  ORCPushNotification.m
//  Orchestra
//
//  Created by Judith Medina on 3/8/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCPushNotification.h"
#import "ORCGIGJSON.h"

@implementation ORCPushNotification

- (instancetype)initWithLocalNotification:(UILocalNotification *)notification
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *notificionDic = [notification userInfo];
        
        _type = [notificionDic stringForKey:@"type"];
        
        if ([_type isEqualToString:ORCTypeGeofence])
        {
            _code = [notificionDic stringForKey:@"launchedById"];
            _event = [notificionDic stringForKey:@"event"];
            _distance = [notificionDic stringForKey:@"distance"];
        }
        else if ([_type isEqualToString:ORCTypeCoreBluetooth])
        {
            _coreBluetoothEvent = [notificionDic stringForKey:@"core_bluetooth_event"];
        }
        else
        {
            _trackerId = [notificionDic stringForKey:@"trackId"];
            _title = [notificionDic stringForKey:@"title"];
            _body = [notification alertBody];
            _url = [notificionDic stringForKey:@"url"];
            _launchedBy = [notificionDic stringForKey:@"launchedById"];

        }
    }
    return self;
}

- (instancetype)initWithRemoteNotification:(NSDictionary *)notification
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *aps = [notification dictionaryForKey:@"aps"];
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
