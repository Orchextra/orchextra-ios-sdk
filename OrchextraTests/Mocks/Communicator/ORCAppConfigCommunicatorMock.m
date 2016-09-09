//
//  ORCAppConfigCommunicatorMock.m
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCAppConfigCommunicatorMock.h"

@implementation ORCAppConfigCommunicatorMock

- (void)loadConfigurationWithCompletion:(CompletionOrchestraConfigResponse)completion
{
    self.outLoadConfiguration = YES;
    completion(self.inAppConfigResponse);
}

- (void)loadConfiguration:(NSDictionary *)configuration sections:(NSArray *)sections completion:(CompletionOrchestraConfigResponse)completion
{
    self.outLoadCustomConfiguration = YES;
    self.outConfigurationValues = configuration;
    
    completion(self.inAppConfigResponse);
}

@end
