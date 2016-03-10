//
//  ORCURLProvider.h
//  Orchestra
//
//  Created by Judith Medina on 16/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORCURLProvider : NSObject

+(NSString *)domain;

+ (NSString *)endPointConfiguration;
+ (NSString *)endPointAction;
+ (NSString *)endPointSecurityToken;
+ (NSString *)endPointConfirmAction:(NSString *)actionId;

@end
