//
//  ORCActionCommunicator.m
//  Orchestra
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

- (void)loadActionWithTriggerValues:(NSDictionary *)values completion:(ORCActionResponse)completion
{    
    ORCURLRequest *request = [self GET:[ORCURLProvider endPointAction]];
    request.logLevel = GIGLogLevelBasic;
    request.responseClass = [ORCURLActionResponse class];
    request.parameters = [self parametersRequest:values];
    [self send:request completion:completion];
}


- (NSDictionary *)parametersRequest:(NSDictionary *)values
{
    NSMutableDictionary *paramRequest = [NSMutableDictionary
                                         dictionaryWithDictionary:[self.formatter formattedCurrentUserLocation]];
    [paramRequest addEntriesFromDictionary:values];
    
    return paramRequest;
}


@end
