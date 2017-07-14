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
NSString * const ORCTypeCoreBluetooth = @"orc_core_bluetooth";


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

#pragma mark - Core Bluetooth

NSString * const ORCCoreBluetoothStart = @"core_bluetooth_start";
NSString * const ORCCoreBluetoothStop = @"core_bluetooth_stop";


#pragma mark - SDK
    
NSString * const ORCSDKVersion = @"2.1.4";

#pragma mark - Network

NSString * const ORCNetworkVersion = @"v1";

BOOL ORCUseFixtures = NO;
BOOL ORCShowLogs = NO;

//NSString * const ORCNetworkHost = @"https://sdk.orchextra.io";

NSString * const ORCNetworkHost = @"https://sdk-demo-1.s.orchextra.io";

#pragma mark 

NSInteger const DEFAULT_BACKGROUND_TIME = 10;
NSInteger const MAX_BACKGROUND_TIME = 180;
NSString * const ORCHEXTRA_TO_LOADURL = @"Orchextra://loadURL:";




