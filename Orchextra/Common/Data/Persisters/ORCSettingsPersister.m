//
//  ORCDataStorage.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCSettingsPersister.h"
#import "ORCUserLocationPersister.h"
#import "ORCFormatterParameters.h"
#import "ORCRegion.h"
#import "ORCUser.h"
#import "ORCConstants.h"
#import "ORCCustomField.h"

#import "Orchextra.h"

#import "NSUserDefaults+ORCGIGArchive.h"


NSString * const ORCApiKey                      = @"ORCApiKey";
NSString * const ORCApiSecret                   = @"ORCApiSecret";
NSString * const ORCUserKey                     = @"ORCUserKey";
NSString * const ORCConfigDataKey               = @"ORCConfigDataKey";
NSString * const ORCBackgroundTimeKey           = @"ORCBackgroundTimeKey";
NSString * const ORCRequestWaitTimeKey          = @"ORCRequestWaitTimeKey";
NSString * const ORCGIGURLManagerApiKey         = @"ORCGIGURLManagerApiKey";
NSString * const ORCGIGURLManagerApiSecret      = @"ORCGIGURLManagerApiSecret";
NSString * const ORCEnvironment                 = @"ORCEnvironment";

NSString * const ORCGIGURLManagerClientTokenKey = @"ORCGIGURLManagerClientTokenKey";
NSString * const ORCGIGURLManagerAccessTokenKey = @"ORCGIGURLManagerAccessTokenKey";

NSString * const OrchextraState                 = @"OrchextraState";

NSString * const ORCVuforiaConfigDetails        = @"ORCVuforiaConfigDetails";
NSString * const ORCAvailableCustomFields       = @"ORCAvailableCustomFields";
NSString * const ORCDeviceTags                  = @"ORCDeviceTags";
NSString * const ORCDeviceBusinessUnits         = @"ORCDeviceBusinessUnits";

@interface ORCSettingsPersister()

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) ORCUserLocationPersister *locationStorage;

@end

@implementation ORCSettingsPersister

- (instancetype)init
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [self initWithUserDefaults:userDefaults];
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    
    if (self)
    {
        _userDefaults = userDefaults;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (BOOL)loadOrchextraState
{
    return [self.userDefaults boolForKey:OrchextraState];
}

- (void)storeOrchextraState:(BOOL)orchextraState
{
    [self.userDefaults setBool:orchextraState forKey:OrchextraState];
    [self.userDefaults synchronize];
}

- (void)storeApiKey:(NSString *)apiKey
{
    [self.userDefaults setValue:apiKey forKey:ORCApiKey];
    [self.userDefaults synchronize];
}

- (NSString *)loadApiKey
{
    return [self.userDefaults valueForKey:ORCApiKey];
}

- (void)storeApiSecret:(NSString *)apiSecret
{
    [self.userDefaults setValue:apiSecret forKey:ORCApiSecret];
    [self.userDefaults synchronize];
}

- (NSString *)loadApiSecret
{
    return [self.userDefaults valueForKey:ORCApiSecret];
}

- (void)storeUser:(ORCUser *)user
{
    [self.userDefaults archiveObject:user forKey:ORCUserKey];
    [self.userDefaults synchronize];
}

- (ORCUser *)loadCurrentUser
{
    return [self.userDefaults unarchiveObjectForKey:ORCUserKey];
}

- (void)storeBackgroundTime:(NSInteger)backgroundTime
{
    [self.userDefaults setInteger:backgroundTime forKey:ORCBackgroundTimeKey];
    [self.userDefaults synchronize];
}

- (NSInteger)loadBackgroundTime
{
    NSInteger backgroundTime = [self.userDefaults integerForKey:ORCBackgroundTimeKey];
    
    if (backgroundTime < DEFAULT_BACKGROUND_TIME) {
        backgroundTime = DEFAULT_BACKGROUND_TIME;
        [self storeBackgroundTime:DEFAULT_BACKGROUND_TIME];
    }
    
    return backgroundTime;
}

#pragma mark - PUBLIC (Input from Dashboard)

- (void)storeThemeSdk:(ORCThemeSdk *)theme
{
    [self.userDefaults archiveObject:theme forKey:ORCConfigDataKey];
    [self.userDefaults synchronize];
}

- (ORCThemeSdk *)loadThemeSdk
{
    return [self.userDefaults unarchiveObjectForKey:ORCConfigDataKey];
}

- (void)storeRequestWaitTime:(NSInteger)requestWaitTime
{
    [self.userDefaults setInteger:requestWaitTime forKey:ORCRequestWaitTimeKey];
    [self.userDefaults synchronize];
}

- (NSInteger)loadRequestWaitTime
{
    return [self.userDefaults integerForKey:ORCRequestWaitTimeKey];
}

- (NSString *)loadURLEnvironment
{
    return [self.userDefaults valueForKey:ORCEnvironment];
}

- (void)storeURLEnvironment:(NSString *)environment
{
    [self.userDefaults setValue:environment forKey:ORCEnvironment];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Authentication)

- (NSString *)loadAccessToken
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerAccessTokenKey];
}

