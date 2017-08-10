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
    NSMutableString *urlRequest = [ORCURLProvider domainAndVersionComponents];
    urlRequest = [[NSMutableString alloc] initWithString:[urlRequest stringByAppendingPathComponent:@"configuration"]];
    
    return urlRequest;
}

+ (NSString *)endPointAction
{
    NSMutableString *urlRequest = [ORCURLProvider domainAndVersionComponents];
    urlRequest = [[NSMutableString alloc] initWithString:[urlRequest stringByAppendingPathComponent:@"action"]];
    
    return urlRequest;
}

+ (NSString *)endPointSecurityToken
{
    NSMutableString *urlRequest = [ORCURLProvider domainAndVersionComponents];
    urlRequest = [[NSMutableString alloc] initWithString:[urlRequest stringByAppendingPathComponent:@"security"]];
    urlRequest = [[NSMutableString alloc] initWithString:[urlRequest stringByAppendingPathComponent:@"token"]];
    
    return urlRequest;
}

+ (NSString *)endPointConfirmAction:(NSString *)actionId
{
    NSMutableString *urlRequest = [ORCURLProvider domainAndVersionComponents];
    urlRequest = [[NSMutableString alloc] initWithString:[urlRequest stringByAppendingPathComponent:@"action"]];
    urlRequest = [[NSMutableString alloc] initWithString:[urlRequest stringByAppendingPathComponent:@"confirm"]];
    urlRequest = [[NSMutableString alloc] initWithString:[urlRequest stringByAppendingPathComponent:actionId]];
    return urlRequest;
}

+(NSString *)domain
{
    ORCSettingsPersister *storage = [[ORCSettingsPersister alloc] init];
    NSString *domain = [storage loadURLEnvironment];
    
    if (!domain) domain = ORCNetworkHost;
    
    return domain;
}

+ (NSMutableString *)domainAndVersionComponents
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:[ORCURLProvider domain]];
    result = [[NSMutableString alloc] initWithString:[result stringByAppendingPathComponent:ORCNetworkVersion]];
    
    return result;
}

@end
