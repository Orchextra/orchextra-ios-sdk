//
//  ORCAppConfigCommunicatorMock.h
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCAppConfigCommunicator.h"

@interface ORCAppConfigCommunicatorMock : ORCAppConfigCommunicator

@property (strong, nonatomic) NSError *inError;
@property (strong, nonatomic) ORCAppConfigResponse *inAppConfigResponse;

@property (assign, nonatomic) BOOL outLoadConfiguration;
@property (assign, nonatomic) BOOL outLoadCustomConfiguration;
@property (strong, nonatomic) NSDictionary *outConfigurationValues;


@end
