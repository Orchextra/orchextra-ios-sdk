//
//  ORCActionCommunicator.m
//  Orchextra
//
//  Created by Judith Medina on 29/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCActionCommunicator.h"
#import "ORCURLRequest.h"
#import "ORCFormatterParameters.h"
#import "ORCURLProvider.h"

NSString * const ACTION_ENDPOINT = @"action";

@interface ORCActionCommunicator ()

@property (strong, nonatomic) ORCFormatterParameters *formatter;

@end

#pragma mark - INIT

@implementation ORCActionCommunicator

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _formatter = [[ORCFormatterParameters alloc] init];
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)loadActionWithTriggerValues:(NSDictionary *)values completion:(ORCActionResponse)completion
{    
    ORCURLRequest *request = [self POST:[ORCURLProvider endPointAction]];
    request.logLevel = GIGLogLevelBasic;
    request.responseClass = [ORCURLActionResponse class];
    request.json = [self parametersRequest:values];
    [self send:request completion:completion];
}

- (void)trackActionLaunched:(ORCAction *)action completion:(ORCConfirmActionResponse)completion
{
    ORCURLRequest *request = [self POST:[ORCURLProvider endPointConfirmAction:action.trackId]];
    request.logLevel = GIGLogLevelBasic;
    request.responseClass = [ORCURLActionConfirmationResponse class];
    [self send:request completion:completion];
}

- (void)trackInteractionWithAction:(ORCAction *)action values:(NSDictionary *)values completion:(ORCConfirmActionResponse)completion
{
    ORCURLRequest *request = [self POST:[ORCURLProvider endPointConfirmAction:action.trackId]];
    request.logLevel = GIGLogLevelBasic;
    request.json = values;
    request.responseClass = [ORCURLActionConfirmationResponse class];
    [self send:request completion:completion];
    
}

#pragma mark - PRIVATE

- (NSDictionary *)parametersRequest:(NSDictionary *)values
{
    NSMutableDictionary *paramRequest = [NSMutableDictionary
                                         dictionaryWithDictionary:[self.formatter formattedCurrentUserLocation]];
    [paramRequest addEntriesFromDictionary:values];
    
    return paramRequest;
}


@end
