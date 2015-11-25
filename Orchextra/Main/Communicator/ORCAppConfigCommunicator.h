//
//  OrchestraCommunicator.h
//  Orchestra
//
//  Created by Judith Medina on 28/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ORCURLCommunicator.h"
#import "ORCAppConfigResponse.h"

typedef void(^CompletionOrchestraConfigResponse)(ORCAppConfigResponse *response);

@interface ORCAppConfigCommunicator : ORCURLCommunicator

- (void)loadConfigurationWithCompletion:(CompletionOrchestraConfigResponse)completion;

- (void)loadConfiguration:(NSDictionary *)configuration completion:(CompletionOrchestraConfigResponse)completion;

- (void)useFixtures:(BOOL)useFixtures;

@end
