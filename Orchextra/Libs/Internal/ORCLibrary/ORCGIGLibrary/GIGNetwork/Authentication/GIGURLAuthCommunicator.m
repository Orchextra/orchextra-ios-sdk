//
//  GIGURLAuthCommunicator.m
//  Orchextra
//
//  Created by Judith Medina on 27/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLAuthCommunicator.h"
#import "ORCGIGURLRequest.h"
#import "ORCGIGURLJSONResponse.h"
#import "ORCGIGURLDomain.h"
#import "ORCSettingsPersister.h"
#import "ORCURLProvider.h"
#import "ORCUser.h"

NSInteger MAX_ATTEMPTS_CONNECTION = 5;
NSInteger ERROR_AUTHENTICATION_ACCESSTOKEN = 401;

@interface GIGURLAuthCommunicator()

@property (strong, nonatomic) ORCURLRequest *nextRequest;
@property (strong, nonatomic) NSMutableArray *queueRequests;

@property (copy, nonatomic) NSString *apiKey;
@property (copy, nonatomic) NSString *apiSecret;
@property (assign, nonatomic) NSInteger numConnection;
@property (strong, nonatomic) ORCSettingsPersister *orchextraStorage;
@property (strong, nonatomic) NSString *domain;

@end


@implementation GIGURLAuthCommunicator

#pragma mark - INIT

- (instancetype)init
{
    ORCGIGURLStorage *storage = [[ORCGIGURLStorage alloc] init];
    ORCSettingsPersister *orchextraStorage = [[ORCSettingsPersister alloc] init];
    
    return [self initWithStorage:storage orchextraStorage:orchextraStorage];
}

- (instancetype)initWithStorage:(ORCGIGURLStorage *)storage orchextraStorage:(ORCSettingsPersister *)orchextraStorage
{
    self = [super init];
    if (self)
    {
        _storage = storage;
        _orchextraStorage = orchextraStorage;
        _numConnection = 0;
        
        // ADD REQUESTS
        _queueRequests = [[NSMutableArray alloc] init];
        
        self.domain = [self.orchextraStorage loadURLEnvironment];
    }
    return self;
}

#pragma mark - PUBLIC

- (void)send:(ORCURLRequest *)request completion:(ORCGIGURLRequestCompletion)completion
{
    NSDictionary *bearerHeader = [self bearerHeader];
    self.apiKey = [self.orchextraStorage loadApiKey];
    self.apiSecret = [self.orchextraStorage loadApiSecret];
    
    if (bearerHeader == nil)
    {
        ORCURLRequest *urlRequest = (ORCURLRequest *)request;
        [self.queueRequests addObject:@{@"request" : urlRequest, @"completion" : completion}];
        
        if (self.queueRequests.count == 1)
        {
            [self requestAuthenticationTokenWithRequest:request completion:completion];
        }
    }
    else
    {
        request.headers = bearerHeader;
        
        __weak typeof(self) this = self;
        
        [self sendRequest:request completion:^(ORCGIGURLJSONResponse *response) {
            
            if (response.success)
            {
                completion(response);
            }
            else
            {
                if(response.error.code == ERROR_AUTHENTICATION_ACCESSTOKEN)
                {
                    [this.orchextraStorage storeAcessToken:nil];
                    [this send:request completion:completion];
                    this.numConnection++;
                }
                else
                {
                    completion(response);
                }
            }
            
        }];
    }
}

#pragma mark - PRIVATE

- (NSDictionary *)bearerHeader
{
    NSString *accessToken = [self.orchextraStorage loadAccessToken];
    if (accessToken.length == 0) return nil;
    
    NSString *bearerToken = [NSString stringWithFormat:@"Bearer %@", accessToken];
    return @{@"Authorization" : bearerToken};
}

- (void)sendAuthWithCompletion:(CompletionAuthenticationResponse)completion
{
    __weak typeof(self) this = self;
    [self clientAuthenticationRequest:^(ORCGIGURLJSONResponse *response) {
        
        if (response.success)
        {
            NSString *clientToken = response.jsonData[@"value"];
            [this.orchextraStorage storeClientToken:clientToken];
            
            [this deviceAuthenticationWithClientToken:clientToken completion:^(ORCGIGURLJSONResponse *response) {
                
                if (response.success)
                {
                    NSString *accessToken = response.jsonData[@"value"];
                    [this.orchextraStorage storeAcessToken:accessToken];
                }
                completion(response);
            }];
        }
        else
        {
            completion(response);
        }
    }];
}

