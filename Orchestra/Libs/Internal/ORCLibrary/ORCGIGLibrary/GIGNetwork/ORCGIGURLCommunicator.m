//
//  GIGCommunicator.m
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLCommunicator.h"

#import "ORCGIGURLManager.h"
#import "ORCGIGURLRequestFactory.h"


@interface ORCGIGURLCommunicator ()

@property (strong, nonatomic) ORCGIGURLRequestFactory *requestFactory;
@property (strong, nonatomic) ORCGIGURLManager *manager;

@property (strong, nonatomic) ORCGIGURLRequest *lastRequest;
@property (strong, nonatomic) NSDictionary *requests;
@property (copy, nonatomic) GIGURLMultiRequestCompletion requestsCompletion;

@end


@implementation ORCGIGURLCommunicator

- (instancetype)init
{
    ORCGIGURLRequestFactory *requestFactory = [[ORCGIGURLRequestFactory alloc] init];
    ORCGIGURLManager *manager = [ORCGIGURLManager sharedManager];
    
    return [self initWithRequestFactory:requestFactory manager:manager];
}

- (instancetype)initWithManager:(ORCGIGURLManager *)manager
{
    ORCGIGURLRequestFactory *requestFactory = [[ORCGIGURLRequestFactory alloc] initWithManager:manager];
    
    return [self initWithRequestFactory:requestFactory manager:manager];
}

- (instancetype)initWithRequestFactory:(ORCGIGURLRequestFactory *)requestFactory
{
    ORCGIGURLManager *manager = [ORCGIGURLManager sharedManager];
    
    return [self initWithRequestFactory:requestFactory manager:manager];
}

- (instancetype)initWithRequestFactory:(ORCGIGURLRequestFactory *)requestFactory manager:(ORCGIGURLManager *)manager
{
    self = [super init];
    if (self)
    {
        _requestFactory = requestFactory;
        _manager = manager;
        
        _logLevel = GIGLogLevelError;
    }
    return self;
}

#pragma mark - ACCESSORS

- (NSString *)host
{
    return self.manager.domain.url;
}

#pragma mark - PUBLIC

- (ORCGIGURLRequest *)GET:(NSString *)url
{
    return [self requestWithMethod:@"GET" url:url];
}

- (ORCGIGURLRequest *)POST:(NSString *)url
{
    return [self requestWithMethod:@"POST" url:url];
}

- (ORCGIGURLRequest *)DELETE:(NSString *)url
{
    return [self requestWithMethod:@"DELETE" url:url];
}

- (ORCGIGURLRequest *)PUT:(NSString *)url
{
    return [self requestWithMethod:@"PUT" url:url];
}

- (ORCGIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url
{
    self.lastRequest = [self.requestFactory requestWithMethod:method url:url];
    self.lastRequest.logLevel = self.logLevel;
    
    return self.lastRequest;
}

- (void)sendRequest:(ORCGIGURLRequest *)request completion:(ORCGIGURLRequestCompletion)completion
{
    self.lastRequest = request;
    self.lastRequest.completion = completion;
    
    [request send];
}

- (void)sendRequests:(NSDictionary *)requests completion:(GIGURLMultiRequestCompletion)completion
{
    self.requests = requests;
    self.requestsCompletion = completion;
    
    NSMutableDictionary *responses = [[NSMutableDictionary alloc] initWithCapacity:requests.count];
    dispatch_group_t groupRequests = dispatch_group_create();
    
    [requests enumerateKeysAndObjectsUsingBlock:^(NSString *requestKey, ORCGIGURLRequest *request, __unused BOOL *stop) {
        dispatch_group_enter(groupRequests);
        
        request.completion = ^(ORCGIGURLResponse *response) {
            responses[requestKey] = response;
            dispatch_group_leave(groupRequests);
        };
        
        [request send];
    }];
    
    __weak typeof(self) this = self;
    dispatch_group_notify(groupRequests, dispatch_get_main_queue(), ^{
        this.requests = nil;
        
        if (this.requestsCompletion)
        {
            this.requestsCompletion(responses);
            this.requestsCompletion = nil;
        }
    });
}

- (void)cancelLastRequest
{
    [self.lastRequest cancel];
}

@end
