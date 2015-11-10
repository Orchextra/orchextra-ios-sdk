//
//  ORCConfig.m
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCConstants.h"

#pragma mark - Types Trigger

NSString * const ORCTypeBeacon = @"beacon";
NSString * const ORCTypeGeofence = @"geofence";
NSString * const ORCTypeQR = @"qr";
NSString * const ORCTypeBarcode = @"barcode";
NSString * const ORCTypeScan = @"scan";
NSString * const ORCTypeWatermark = @"watermark";

#pragma mark - Actions

NSString * const ORCTypeLocalPush = @"notification";
NSString * const ORCTypeOpenBrowser = @"browser";
NSString * const ORCTypeOpenWebview = @"webview";
NSString * const ORCTypeCustomScheme = @"custom_scheme";
NSString * const ORCTypeVuforia = @"vuforia";

#pragma mark - Schemes URL

NSString * const ORCSchemeScanner = @"Orchextra://scanner";
NSString * const ORCSchemeWatermark = @"Orchextra://watermark";
NSString * const ORCSchemeVuforia = @"Orchextra://vuforia";

#pragma mark - SDK 

NSString * const ORCSDKVersion = @"1.0.0";

#pragma mark - Network 

NSString * const ORCNetworkVersion = @"v1";

BOOL ORCUseFixtures = NO;
BOOL ORCShowLogs = NO;


#ifdef DEBUG

NSString * const ORCNetworkHost = @"https://sdk.s.orchextra.io";

#else

NSString * const ORCNetworkHost = @"https://sdk.orchextra.io";

#endif