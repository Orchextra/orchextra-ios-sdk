//
//  Orchextra.h
//  Orchextra
//
//  Created by Carlos Vicente on 3/10/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Orchextra.
FOUNDATION_EXPORT double OrchextraVersionNumber;

//! Project version string for Orchextra.
FOUNDATION_EXPORT const unsigned char OrchextraVersionString[];

#import <Orchextra/ORCAction.h>
#import <Orchextra/ORCActionInterface.h>
#import <Orchextra/ORCActionManager.h>
#import <Orchextra/ORCBusinessUnit.h>
#import <Orchextra/ORCCustomField.h>
#import <Orchextra/ORCLog.h>
#import <Orchextra/NSBundle+ORCBundle.h>
#import <Orchextra/ORCPushManager.h>
#import <Orchextra/ORCSettingsDataManager.h>
#import <Orchextra/ORCTag.h>
#import <Orchextra/ORCThemeSDK.h>
#import <Orchextra/ORCUser.h>
#import <Orchextra/ORCValidatorActionInterator.h>
#import <Orchextra/ORCVuforiaConfig.h>
#import <Orchextra/ORCWebViewViewController.h>

@class ORCApplicationCenter;
@class ORCSettingsInteractor;

NS_ASSUME_NONNULL_BEGIN

/**
 *  CoreBluetooth levels are used to define the time to scan out for eddystone beacons.
 */
typedef NS_ENUM(NSUInteger, CoreBluetoothScanLevel)
{
    /**
     *  Core bluetooth scanner always active searching for peripherals.
     */
    CoreBluetoothScanLevelAlways               = 0,
    
    /**
     *  Core bluetooth scanner searaching for peripherals from time to time.
     */
    CoreBluetoothScanLevelScanByIntervals    = 1,
};

@protocol OrchextraCustomActionDelegate <NSObject>

- (void)executeCustomScheme:(NSString *)scheme;

@end

@protocol OrchextraLoginDelegate <NSObject>

@optional

- (void)didUpdateAccessToken:(nullable NSString *)accessToken;

@end


@interface Orchextra : NSObject

@property (weak, nonatomic) id <OrchextraCustomActionDelegate> delegate;
@property (weak, nonatomic, nullable) id <OrchextraLoginDelegate> loginDelegate;
@property (strong, nonatomic) ORCApplicationCenter *applicationCenter;

/**
 Returns an unique instance of Orchextra
 */
+ (instancetype)sharedInstance;

- (instancetype)initWithActionManager:(ORCActionManager *)actionManager
                     configInteractor:(ORCSettingsInteractor *)configInteractor
                    applicationCenter:(ORCApplicationCenter *)applicationCenter;

- (void)setApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
       completion:(void(^)(BOOL success, NSError *error))completion;

/**
 Start scanner action - Will show a default view with the Orchextra scanner
 where the user can scan a barcode or QR code.
 */
- (void)startScanner;

/**
 Stop all services that are running with Orchextra.
 - Location: Beacon and Geofences
 - Stop monitoring app delegate events
 */
- (void)stopOrchextraServices;

/**
 Check if Orchextra is running or has been stopped
 @return BOOL;
 */
- (BOOL)orchextraRunning;

// WEBVIEW - JAVASCRIPT

- (ORCWebViewViewController *)getOrchextraWebViewWithURLWithString:(NSString *)urlString;

// SETTINGS

- (void)bindUser:(ORCUser *)user;
- (void)unbindUser;
- (ORCUser *)currentUser;
- (void)commitConfiguration;

// CUSTOM FIELDS

- (NSArray <ORCCustomField *> *)getAvailableCustomFields;

- (NSArray <ORCCustomField *> *)getCustomFields;
- (void)setCustomFields:(NSArray <ORCCustomField *> *)customFields;
- (BOOL)updateCustomFieldValue:(id)value withKey:(NSString *)key;

// USER TAGS

- (NSArray <ORCTag *> *)getUserTags;
- (void)setUserTags:(NSArray <ORCTag *> *)userTags;

// DEVICE TAGS

- (NSArray <ORCTag *> *)getDeviceTags;
- (void)setDeviceTags:(NSArray <ORCTag *> *)deviceTags;

// USER BUSINESS UNITS

- (NSArray <ORCBusinessUnit *> *)getUserBusinessUnits;
- (void)setUserBusinessUnits:(NSArray <ORCBusinessUnit *> *)businessUnits;

// DEVICE BUSINESS UNITS

- (NSArray <ORCBusinessUnit *> *)getDeviceBusinessUnits;
- (void)setDeviceBussinessUnits:(NSArray <ORCBusinessUnit *> *)deviceBusinessUnits;

// EDDYSTONE BEACONS

- (void)startEddystoneBeaconsScanner;
- (void)stopEddystoneBeaconsScanner;

// DEBUG

+ (void)logLevel:(ORCLogLevel)logLevel;
+ (void)saveLogsToAFile;
+ (void)setCoreBluetoothScannerLevel:(CoreBluetoothScanLevel)scanLevel;

// BACKGROUND FETCH

- (void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

NS_ASSUME_NONNULL_END

@end
