//
//  ORCValidatorActionIterator.h
//  Orchestra
//
//  Created by Judith Medina on 6/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ORCRegion;
@class ORCBeacon;
@class ORCGeofence;
@class ORCAction;
@class ORCActionCommunicator;


typedef void(^CompletionActionValidated)(ORCAction *action, NSError *error);

@interface ORCValidatorActionInterator : NSObject

- (instancetype)initWithCommunicator:(ORCActionCommunicator *)communicator;

- (void)validateScanType:(NSString *)scanType scannedValue:(NSString *)scannedValue completion:(CompletionActionValidated)completion;

- (void)validateVuforia:(NSString *)imageRecognized completion:(CompletionActionValidated)completion;

- (void)validateProximityWithBeacon:(ORCBeacon *)beacon completion:(CompletionActionValidated)completion;

- (void)validateProximityWithRegion:(ORCRegion *)region completion:(CompletionActionValidated)completionAction;

- (void)validateProximityWithGeofence:(ORCGeofence *)geofence completion:(CompletionActionValidated)completionAction;

@end
