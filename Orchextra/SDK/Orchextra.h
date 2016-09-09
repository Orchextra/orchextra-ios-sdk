//
//  Orchestra.h
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ORCAction.h"
#import "ORCBusinessUnit.h"
#import "ORCCustomField.h"
#import "ORCUser.h"
#import "ORCTag.h"
#import "ORCPushManager.h"
#import "ORCActionManager.h"

#import "ORCVuforiaConfig.h"
#import "ORCConstants.h"
#import "ORCSettingsDataManager.h"
#import "ORCActionInterface.h"
#import "OrchextraOutputInterface.h"
#import "ORCValidatorActionInterator.h"
#import "ORCLog.h"
#import "ORCWebViewViewController.h"


@class ORCApplicationCenter;
@class ORCSettingsInteractor;


@protocol OrchextraCustomActionDelegate <NSObject>

- (void)executeCustomScheme:(NSString *)scheme;

@end


@interface Orchextra : NSObject

@property (weak, nonatomic) id <OrchextraCustomActionDelegate> delegate;
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

// DEBUG

+ (void)logLevel:(ORCLogLevel)logLevel;
+ (void)saveLogsToAFile;


@end