- (void)clientAuthenticationRequest:(CompletionAuthenticationResponse)completion
{
    NSDictionary *parametersJSON = @{@"grantType" : @"auth_sdk",
                                     @"credentials" : @{@"apiKey" : self.apiKey,
                                                        @"apiSecret" : self.apiSecret
                                                        }};
    
    NSString *urlRequest = [ORCURLProvider endPointSecurityToken];
    ORCURLRequest *request = [[ORCURLRequest alloc] initWithMethod:@"POST" url:urlRequest];
    request.responseClass = [ORCGIGURLJSONResponse class];
    request.json = parametersJSON;
    request.logLevel = GIGLogLevelBasic;
    request.requestTag = @"clientToken";
    
    [self sendRequest:request completion:^(ORCGIGURLJSONResponse *response) {
        completion(response);
    }];
}

- (void)deviceAuthenticationWithClientToken:(NSString *)clientToken completion:(CompletionAuthenticationResponse)completion
{
    NSString *advertiserId  = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *vendorId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSMutableDictionary *credentialsDictValue = [[NSMutableDictionary alloc] initWithDictionary:@{@"clientToken" : clientToken,
                                                                                                  @"advertiserId" : advertiserId,
                                                                                                  @"vendorId" : vendorId}];
    
    ORCUser *user = [self.orchextraStorage loadCurrentUser];
    
    if (user.crmID)
    {
        [credentialsDictValue addEntriesFromDictionary:@{@"crmId" : user.crmID}];
    }
    
    NSMutableDictionary *credentialsJSON = [[NSMutableDictionary alloc] init];
    [credentialsJSON addEntriesFromDictionary:@{@"credentials" : credentialsDictValue}];
    
    NSMutableDictionary *parametersJSON = [[NSMutableDictionary alloc] init];
    [parametersJSON addEntriesFromDictionary:@{@"grantType" : @"auth_user"}];
    [parametersJSON addEntriesFromDictionary:credentialsJSON];
    
    NSString *urlRequest = [ORCURLProvider endPointSecurityToken];
    
    ORCURLRequest *request = [[ORCURLRequest alloc] initWithMethod:@"POST" url:urlRequest];
    request.responseClass = [ORCGIGURLJSONResponse class];
    request.json = parametersJSON;
    request.logLevel = GIGLogLevelBasic;
    request.requestTag = @"accessToken";
    [ORCLog logVerbose:[self printToJSONFormat:parametersJSON]];
    
    [self sendRequest:request completion:^(ORCGIGURLJSONResponse *response) {
        completion(response);
    }];
    
}

#pragma mark - Helpers

- (NSString *)printToJSONFormat:(NSDictionary *)dictionary
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (void)requestAuthenticationTokenWithRequest:(ORCURLRequest *)request completion:(ORCGIGURLRequestCompletion)completion
{
    NSLog(@"requestAuthenticationTokenWithRequest");
    __weak typeof(self) this = self;
    [self sendAuthWithCompletion:^(ORCGIGURLJSONResponse *response) {
        
        if (response.success)
        {
            [this performQueueRequests:self.queueRequests];
        }
        else
        {
            if(response.error.code == ERROR_AUTHENTICATION_ACCESSTOKEN)
            {
                if (this.numConnection < MAX_ATTEMPTS_CONNECTION)
                {
                    [this send:request completion:completion];
                }
                else
                {
                    ORCGIGURLJSONResponse *errorResponse = [[ORCGIGURLJSONResponse alloc]
                                                            initWithError:[NSError errorWithDomain:@"com.gigigo.error"
                                                                                              code:401 userInfo:nil]];
                    completion(errorResponse);
                }
                [this.orchextraStorage storeAcessToken:nil];
                this.numConnection++;
            }
            else
            {
                completion(response);
            }
            
        }
    }];
    
}

- (void)performQueueRequests:(NSMutableArray *)requests
{
    for (NSDictionary *queueRequest in requests)
    {
        ORCURLRequest *request = queueRequest[@"request"];
        request.headers = [self bearerHeader];
        
        ORCGIGURLRequestCompletion completion = queueRequest[@"completion"];
        
        __weak typeof(self) this = self;
        [self sendRequest:request completion:^(id response) {
            [this.queueRequests removeObject:queueRequest];
            completion(response);
        }];
    }
}


@end
