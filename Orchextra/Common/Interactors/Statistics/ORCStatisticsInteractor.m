//
//  ORCStatisticsInteractor.m
//  Orchextra
//
//  Created by Judith Medina on 12/1/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCStatisticsInteractor.h"
#import "ORCActionCommunicator.h"

@interface ORCStatisticsInteractor ()

@property (strong, nonatomic) ORCActionCommunicator* communicator;

@end


@implementation ORCStatisticsInteractor


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

- (void)trackActionHasBeenLaunched:(ORCAction *)action
{
    if (action.trackId && action.trackId.length > 0)
    {
        [[ORCLog sharedInstance] logDebug:[NSString stringWithFormat: @"CONFIRM ACTION id:%@ , type: %@",  action.trackId, action.type]];
        [self.communicator trackActionLaunched:action completion:^(ORCURLActionConfirmationResponse *responseActionConfirmation) {
            
        }];
    }
}

- (void)trackValue:(NSString *)value type:(NSString *)type withAction:(ORCAction *)action
{
    if (action.trackId && action.trackId.length > 0)
    {
        [[ORCLog sharedInstance] logDebug:[NSString stringWithFormat: @"CONFIRM ACTION id:%@ , type: %@",  action.trackId, action.type]];

        NSDictionary *values = @{@"type": type, @"value": value};
        [self.communicator trackInteractionWithAction:action values:values completion:^(ORCURLActionConfirmationResponse *responseActionConfirmation) {
            
        }];
    }

}

@end
