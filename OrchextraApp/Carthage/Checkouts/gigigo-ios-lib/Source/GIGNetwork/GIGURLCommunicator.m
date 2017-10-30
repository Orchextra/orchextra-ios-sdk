//
//  GIGCommunicator.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLCommunicator.h"

#import "GIGURLManager.h"
#import "GIGURLRequestFactory.h"


@interface GIGURLCommunicator ()

@property (strong, nonatomic) GIGURLRequestFactory *requestFactory;
@property (strong, nonatomic) GIGURLManager *manager;

@property (strong, nonatomic) GIGURLRequest *lastRequest;
@property (strong, nonatomic) NSDictionary *requests;
@property (copy, nonatomic) GIGURLMultiRequestCompletion requestsCompletion;

@end


@implementation GIGURLCommunicator

#pragma mark - INITIALIZATION

- (instancetype)init
{
    GIGURLManager *manager = [GIGURLManager sharedManager];
    
    return [self initWithManager:manager];
}

- (instancetype)initWithManager:(GIGURLManager *)manager
{
    GIGURLRequestFactory *requestFactory = [[GIGURLRequestFactory alloc] init];
    
    return [self initWithManager:manager requestFactory:requestFactory];
}

- (instancetype)initWithManager:(GIGURLManager *)manager requestFactory:(GIGURLRequestFactory *)requestFactory
{
    self = [super init];
    if (self)
    {
        _manager = manager;
        _requestFactory = requestFactory;
        
        _requestFactory.requestLogLevel = GIGLogLevelError;
    }
    return self;
}

#pragma mark - ACCESSORS

- (NSString *)host
{
    return self.manager.domain.url;
}

- (GIGLogLevel)logLevel
{
    return self.requestFactory.requestLogLevel;
}

- (void)setLogLevel:(GIGLogLevel)logLevel
{
    self.requestFactory.requestLogLevel = logLevel;
}

#pragma mark - PUBLIC

#pragma mark - Build Requests

- (GIGURLRequest *)GET:(NSString *)urlFormat, ... NS_FORMAT_FUNCTION(1, 2)
{
    va_list args;
    va_start(args, urlFormat);
    
    return [self requestWithMethod:@"GET" urlFormat:urlFormat args:args];
}

- (GIGURLRequest *)POST:(NSString *)urlFormat, ... NS_FORMAT_FUNCTION(1, 2)
{
    va_list args;
    va_start(args, urlFormat);
    
    return [self requestWithMethod:@"POST" urlFormat:urlFormat args:args];
}

- (GIGURLRequest *)DELETE:(NSString *)urlFormat, ... NS_FORMAT_FUNCTION(1, 2)
{
    va_list args;
    va_start(args, urlFormat);
    
    return [self requestWithMethod:@"DELETE" urlFormat:urlFormat args:args];
}

- (GIGURLRequest *)PUT:(NSString *)urlFormat, ... NS_FORMAT_FUNCTION(1, 2)
{
    va_list args;
    va_start(args, urlFormat);
    
    return [self requestWithMethod:@"PUT" urlFormat:urlFormat args:args];
}

- (GIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)urlFormat, ... NS_FORMAT_FUNCTION(2, 3)
{
    va_list args;
    va_start(args, urlFormat);
    
    return [self requestWithMethod:method urlFormat:urlFormat args:args];
}

#pragma mark - Manage Requests

- (void)sendRequest:(GIGURLRequest *)request completion:(GIGURLRequestCompletion)completion
{
    self.lastRequest = request;
    self.lastRequest.completion = completion;
    
    [self.lastRequest send];
}

- (void)sendRequests:(NSDictionary *)requests completion:(GIGURLMultiRequestCompletion)completion
{
    self.requests = requests;
    self.requestsCompletion = completion;
    
    NSMutableDictionary *responses = [[NSMutableDictionary alloc] initWithCapacity:requests.count];
    dispatch_group_t groupRequests = dispatch_group_create();
    
    for (NSString *requestKey in requests)
    {
        GIGURLRequest *request = requests[requestKey];
        [self sendRequest:request key:requestKey group:groupRequests responses:responses];
    }
    
    __weak typeof(self) this = self;
    dispatch_group_notify(groupRequests, dispatch_get_main_queue(), ^{
        [this completeRequestsWithResponses:[responses copy]];
    });
    
}

- (void)cancelLastRequest
{
    [self.lastRequest cancel];
    self.lastRequest = nil;
}

#pragma mark - PRIVATE

- (GIGURLRequest *)requestWithMethod:(NSString *)method urlFormat:(NSString *)urlFormat args:(va_list)args
{
    NSString *url = [[NSString alloc] initWithFormat:urlFormat arguments:args];
    va_end(args);
    
    self.lastRequest = [self.requestFactory requestWithMethod:method url:url];
    
    return self.lastRequest;
}

- (void)sendRequest:(GIGURLRequest *)request key:(NSString *)requestKey group:(dispatch_group_t)groupRequests responses:(NSMutableDictionary *)responses
{
    dispatch_group_enter(groupRequests);
    
    request.completion = ^(GIGURLResponse *response) {
        responses[requestKey] = response;
        dispatch_group_leave(groupRequests);
    };
    
    [request send];
}

- (void)completeRequestsWithResponses:(NSDictionary *)responses
{
    self.requests = nil;
    
    if (self.requestsCompletion != nil)
    {
        self.requestsCompletion(responses);
        self.requestsCompletion = nil;
    }
}

@end
