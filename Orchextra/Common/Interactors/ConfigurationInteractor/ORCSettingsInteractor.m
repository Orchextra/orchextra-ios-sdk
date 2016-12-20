//
//  ConfigurationInteractor.m
//  Orchestra
//
//  Created by Judith Medina on 5/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "ORCSettingsInteractor.h"
#import "ORCSettingsDataManager.h"
#import "ORCAppConfigCommunicator.h"
#import "ORCAppConfigResponse.h"
#import "ORCBusinessUnit.h"
#import "ORCCustomField.h"
#import "ORCUserLocationPersister.h"
#import "ORCFormatterParameters.h"

#import "ORCUser.h"

#import "NSBundle+ORCBundle.h"
#import "ORCErrorManager.h"

NSInteger const MAX_REGIONS = 20;

@interface ORCSettingsInteractor ()

@property (strong, nonatomic) ORCSettingsPersister *settingsPersister;
@property (strong, nonatomic) ORCUserLocationPersister *userLocationPersister;
@property (strong, nonatomic) ORCAppConfigCommunicator *communicator;
@property (strong, nonatomic) ORCFormatterParameters *formatter;

@end

@implementation ORCSettingsInteractor

#pragma mark - INIT

- (instancetype)init
{
    ORCSettingsPersister *settingsPersister         = [[ORCSettingsPersister alloc] init];
    ORCAppConfigCommunicator *communicator          = [[ORCAppConfigCommunicator alloc] init];
    ORCFormatterParameters *formatterParameters     = [[ORCFormatterParameters alloc] init];
    ORCUserLocationPersister *userLocationPersister =  [[ORCUserLocationPersister alloc] init];
    
    return [self initWithSettingsPersister:settingsPersister
                     userLocationPersister:userLocationPersister
                              communicator:communicator
                                 formatter:formatterParameters];
}

