//
//  Orchestra.h
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ORCAction.h"
#import "ORCUser.h"
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


@class ORCSettingsInteractor;
@class ORCApplicationCenter;

@protocol OrchextraCustomActionDelegate <NSObject>

- (void)executeCustomScheme:(NSString *)scheme;

@end


@interface Orchextra : NSObject

@property (weak, nonatomic) id <OrchextraCustomActionDelegate> delegate;
@property (strong, nonatomic) ORCApplicationCenter *applicationCenter;

+ (instancetype)sharedInstance;
- (instancetype)initWithActionManager:(ORCActionManager *)actionManager
                     configInteractor:(ORCSettingsInteractor *)configInteractor
                    applicationCenter:(ORCApplicationCenter *)applicationCenter;

- (void)setApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
       completion:(void(^)(BOOL success, NSError *error))completion;

- (void)startScanner;
- (void)stopOrchextraServices;

// WEBVIEW - JAVASCRIPT

- (ORCWebViewViewController *)getOrchextraWebViewWithURLWithString:(NSString *)urlString;

// SETTINGS

- (void)setUser:(ORCUser *)user;
- (ORCUser *)currentUser;

// DEBUG

+ (void)logLevel:(ORCLogLevel)logLevel;
+ (void)saveLogsToAFile;


@end
