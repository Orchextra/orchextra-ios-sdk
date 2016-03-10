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
    ORCSettingsPersister *settingsPersister           = [[ORCSettingsPersister alloc] init];
    ORCAppConfigCommunicator *communicator  = [[ORCAppConfigCommunicator alloc] init];
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
        [self.settingsPersister storeAcessToken:nil];
    }
    
    __weak typeof(self) this = self;
    
    ORCFormatterParameters *formatter = [[ORCFormatterParameters alloc] init];
    NSDictionary *deviceConfiguration = [formatter formatterParameteresDevice];
    
    [self.communicator loadConfiguration:deviceConfiguration completion:^(ORCAppConfigResponse *response) {
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

#pragma mark - PRIVATE

- (void)handleLoadConfigurationWithValues:(NSDictionary *)values completionCallBack:(CompletionProjectSettings)completionCallBack
{
    __weak typeof(self) this = self;
    [self.communicator loadConfiguration:values completion:^(ORCAppConfigResponse *response) {
        
        if (response.success)
        {
            [this updateConfigurationResponse:response];
            if(completionCallBack) completionCallBack(YES, nil);
        }
        else
        {
            if(completionCallBack) completionCallBack(NO, response.error);
            [ORCLog logError:response.error.debugDescription];
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
            [self.settingsPersister storeAcessToken:nil];
        }

        NSDictionary *newValues = [self.formatter formattedUserData:user];
        [self handleLoadConfigurationWithValues:newValues completionCallBack:nil];
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
    [self.userLocationPersister storeRegions:regions];

    [self.settingsPersister storeThemeSdk:response.themeSDK];
    [self.settingsPersister storeRequestWaitTime:response.requestWaitTime];
    [self.settingsPersister storeVuforiaConfig:response.vuforiaConfig];
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

@end
