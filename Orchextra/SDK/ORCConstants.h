//
//  ORCConfig.h
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOG_LEVEL_DEF ddLogLevel

#define IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


#pragma mark - Types Trigger

extern NSString * const ORCTypeBeacon;
extern NSString * const ORCTypeRegion;
extern NSString * const ORCTypeGeofence;
extern NSString * const ORCTypeQR;
extern NSString * const ORCTypeBarcode;
extern NSString * const ORCTypeWatermark;
extern NSString * const ORCTypeScan;
extern NSString * const ORCTypeVuforia;

#pragma mark - Actions

extern NSString * const ORCActionLocalPushID;
extern NSString * const ORCActionOpenBrowserID;
extern NSString * const ORCActionOpenWebviewID;
extern NSString * const ORCActionOpenScannerID;
extern NSString * const ORCActionVuforiaID;
extern NSString * const ORCActionCustomSchemeID;

#pragma mark - Schemes

extern NSString * const ORCSchemeScanner;
extern NSString * const ORCSchemeImageRecognition;

#pragma mark - SDK

extern NSString * const ORCSDKVersion;

#pragma mark - Network

extern BOOL ORCUseFixtures;

extern NSString * const ORCNetworkVersion;
extern NSString * const ORCNetworkHost;

#pragma mark - Logs

extern BOOL ORCShowLogs;

#pragma mark - Background Time

extern NSInteger const DEFAULT_BACKGROUND_TIME;
extern NSInteger const MAX_BACKGROUND_TIME;
extern NSString * const ORCHEXTRA_TO_LOADURL;

#pragma mark - Completion
typedef void(^ORCCompletionUserLocation)(CLLocation *location, CLPlacemark *placemark);
