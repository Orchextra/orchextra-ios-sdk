//
//  ORCConfig.m
//  Orchextra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCConstants.h"

#pragma mark - Types Trigger

NSString * const ORCTypeBeacon = @"beacon";
NSString * const ORCTypeRegion = @"beacon_region";
NSString * const ORCTypeGeofence = @"geofence";
NSString * const ORCTypeQR = @"qr";
NSString * const ORCTypeBarcode = @"barcode";
NSString * const ORCTypeVuforia = @"vuforia";

#pragma mark - Actions

NSString * const ORCActionLocalPushID = @"notification";
NSString * const ORCActionOpenBrowserID = @"browser";
NSString * const ORCActionOpenWebviewID = @"webview";
NSString * const ORCActionCustomSchemeID = @"custom_scheme";
NSString * const ORCActionOpenScannerID = @"scan";
NSString * const ORCActionVuforiaID = @"scan_vuforia";

#pragma mark - Schemes URL

NSString * const ORCSchemeScanner = @"Orchextra://scanner";
NSString * const ORCSchemeImageRecognition = @"Orchextra://imageRecognition";

#pragma mark - SDK
    
NSString * const ORCSDKVersion = @"2.1.6";

#pragma mark - Network

NSString * const ORCNetworkVersion = @"v1";

BOOL ORCUseFixtures = NO;
BOOL ORCShowLogs = NO;

NSString * const ORCNetworkHost = @"https://sdk.orchextra.io";

#pragma mark 

NSInteger const DEFAULT_BACKGROUND_TIME = 10;
NSInteger const MAX_BACKGROUND_TIME = 180;
NSString * const ORCHEXTRA_TO_LOADURL = @"Orchextra://loadURL:";




