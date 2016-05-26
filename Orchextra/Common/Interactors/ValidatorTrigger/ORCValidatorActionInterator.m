//
//  ORCValidatorActionIterator.m
//  Orchestra
//
//  Created by Judith Medina on 6/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCValidatorActionInterator.h"
#import "ORCBeacon.h"
#import "ORCGeofence.h"
#import "ORCRegion.h"
#import "ORCAction.h"
#import "ORCActionCommunicator.h"

#import "NSString+MD5.h"
#import "ORCConstants.h"
#import "ORCProximityFormatter.h"
#import "ORCErrorManager.h"

NSString * const TYPE_KEY = @"type";
NSString * const VALUE_KEY = @"value";
NSString * const EVENT_KEY = @"event";
NSString * const PHONE_STATUS_KEY = @"phoneStatus";
NSString * const DISTANCE_KEY = @"distance";

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

- (void)validateProximityWithGeofence:(ORCGeofence *)geofence completion:(CompletionActionValidated)completion
{
    
    ORCGeofence *geofenceToValidate = [[ORCGeofence alloc] initWithGeofence:geofence];
    
    NSDictionary *dictionary = @{ TYPE_KEY : ORCTypeGeofence,
                                  VALUE_KEY : geofenceToValidate.code,
                                  EVENT_KEY : [ORCProximityFormatter proximityEventToString:geofenceToValidate.currentEvent],
                                  PHONE_STATUS_KEY : [ORCProximityFormatter applicationStateString],
                                  DISTANCE_KEY : geofenceToValidate.currentDistance};
    
    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        [this validateResponse:responseAction requestParams:dictionary completion:completion];
    }];
}

- (void)validateProximityWithRegion:(ORCRegion *)region completion:(CompletionActionValidated)completionAction
{

    ORCRegion *regionToValidate = [[ORCRegion alloc] initWithRegion:region];
    
    NSDictionary *dictionary = @{ TYPE_KEY : regionToValidate.type,
                                  VALUE_KEY : regionToValidate.code,
                                  EVENT_KEY : [ORCProximityFormatter proximityEventToString:regionToValidate.currentEvent],
                                  PHONE_STATUS_KEY : [ORCProximityFormatter applicationStateString]};
    
    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        
        [this validateResponse:responseAction requestParams:dictionary completion:completionAction];
    }];
}

- (void)validateProximityWithBeacon:(ORCBeacon *)beacon completion:(CompletionActionValidated)completionAction
{
    NSString *plainCodeBeacon = [NSString stringWithFormat:@"%@_%@_%@",
                                 beacon.uuid.UUIDString,
                                 beacon.major,
                                 beacon.minor];
    
    NSString *md5codeBeacon = [plainCodeBeacon MD5];
    NSDictionary *dictionary = @{ TYPE_KEY : beacon.type,
                                  VALUE_KEY : md5codeBeacon,
                                  PHONE_STATUS_KEY : [ORCProximityFormatter applicationStateString],
                                  DISTANCE_KEY : [ORCProximityFormatter proximityDistanceToString:beacon.currentProximity]};

    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        
        [this validateResponse:responseAction requestParams:dictionary completion:completionAction];

    }];
}

#pragma mark - PRIVATE

- (NSDictionary *)formattedParametersWithType:(NSString *)type value:(NSString *)value{
    return @{ TYPE_KEY : type, VALUE_KEY : value };
}

- (void)validateResponse:(ORCURLActionResponse *)response requestParams:(NSDictionary *)requestParams
              completion:(CompletionActionValidated)completion {
    
    if (!response.action)
    {
        [ORCLog logDebug:@"---- ACTION NOT FOUND---- \n ---j---> Trigger: %@, Value: %@\n",
         requestParams[TYPE_KEY], requestParams[VALUE_KEY]];
        
        completion(nil, response.error);

    }
    else
    {
        [ORCLog logDebug:@"---- FOUND ACTION ---- \n ------> Trigger: %@, Value: %@\n ------> Action: %@, url: %@, Schedule: %d\n",
         requestParams[TYPE_KEY], requestParams[VALUE_KEY], response.action.type, response.action.urlString, response.action.scheduleTime];
        
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
    
    [ORCLog logDebug:message];
}

- (NSString *)encodingString:(NSString *)clearString
{
    NSString *escapedString =[clearString stringByAddingPercentEncodingWithAllowedCharacters:
                              [NSCharacterSet characterSetWithCharactersInString:@";,/?:@&=+$-_.!~*'()#"]];
    return escapedString;
}

@end
