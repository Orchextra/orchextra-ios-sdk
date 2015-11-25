//
//  ErrorNetworkHandler.m
//  Orchestra
//
//  Created by Judith Medina on 6/11/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "ORCErrorNetworkHandler.h"

@implementation ORCErrorNetworkHandler

NSString * const ORCOrchextraDomain = @"com.orchextra.sdk";

NSString * const ORCError_Unexpected = @"Unexpected Error";

NSInteger ORCErrorCredentials = 403;
NSString * const ORCError_Credentials = @"Incorrect ApiKey or ApiSecret, check them before continuing.";

@end
