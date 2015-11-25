//
//  ORCDevice.m
//  Orchestra
//
//  Created by Judith Medina on 6/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCDevice.h"
#import "NSBundle+ORCGIGExtension.h"

#import <AdSupport/AdSupport.h>

NSString * const IPHONE_DEVICE = @"Iphone";
NSString * const IPAD_DEVICE = @"Ipad";

@implementation ORCDevice

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        UIDevice *device = [UIDevice currentDevice];
        _advertisingID  = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        _vendorID       = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        _versionIOS     = [device systemVersion];
        _deviceOS       = [device systemName];
        _handset        = ([device userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? IPHONE_DEVICE : IPAD_DEVICE;
        _language       = [[NSLocale currentLocale] localeIdentifier];
        _bundleId       = [[NSBundle mainBundle] bundleIdentifier];
        _appVersion     = [NSBundle version];
        _buildVersion   = [NSBundle build];
        _timeZone       = [[NSTimeZone localTimeZone] name];
    }
    
    return self;
}

@end
