//
//  ORCActionCommunicator.h
//  Orchextra
//
//  Created by Judith Medina on 29/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORCURLActionResponse.h"
#import "ORCURLActionConfirmationResponse.h"

#import <GIGLibrary/GIGURLCommunicator.h>

@class ORCAction;

typedef void(^ORCActionResponse)(ORCURLActionResponse *responseAction);
typedef void(^ORCConfirmActionResponse)(ORCURLActionConfirmationResponse *responseActionConfirmation);

@interface ORCActionCommunicator : GIGURLCommunicator

- (void)loadActionWithTriggerValues:(NSDictionary *)values completion:(ORCActionResponse)completion;

- (void)trackActionLaunched:(ORCAction *)action completion:(ORCConfirmActionResponse)completion;
- (void)trackInteractionWithAction:(ORCAction *)action values:(NSDictionary *)values completion:(ORCConfirmActionResponse)completion;

@end