- (instancetype)initWithSettingsPersister:(ORCSettingsPersister *)settingsPersister
                    userLocationPersister:(ORCUserLocationPersister *)userLocationPersister
                             communicator:(ORCAppConfigCommunicator *)communicator
                                formatter:(ORCFormatterParameters *)formatter
{
    self = [super init];
    
    if (self)
    {
        _settingsPersister = settingsPersister;
        _userLocationPersister = userLocationPersister;
        _communicator = communicator;
        _formatter = formatter;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)loadProjectWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
                   completion:(CompletionProjectSettings)completion
{
    BOOL hasChanged = [self changedCredentialsWithApikey:apiKey apiSecret:apiSecret];
    
    if (hasChanged)
    {
        [self.settingsPersister storeClientToken:nil];
        [self.settingsPersister storeAcessToken:nil];
    }
    
    ORCFormatterParameters *formatter = [[ORCFormatterParameters alloc] init];
    NSDictionary *deviceConfiguration = [formatter formatterParameteresDevice];
    
    __weak typeof(self) this = self;
    [self.communicator loadConfiguration:deviceConfiguration sections:nil completion:^(ORCAppConfigResponse *response) {
        if (response.success)
        {
            [this updateConfigurationResponse:response];
            completion(response.success, nil);
        }
        else
        {
            NSError *error = [ORCErrorManager errorWithResponse:response];
            completion(response.success, error);
        }
    }];
}

- (void)saveUser:(ORCUser *)user
{
    if (user)
    {
        [self checkIfNeedToUpdateUser:user];
    }
    else
    {
        [ORCLog logError:@"Cannot save user empty"];
    }
}

- (ORCUser *)currentUser
{
    ORCUser *user = [self.settingsPersister loadCurrentUser];
    
    if (!user)
    {
        user = [[ORCUser alloc] init];
    }
    
    return user;
}

- (void)bindUser:(ORCUser *)user
{
    [self saveUser:user];
}

- (void)unbindUser
{
    [self invalidateTokens];
    
    ORCUser *user = [[ORCUser alloc] init];
    [self saveUser:user];
}

#pragma mark - PUBLIC

- (NSInteger)backgroundTime
{
    return [self.settingsPersister loadBackgroundTime];
}

#pragma mark - PUBLIC (Location)

- (NSArray *)loadRegions
{
    return [self.userLocationPersister loadRegions];
}

- (void)saveRegions:(NSArray *)regions
{
    [self.userLocationPersister storeRegions:regions];
}

- (void)saveOrchextraRunning:(BOOL)orchextraRunning
{
    return [self.settingsPersister storeOrchextraState:orchextraRunning];
}

- (BOOL)isOrchextraRunning
{
    return [self.settingsPersister loadOrchextraState];
}

- (void)saveLastLocation:(CLLocation *)location
      completionCallBack:(CompletionProjectSettings)completion
{
    NSDictionary *values = [self.formatter formattedUserLocation:[self.userLocationPersister loadLastLocation]];
    NSDictionary *newValues = [self.formatter formattedUserLocation:location];
    
    if (![values isEqualToDictionary:newValues])
    {
        [self.userLocationPersister storeLastLocation:location];
        
        NSDictionary *geoLocationValues = @{@"geoLocation" : newValues};
        [self handleLoadConfigurationWithValues:geoLocationValues completionCallBack:completion];
    }
}

- (CLLocation *)loadLastLocation
{
    return [self.userLocationPersister loadLastLocation];
}

- (void)saveLastPlacemark:(CLPlacemark *)placemark
{
    CLPlacemark *placemarkOld = [self.userLocationPersister loadLastPlacemark];
    NSDictionary *values = [self.formatter formattedPlacemark:placemarkOld];
    
    NSDictionary *newValues = [self.formatter formattedPlacemark:placemark];
    
    if (![values isEqual:newValues])
    {
        [self.userLocationPersister storeLastPlacemark:placemark];
    }
}

- (CLPlacemark *)loadLastPlacemark
{
    return [self.userLocationPersister loadLastPlacemark];
}

#pragma mark - PUBLIC (Custom fields)

- (NSArray <ORCCustomField *> *)loadAvailableCustomFields
{
    return [self.settingsPersister loadAvailableCustomFields];
}

- (NSArray <ORCCustomField *> *)loadCustomFields
{
    return [self.settingsPersister loadCustomFields];
}

- (void)saveCustomFields:(NSArray <ORCCustomField *> *)customFields
{
    ORCUser *user = [self currentUser];
    
    if ([user.crmID length] > 0)
    {
        [self.settingsPersister setCustomFields:customFields];
        
    } else
    {
        [ORCLog logError:@"crmID required to set user custom fields"];
    }
}

- (BOOL)updateCustomFieldValue:(id)value withKey:(NSString *)key
{
    return [self.settingsPersister updateCustomFieldValue:value withKey:key];
}

- (void)commitConfiguration
{
    NSDictionary *newValues = [self.formatter formatterParameteresDevice];
    [self handleLoadConfigurationWithValues:newValues completionCallBack:nil];
}

#pragma mark - PUBLIC (User tags)

- (NSArray <ORCTag *> *)loadUserTags
{
    return [self.settingsPersister loadUserTags];
}

- (void)saveUserTags:(NSArray <ORCTag *> *)userTags
{
    ORCUser *user = [self currentUser];
    
    if ([user.crmID length] > 0)
    {
        [self.settingsPersister setUserTags:userTags];
        
    } else
    {
        [ORCLog logError:@"crmID required to set user tags"];
    }
}

#pragma mark - PUBLIC (Device tags)

- (NSArray <ORCTag *> *)loadDeviceTags
{
    return [self.settingsPersister loadDeviceTags];
}

- (void)saveDeviceTags:(NSArray <ORCTag *> *)deviceTags
{
    [self.settingsPersister setDeviceTags:deviceTags];
}

#pragma mark - PUBLIC (User business units)

- (NSArray <ORCBusinessUnit *> *)loadUserBusinessUnits
{
    return [self.settingsPersister loadUserBusinessUnits];
}

- (void)saveUserBusinessUnits:(NSArray <ORCBusinessUnit *> *)userBusinessUnits
{
    ORCUser *user = [self currentUser];
    
    if ([user.crmID length] > 0)
    {
        [self.settingsPersister setUserBusinessUnit:userBusinessUnits];
        
    } else
    {
        [ORCLog logError:@"crmID required to set user business units"];
    }
}

#pragma mark - PUBLIC (Device business units)

- (NSArray <ORCBusinessUnit *> *)loadDeviceBusinessUnits
{
    return [self.settingsPersister loadDeviceBusinessUnits];
}

- (void)saveDeviceBusinessUnits:(NSArray <ORCBusinessUnit *> *)deviceBusinessUnits
{
    [self.settingsPersister setDeviceBusinessUnits:deviceBusinessUnits];
}

#pragma  mark - PUBLIC ()

- (void)invalidateTokens
{
    [self.settingsPersister storeAcessToken:nil];
    [self.settingsPersister storeClientToken:nil];
}

#pragma mark - PRIVATE

- (void)handleLoadConfigurationWithValues:(NSDictionary *)values completionCallBack:(CompletionProjectSettings)completionCallBack
{
    __weak typeof(self) this = self;
    [self.communicator loadConfiguration:values sections:nil completion:^(ORCAppConfigResponse *response) {
        
        if (response.success)
        {
            [ORCLog logVerbose:@" - Configuration Response: %@", response.json];
            [this updateConfigurationResponse:response];
            if(completionCallBack) completionCallBack(YES, nil);
        }
        else
        {
            if(completionCallBack) completionCallBack(NO, response.error);
            
            if (response.data)
            {
                NSError *error = nil;
                id json = [NSJSONSerialization JSONObjectWithData:response.data
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
                [ORCLog logError:[json description]];
            }
        }
    }];
}

- (void)checkIfNeedToUpdateUser:(ORCUser *)user
{
    ORCUser *oldUser = [self currentUser];
    if (![oldUser isSameUser:user])
    {
        [self.settingsPersister storeUser:user];
        
        if ([oldUser crmHasChanged:user])
        {
            [self invalidateTokens];
        }
        
        if ([self.settingsPersister loadOrchextraState])
        {
            [self updateConfigurationForUser:user];
        }
    }
}

- (BOOL)changedCredentialsWithApikey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
{
    NSString *previousApiKey = [self.settingsPersister loadApiKey];
    NSString *previousApiSecret = [self.settingsPersister loadApiSecret];
    
    if ([previousApiKey isEqualToString:apiKey] && [previousApiSecret isEqualToString:apiSecret])
    {
        return NO;
    }
    else
    {
        [self.settingsPersister storeApiKey:apiKey];
        [self.settingsPersister storeApiSecret:apiSecret];
        return YES;
    }
}

- (void)updateConfigurationResponse:(ORCAppConfigResponse *)response
{
    NSArray *regions = [self gatherRegionsWithResponse:response];
    NSArray <ORCCustomField *> *availableCustomFields = response.availableCustomFields;
    NSArray <ORCCustomField *> *userCustomFields = response.userCustomFields;
    NSArray <ORCBusinessUnit *> *userBusinessUnits = response.userBusinessUnits;
    NSArray <ORCTag *> *userTags = response.userTags;
    NSArray <ORCTag *> *deviceTags = response.deviceTags;
    NSArray <ORCBusinessUnit *> *deviceBusinessUnits = response.deviceBusinessUnits;
    
    [self.userLocationPersister storeRegions:regions];
    
    [self.settingsPersister storeThemeSdk:response.themeSDK];
    [self.settingsPersister storeRequestWaitTime:response.requestWaitTime];
    [self.settingsPersister storeVuforiaConfig:response.vuforiaConfig];
    [self.settingsPersister storeAvailableCustomFields:availableCustomFields];
    
    NSArray <ORCCustomField *> *customFields = [self updateUserCustomFields:userCustomFields withAvailableCustomFields:availableCustomFields];
    [self.settingsPersister setCustomFields:customFields];
    [self.settingsPersister setUserTags:userTags];
    [self.settingsPersister setDeviceTags:deviceTags];
    [self.settingsPersister setUserBusinessUnit:userBusinessUnits];
    [self.settingsPersister setDeviceBusinessUnits:deviceBusinessUnits];
}

- (ORCCustomField *)existsKey:(NSString *)key inAvailableCustomFields:(NSArray <ORCCustomField *> *)availableCustomFields
{
    ORCCustomField *result = nil;
    
    for (ORCCustomField *customField in availableCustomFields) {
        
        if ([customField.key isEqualToString:key])
        {
            result = customField;
            break;
        }
    }
    
    return result;
}

- (NSArray <ORCCustomField *> *)updateUserCustomFields:(NSArray <ORCCustomField *> *)userCustomFields withAvailableCustomFields:(NSArray <ORCCustomField *> *)availableCustomFields
{
    NSMutableArray <ORCCustomField *> *result = [[NSMutableArray alloc] init];
    for (ORCCustomField *customField in userCustomFields)
    {
        ORCCustomField *availableCustomField = [self existsKey:customField.key inAvailableCustomFields:availableCustomFields];
        
        if (availableCustomField)
        {
            availableCustomField.value = customField.value;
            [result addObject:availableCustomField];
        }
    }
    
    return [NSArray arrayWithArray:result];
}

- (NSArray *)gatherRegionsWithResponse:(ORCAppConfigResponse *)response
{
    NSMutableArray *regions = [[NSMutableArray alloc] init];
    NSInteger remainingRegions = MAX_REGIONS;
    
    // Get all the beacons
    if (response.beaconRegions.count < MAX_REGIONS)
    {
        [regions addObjectsFromArray:response.beaconRegions];
        remainingRegions = remainingRegions - response.beaconRegions.count;
    }
    
    // Get only as many geofences as we can register.
    for (int i = 0; i < remainingRegions; i++)
    {
        if (response.geoRegions.count > i)
        {
            [regions addObject:response.geoRegions[i]];
        }
        else {
            break;
        }
    }
    
    NSInteger geofencesStored = (response.geoRegions.count > remainingRegions) ? remainingRegions : response.geoRegions.count;
    
    [ORCLog logDebug:@"Beacon_Region to register: %lu", response.beaconRegions.count];
    [ORCLog logDebug:@"Geofences to register: %lu", geofencesStored];
    
    return regions;
}

#pragma mark - PRIVATE (TOKENS)

- (void)invalidateAccessToken
{
    [self.settingsPersister storeAcessToken:nil];
    
    ORCUser *user = [self currentUser];
    [self updateConfigurationForUser:user];
}

- (void)updateConfigurationForUser:(ORCUser *)user
{
    NSDictionary *newValues = [self.formatter formattedUserData:user];
    [self handleLoadConfigurationWithValues:newValues completionCallBack:nil];
}

@end
