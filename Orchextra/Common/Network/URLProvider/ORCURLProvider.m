//
//  ORCURLProvider.m
//  Orchestra
//
//  Created by Judith Medina on 16/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCURLProvider.h"
#import "ORCConstants.h"
#import "ORCSettingsPersister.h"

@implementation ORCURLProvider

+ (NSString *)endPointConfiguration
{
    return [NSString stringWithFormat:@"%@/%@/configuration", [ORCURLProvider domain], ORCNetworkVersion];
}

+ (NSString *)endPointAction
{
    return [NSString stringWithFormat:@"%@/%@/action", [ORCURLProvider domain], ORCNetworkVersion];
}

+ (NSString *)endPointSecurityToken
{
    NSString *urlRequest = [NSString stringWithFormat:@"%@/%@/security/token", [ORCURLProvider domain], ORCNetworkVersion];
    return urlRequest;
}

+ (NSString *)endPointConfirmAction:(NSString *)actionId
{
    NSString *urlRequest = [NSString stringWithFormat:@"%@/%@/action/confirm/%@", [ORCURLProvider domain], ORCNetworkVersion, actionId];
    return urlRequest;
}

+(NSString *)domain
{
    ORCSettingsPersister *storage = [[ORCSettingsPersister alloc] init];
    NSString *domain = [storage loadURLEnvironment];
    
    if (!domain) domain = ORCNetworkHost;
    
    return domain;
}

@end
