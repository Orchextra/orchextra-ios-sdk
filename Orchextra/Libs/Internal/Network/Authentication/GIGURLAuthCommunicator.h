//
//  GIGURLAuthCommunicator.h
//  Orchextra
//
//  Created by Judith Medina on 27/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>

#import <GIGLibrary/GIGLibrary.h>
#import <GIGLibrary/GIGURLCommunicator.h>
#import "ORCConstants.h"

@class ORCSettingsPersister;
@class ORCURLRequest;

typedef void(^CompletionAuthenticationResponse)(GIGURLJSONResponse *response);

@interface GIGURLAuthCommunicator : GIGURLCommunicator

- (instancetype)initWithOrchextraStorage:(ORCSettingsPersister *)orchextraStorage;
- (void)send:(ORCURLRequest *)request completion:(GIGURLRequestCompletion)completion;

- (void)clientAuthenticationRequest:(CompletionAuthenticationResponse)completion;
- (void)deviceAuthenticationWithClientToken:(NSString *)clientToken completion:(CompletionAuthenticationResponse)completion;

@end