- (void)storeAcessToken:(NSString *)accessToken
{
    [self.userDefaults archiveObject:accessToken forKey:ORCGIGURLManagerAccessTokenKey];
    [self.userDefaults synchronize];
    
    Orchextra *orchextra = [Orchextra sharedInstance];
    id <OrchextraLoginDelegate> loginDelegate = orchextra.loginDelegate;
    
    if (loginDelegate &&
        [loginDelegate conformsToProtocol: @protocol(OrchextraLoginDelegate)])
    {
        [loginDelegate didUpdateAccessToken:accessToken];
    }
}

- (NSString *)loadClientToken
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerClientTokenKey];
}

- (void)storeClientToken:(NSString *)clientToken
{
    [self.userDefaults archiveObject:clientToken forKey:ORCGIGURLManagerClientTokenKey];
    [self.userDefaults synchronize];
}

- (ORCVuforiaConfig *)loadVuforiaConfig
{
    return [self.userDefaults unarchiveObjectForKey:ORCVuforiaConfigDetails];
}

- (void)storeVuforiaConfig:(ORCVuforiaConfig *)vuforiaConfig
{
    [self.userDefaults archiveObject:vuforiaConfig forKey:ORCVuforiaConfigDetails];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Custom fields)

- (NSArray <ORCCustomField *> *)loadAvailableCustomFields
{
    return [self.userDefaults unarchiveObjectForKey:ORCAvailableCustomFields];
}

- (void)storeAvailableCustomFields:(NSArray <ORCCustomField *> *)availableCustomFields
{
    [self.userDefaults archiveObject:availableCustomFields forKey:ORCAvailableCustomFields];
    [self.userDefaults synchronize];
}

- (NSArray <ORCCustomField *> *)loadCustomFields
{
    ORCUser *user = [self loadCurrentUser];
    return user.customFields;
}

- (void)setCustomFields:(NSArray <ORCCustomField *> *)customFields
{
    ORCUser *user = [self loadCurrentUser];
    user.customFields = customFields;
    [self storeUser:user];
}

- (BOOL)updateCustomFieldValue:(id)value withKey:(NSString *)key
{
    ORCUser *user = [self loadCurrentUser];
    BOOL userUpdated = [user updateCustomFieldValue:value withKey:key];
    
    if (userUpdated)
    {
        [self storeUser:user];
    }
    
    return userUpdated;
}

#pragma mark - PUBLIC (User tags)

- (NSArray <ORCTag *> *)loadUserTags
{
    ORCUser *user = [self loadCurrentUser];
    return user.tags;
}

- (void)setUserTags:(NSArray <ORCTag *> *)userTags
{
    ORCUser *user = [self loadCurrentUser];
    user.tags = userTags;
    [self storeUser:user];
}

#pragma mark - PUBLIC (Device tags)

- (NSArray <ORCTag *> *)loadDeviceTags
{
    return [self.userDefaults unarchiveObjectsForKey:ORCDeviceTags];
}

- (void)setDeviceTags:(NSArray <ORCTag *> *)deviceTags
{
    [self.userDefaults archiveObjects:deviceTags forKey:ORCDeviceTags];
}

#pragma mark - PUBLIC (User business units)

- (NSArray <ORCBusinessUnit *> *)loadUserBusinessUnits
{
    ORCUser *user = [self loadCurrentUser];
    return user.businessUnits;
}

- (void)setUserBusinessUnit:(NSArray <ORCBusinessUnit *> *)userBusinessUnit
{
    ORCUser *user = [self loadCurrentUser];
    user.businessUnits = userBusinessUnit;
    [self storeUser:user];
}

#pragma mark - PUBLIC (Device business units)

- (NSArray <ORCBusinessUnit *> *)loadDeviceBusinessUnits
{
    return [self.userDefaults unarchiveObjectsForKey:ORCDeviceBusinessUnits];
}

- (void)setDeviceBusinessUnits:(NSArray <ORCBusinessUnit *> *)deviceBusinessUnits
{
    [self.userDefaults archiveObjects:deviceBusinessUnits forKey:ORCDeviceBusinessUnits];
}

@end
