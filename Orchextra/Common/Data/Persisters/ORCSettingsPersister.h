//
//  ORCDataStorage.h
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORCUser;
@class ORCThemeSdk;
@class ORCUserLocationPersister;
@class ORCVuforiaConfig;


@interface ORCSettingsPersister : NSObject

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

// GLOBAL CONFIGURATION
- (BOOL)loadOrchextraState;
- (void)storeOrchextraState:(BOOL)orchextraState;

// CRM CONFIGURATION
- (void)storeUser:(ORCUser *)user;
- (ORCUser *)loadCurrentUser;

- (void)storeBackgroundTime:(NSInteger)backgroundTime;
- (NSInteger)loadBackgroundTime;

// INPUT CRM INFORMATION

- (void)storeThemeSdk:(ORCThemeSdk *)theme;
- (ORCThemeSdk *)loadThemeSdk;

- (void)storeRequestWaitTime:(NSInteger)requestWaitTime;
- (NSInteger)loadRequestWaitTime;


// NETWORK

// Environment
- (NSString *)loadURLEnvironment;
- (void)storeURLEnvironment:(NSString *)environment;

// ApiKey
- (void)storeApiKey:(NSString *)apiKey;
- (NSString *)loadApiKey;

// ApiSecret
- (void)storeApiSecret:(NSString *)apiSecret;
- (NSString *)loadApiSecret;

// AccessToken
- (NSString *)loadAccessToken;
- (void)storeAcessToken:(NSString *)accessToken;

// ClientToken
- (NSString *)loadClientToken;
- (void)storeClientToken:(NSString *)clientToken;

// Vuforia AccessToken
- (ORCVuforiaConfig *)loadVuforiaConfig;
- (void)storeVuforiaConfig:(ORCVuforiaConfig *)vuforiaConfig;

@end
