//
//  ConfigurationInteractor.m
//  Orchestra
//
//  Created by Judith Medina on 5/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "ORCConfigurationInteractor.h"
#import "ORCAppConfigCommunicator.h"
#import "ORCFormatterParameters.h"
#import "ORCAppConfigResponse.h"
#import "ORCLocationStorage.h"
#import "ORCUser.h"
#import "ORCErrorNetworkHandler.h"
#import "NSBundle+ORCBundle.h"

@interface ORCConfigurationInteractor ()

@property (strong, nonatomic) ORCStorage *storage;
@property (strong, nonatomic) ORCLocationStorage *location;
@property (strong, nonatomic) ORCAppConfigCommunicator *communicator;

@end

@implementation ORCConfigurationInteractor

#pragma mark - INIT

- (instancetype)init
{
    ORCStorage *storage = [[ORCStorage alloc] init];
    ORCAppConfigCommunicator *communicator = [[ORCAppConfigCommunicator alloc] init];
    
    return [self initWithStorage:storage communicator:communicator];
}

- (instancetype)initWithStorage:(ORCStorage *)storage communicator:(ORCAppConfigCommunicator *)communicator
{
    self = [super init];
    
    if (self)
    {
        _storage = storage;
        _location = [[ORCLocationStorage alloc] init];
        _communicator = communicator;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)loadProjectWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
                   completion:(CompletionProjectRegions)completion
{
    BOOL hasChanged = [self changedCredentialsWithApikey:apiKey apiSecret:apiSecret];
    
    if (hasChanged)
    {
        [self.storage storeAcessToken:nil];
    }
    
    __weak typeof(self) this = self;
    
    [this.communicator loadConfigurationWithCompletion:^(ORCAppConfigResponse *response) {
        
        if (response.success)
        {
            [this updateConfigurationResponse:response];
            completion(response.geoRegions, nil);
        }
        else
        {
            NSError *error = [self handleErrorWithStatusCode:response.error.code];
            completion(nil, error);
        }
    }];
}

- (void)saveUserData:(ORCUser *)userData
{
    ORCUser *userOld = [self.storage loadCurrentUserData];
    
    if (![userOld isSameUser:userData])
    {
        [self.storage storeUserData:userData];
        
        ORCFormatterParameters *parameters = [[ORCFormatterParameters alloc] init];
        NSDictionary *values = [parameters formattedUserData:userData];
        
        __weak typeof(self) this = self;
        
        [this.communicator loadConfiguration:values completion:^(ORCAppConfigResponse *response) {
            
            if (response.success)
            {
                [this updateConfigurationResponse:response];
            }
        }];
    }
}

- (ORCUser *)currentUser
{
    return [self.storage loadCurrentUserData];
}

#pragma mark - PUBLIC (Configuration)

- (BOOL)isImageRecognitionAvailable
{
    if ([self.storage loadVuforiaConfig])
    {
        return YES;
    }
    return NO;
}

#pragma mark - PUBLIC (Location)

- (void)storeLastLocation:(CLLocation *)location
{
    ORCFormatterParameters *parameters = [[ORCFormatterParameters alloc] init];
    
    NSDictionary *values = [parameters formattedUserLocation:[self.location loadLastLocation]];
    NSDictionary *newValues = [parameters formattedUserLocation:location];
    
    if (![values isEqualToDictionary:newValues])
    {
        [self.location storeLastLocation:location];
        
        __weak typeof(self) this = self;
        
        [this.communicator loadConfiguration:newValues completion:^(ORCAppConfigResponse *response) {
            
        }];
    }
}

- (void)storeLastPlacemark:(CLPlacemark *)placemark
{
    ORCFormatterParameters *parameters = [[ORCFormatterParameters alloc] init];
    
    CLPlacemark *placemarkOld = [self.location loadLastPlacemark];
    NSDictionary *values = [parameters formattedPlacemark:placemarkOld];
    
    NSDictionary *newValues = [parameters formattedPlacemark:placemark];
    
    if (![values isEqual:newValues])
    {
        [self.location storeLastPlacemark:placemark];
        
        [self.communicator loadConfiguration:newValues completion:^(ORCAppConfigResponse *response) {
            
        }];
    }
}

#pragma mark - PRIVATE

- (void)updateConfigurationResponse:(ORCAppConfigResponse *)response
{
    [self.storage storeThemeSdk:response.themeSDK];
    [self.storage storeRequestWaitTime:response.requestWaitTime];
    [self.storage storeVuforiaConfig:response.vuforiaConfig];
}

- (BOOL)changedCredentialsWithApikey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
{
    NSString *previousApiKey = [self.storage loadApiKey];
    NSString *previousApiSecret = [self.storage loadApiSecret];
    
    if ([previousApiKey isEqualToString:apiKey] && [previousApiSecret isEqualToString:apiSecret])
    {
        return NO;
    }
    else
    {
        [self.storage storeApiKey:apiKey];
        [self.storage storeApiSecret:apiSecret];
        return YES;
    }
}

#pragma mark - PRIVATE ( Handle Errors )

- (NSError *)handleErrorWithStatusCode:(NSInteger)statusCode
{
    NSString *errorMessage = nil;
    
    if (ORCErrorCredentials == statusCode) {
        errorMessage =  ORCError_Credentials;
    }
    else
    {
        errorMessage = ORCError_Unexpected;
        
    }

    NSError *error = [NSError errorWithDomain:ORCOrchextraDomain
                                         code:statusCode
                                     userInfo:[NSDictionary dictionaryWithObject:ORCLocalizedBundle(errorMessage, nil, nil)
                                                                          forKey:NSLocalizedDescriptionKey]];
    
    return error;
}

@end
