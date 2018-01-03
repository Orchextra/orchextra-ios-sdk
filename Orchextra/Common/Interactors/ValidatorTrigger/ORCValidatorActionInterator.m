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
#import "ORCGIGJSON.h"

NSString * const TYPE_KEY               = @"type";
NSString * const VALUE_KEY              = @"value";
NSString * const EVENT_KEY              = @"event";
NSString * const PHONE_STATUS_KEY       = @"phoneStatus";
NSString * const DISTANCE_KEY           = @"distance";

NSString * const TEMPERATURE_KEY        = @"temperature";
NSString * const NAMESPACE_KEY          = @"namespace";
NSString * const INSTANCE_KEY           = @"instance";
NSString * const BATTERY_KEY            = @"battery";
NSString * const UPTIME_KEY             = @"uptime";
NSString * const URL_KEY                = @"url";



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
    
    if (
        !regionToValidate.type || [regionToValidate.type isKindOfClass:[NSNull class]] || regionToValidate.type == 0 ||
        !regionToValidate.code || [regionToValidate.code isKindOfClass:[NSNull class]] || regionToValidate.code == 0
        )
    {
        [ORCLog logError:@"Response or Request Params are nil"];
        completionAction(nil, [[NSError alloc] initWithDomain:@"domain" code:-1 userInfo: nil]);
    } else {
        NSDictionary *dictionary = @{ TYPE_KEY : regionToValidate.type,
                                      VALUE_KEY : regionToValidate.code,
                                      EVENT_KEY : [ORCProximityFormatter proximityEventToString:regionToValidate.currentEvent],
                                      PHONE_STATUS_KEY : [ORCProximityFormatter applicationStateString]};
        
        [self printValidatingLogMessageWithValues:dictionary];
        
        __weak typeof(self) this = self;
        [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
            if ([this respondsToSelector:@selector(validateResponse:requestParams:completion:)]) {
                 [this validateResponse:responseAction requestParams:dictionary completion:completionAction];
            }
        }];
    }
}

- (void)validateProximityWithEddystoneRegion:(ORCEddystoneRegion *)region completion:(CompletionActionValidated)completionAction
{
    NSDictionary *dictionary = @{ TYPE_KEY  : ORCTypeEddystoneRegion,
                                  VALUE_KEY : region.code,
                                  NAMESPACE_KEY: region.uid.namespace,
                                  EVENT_KEY : [ORCProximityFormatter eddystoneRegionEventToString:region.regionEvent],
                                  PHONE_STATUS_KEY : [ORCProximityFormatter applicationStateString]};
    
    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        
        [this validateResponse:responseAction requestParams:dictionary completion:completionAction];
    }];
}

- (void)validateProximityWithBeacon:(ORCBeacon *)beacon completion:(CompletionActionValidated)completionAction
{
    NSString *beaconUUIDUpperCaseString = [beacon.uuid.UUIDString uppercaseString];
    NSString *plainCodeBeacon           = [NSString stringWithFormat:@"%@_%@_%@",
                                           beaconUUIDUpperCaseString,
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

- (void)validateProximityWithEddystoneBeacon:(ORCEddystoneBeacon *)beacon completion:(CompletionActionValidated)completionAction
{
    NSNumber *temperature = [NSNumber numberWithDouble:beacon.telemetry.temperature];
    NSNumber *batteryPercentage = [NSNumber numberWithDouble:beacon.telemetry.batteryPercentage];
    NSDictionary *partialDictionary =   @{ TYPE_KEY          : ORCTypeEddystoneBeacon,
                                           NAMESPACE_KEY     : beacon.uid.namespace,
                                           INSTANCE_KEY      : beacon.uid.instance,
                                           VALUE_KEY         : beacon.uid.uidCompossed,
                                           URL_KEY           : beacon.url.description,
                                           PHONE_STATUS_KEY  : [ORCProximityFormatter applicationStateString],
                                           DISTANCE_KEY      : [ORCProximityFormatter eddystoneProximityDistanceToString:beacon.proximity] };
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]
                                       initWithDictionary:partialDictionary];
    
    if (temperature != nil && !([temperature isKindOfClass:[NSNull class]]))
    {
        [dictionary addEntriesFromDictionary: @{ TEMPERATURE_KEY : temperature }];
    }
    
    if (batteryPercentage != nil && !([batteryPercentage isKindOfClass:[NSNull class]]))
    {
        [dictionary addEntriesFromDictionary: @{ BATTERY_KEY : batteryPercentage }];
    }
    
    [self printValidatingLogMessageWithValues:dictionary];
    
    __weak typeof(self) this = self;
    [self.communicator loadActionWithTriggerValues:dictionary completion:^(ORCURLActionResponse *responseAction) {
        
        [this validateResponse:responseAction requestParams:dictionary completion:completionAction];
        
    }];
}


#pragma mark - PRIVATE

- (NSDictionary *)formattedParametersWithType:(NSString *)type value:(NSString *)value {
    return @{ TYPE_KEY : type, VALUE_KEY : value };
}

- (void)validateResponse:(ORCURLActionResponse *)response requestParams:(NSDictionary *)requestParams
              completion:(CompletionActionValidated)completion {
    
    if (!response || !requestParams)
    {
        [ORCLog logError:@"Response or Request Params are nil"];
        completion(nil, nil);
        return;
    }
    
    NSString *type = [requestParams stringForKey:TYPE_KEY];
    NSString *value = [requestParams stringForKey:VALUE_KEY];
    
    if (!response.action)
    {
        if (requestParams && type && value)
        {
            [ORCLog logDebug:@"---- ACTION NOT FOUND---- \n ------> Trigger: %@, Value: %@\n",
             type, value];
        }
        if (completion && response.error)
        {
            completion(nil, response.error);
        }
        else
        {
            completion(nil, [[NSError alloc] initWithDomain:@"domain" code:0 userInfo: nil]);
        }
    }
    else
    {
        if (type && value)
        {
            if (response.action != nil && response.action.type != nil && response.action.urlString != nil && response.action.scheduleTime != nil) {
                [ORCLog logDebug:@"---- FOUND ACTION ---- \n ------> Trigger: %@, Value: %@\n ------> Action: %@, url: %@, Schedule: %d\n",
                 type, value, response.action.type, response.action.urlString, response.action.scheduleTime];
            }
            else
            {
                [ORCLog logDebug:@"---- FOUND ACTION ---- \n ----- but ERROR when search response.action or response.action.type or response.action.urlString or response.action.scheduleTime"];
            }
        }
        if (completion) {
            if (response.action) {
                completion(response.action, nil);
            }
            else {
                [ORCLog logDebug:@"---- ERROR, response.action is NIL"];
            }
        }
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
