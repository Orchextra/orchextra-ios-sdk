//
//  ORCValidatorActionIterator.m
//  Orchestra
//
//  Created by Judith Medina on 6/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCValidatorActionInterator.h"
#import "ORCTriggerBeacon.h"
#import "ORCTriggerGeofence.h"
#import "ORCAction.h"
#import "ORCGIGLogManager.h"


NSString * const TYPE_KEY = @"type";
NSString * const VALUE_KEY = @"value";
NSString * const EVENT_KEY = @"event";
NSString * const PHONE_STATUS_KEY = @"phoneStatus";
NSString * const DISTANCE_KEY = @"distance";

NSString * const DOMAIN_ORCHEXTRA_SDK = @"com.orchextra.sdk";
int ERROR_ACTION_NOT_FOUND = 5001;

@interface ORCValidatorActionInterator()

@property (strong, nonatomic) ORCActionCommunicator *communicator;

@end


@implementation ORCValidatorActionInterator


#pragma mark - INIT

- (instancetype)init
{
    ORCActionCommunicator *communicator = [[ORCActionCommunicator alloc] init];
    return [self initWithCommunicator:communicator];
}

- (instancetype)initWithCommunicator:(ORCActionCommunicator *)communicator
{
    self = [super init];
    
    if (self)
    {
        _communicator = communicator;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)validateScanType:(NSString *)scanType scannedValue:(NSString *)scannedValue completion:(CompletionActionValidated)completion
{
    NSDictionary *dictionary = [self formattedParametersWithType:scanType value:scannedValue];
    [self printValidatingLogMessageWithValues:dictionary];

    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        [this validateResponse:responseAction requestParams:dictionary completion:completion];
    }];
}

- (void)validateVuforia:(NSString *)imageRecognized completion:(CompletionActionValidated)completion
{
    NSDictionary *dictionary = [self formattedParametersWithType:ORCTypeVuforia value:imageRecognized];
    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        [this validateResponse:responseAction requestParams:dictionary completion:completion];
    }];
}

- (void)validateProximityWithGeofence:(ORCTriggerGeofence *)geofence completion:(CompletionActionValidated)completion
{
    NSDictionary *dictionary = @{ TYPE_KEY : geofence.type,
                                  VALUE_KEY : geofence.identifier,
                                  EVENT_KEY : [self convertEvent:geofence.currentEvent],
                                  PHONE_STATUS_KEY : [self applicationStateStringFormat],
                                  DISTANCE_KEY : geofence.currentDistance};
    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        [this validateResponse:responseAction requestParams:dictionary completion:completion];
    }];
}

- (void)validateProximityWithBeacon:(ORCTriggerBeacon *)beacon completion:(CompletionActionValidated)completionAction
{
    NSDictionary *dictionary = @{ TYPE_KEY : beacon.type,
                                  VALUE_KEY : beacon.identifier,
                                  EVENT_KEY : [self convertEvent:beacon.currentEvent],
                                  PHONE_STATUS_KEY : [self applicationStateStringFormat],
                                  DISTANCE_KEY : [self nameForProximity:beacon.currentProximity]};

    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        
        [this validateResponse:responseAction requestParams:dictionary completion:completionAction];

    }];
}


#pragma mark - PRIVATE

- (NSDictionary *)formattedParametersWithType:(NSString *)type value:(NSString *)value
{
    return @{ TYPE_KEY : type, VALUE_KEY : value };
}

- (void)validateResponse:(ORCURLActionResponse *)response requestParams:(NSDictionary *)requestParams
              completion:(CompletionActionValidated)completion {
    
    if (!response.action)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"** [Orchextra SDK] - Action not found ** %@ - %@",
                                                              requestParams[TYPE_KEY], requestParams[VALUE_KEY]] };
        NSError *error = [NSError errorWithDomain:DOMAIN_ORCHEXTRA_SDK
                                             code:ERROR_ACTION_NOT_FOUND
                                         userInfo:userInfo];
        completion(nil, error);
        [ORCGIGLogManager log:@"---- ACTION NOT FOUND---- \n ------> Trigger: %@, Value: %@\n",
         requestParams[TYPE_KEY], requestParams[VALUE_KEY]];
    }
    else
    {
        [ORCGIGLogManager log:@"---- FOUND ACTION ---- \n ------> Trigger: %@, Value: %@\n ------> Action: %@, url: %@\n",
         requestParams[TYPE_KEY], requestParams[VALUE_KEY], response.action.type, response.action.urlString];
        completion(response.action, nil);
    }
}


#pragma mark - PRINT MESSAGE

-(void)printValidatingLogMessageWithValues:(NSDictionary *)dictionary
{
    __block NSString *message = [NSString stringWithFormat:@"--- VALIDATING %@: ---\n", [dictionary[TYPE_KEY] uppercaseString]];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        message = [message stringByAppendingString:[NSString stringWithFormat:@" ------>   %@: %@\n", key, obj]];
    }];
    
    [ORCGIGLogManager log:message];
}

#pragma mark - FORMATTER

- (NSString *)convertEvent:(NSInteger)typeEvent
{
    switch (typeEvent)
    {
        case 0:
            return @"enter";
        case 1:
            return @"exit";
        default:
            return @"stay";
    }
}

- (NSString *)applicationStateStringFormat
{
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    switch ( appState )
    {
        case UIApplicationStateActive:
            return @"foreground";
        case UIApplicationStateBackground:
            return @"background";
        default:
            return @"inactive";
    }
}

- (NSString *)nameForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            return @"unknown";
            break;
        case CLProximityImmediate:
            return @"immediate";
            break;
        case CLProximityNear:
            return @"near";
            break;
        case CLProximityFar:
            return @"far";
            break;
    }
}

@end
