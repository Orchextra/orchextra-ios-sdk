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

#import "ORCGIGURLCommunicator.h"
#import "ORCGIGURLJSONResponse.h"
#import "ORCGIGURLStorage.h"
#import "ORCConstants.h"
#import "ORCURLRequest.h"

@class ORCSettingsPersister;

typedef void(^CompletionAuthenticationResponse)(ORCGIGURLJSONResponse *response);

@interface GIGURLAuthCommunicator : ORCGIGURLCommunicator

@property (strong, nonatomic) ORCGIGURLStorage *storage;

- (instancetype)initWithStorage:(ORCGIGURLStorage *)storage orchextraStorage:(ORCSettingsPersister *)orchextraStorage;
- (void)send:(ORCURLRequest *)request completion:(ORCGIGURLRequestCompletion)completion;

- (void)clientAuthenticationRequest:(CompletionAuthenticationResponse)completion;
- (void)deviceAuthenticationWithClientToken:(NSString *)clientToken completion:(CompletionAuthenticationResponse)completion;

@end
