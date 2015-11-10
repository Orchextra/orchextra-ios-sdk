//
//  ORCConfig.h
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


#pragma mark - Types Trigger

extern NSString * const ORCTypeBeacon;
extern NSString * const ORCTypeGeofence;
extern NSString * const ORCTypeQR;
extern NSString * const ORCTypeBarcode;
extern NSString * const ORCTypeWatermark;
extern NSString * const ORCTypeScan;

#pragma mark - Actions

extern NSString * const ORCTypeLocalPush;
extern NSString * const ORCTypeOpenBrowser;
extern NSString * const ORCTypeOpenWebview;
extern NSString * const ORCTypeVuforia;
extern NSString * const ORCTypeCustomScheme;

#pragma mark - Schemes

extern NSString * const ORCSchemeScanner;
extern NSString * const ORCSchemeWatermark;
extern NSString * const ORCSchemeVuforia;

#pragma mark - SDK

extern NSString * const ORCSDKVersion;

#pragma mark - Network

extern BOOL ORCUseFixtures;
extern NSString * const ORCNetworkVersion;
extern NSString * const ORCNetworkHost;

#pragma mark - Logs
extern BOOL ORCShowLogs;

