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

@property (copy, nonatomic)   NSString *apiKey;
@property (copy, nonatomic)   NSString *apiSecret;
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
    self.apiKey = [self.orchextraStorage loadApiKey];
    self.apiSecret = [self.orchextraStorage loadApiSecret];
    
    if (self.apiKey != nil &&
        self.apiSecret != nil)
    {
        [self retrieveAccessTokenWithRequest:request
                                  completion:completion];
    }
    else
    {
        [ORCLog logError:@"Orchextra has not api key either api secret - start orchextra before continuing."];
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
    if (self.apiKey != nil
        && self.apiSecret != nil)
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
    else
    {
        [ORCLog logError:@"Orchextra has not api key either api secret - start orchextra before continuing."];
    }
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

- (void)retrieveAccessTokenWithRequest:(ORCURLRequest *)request
                            completion:(ORCGIGURLRequestCompletion)completion
{
    NSDictionary *bearerHeader = [self bearerHeader];
    
    if (bearerHeader == nil)
    {
        ORCURLRequest *urlRequest = (ORCURLRequest *)request;
        [self.queueRequests addObject:@{@"request" : urlRequest, @"completion" : completion}];
        
        if (self.queueRequests.count == 1)
        {
            [self retrieveAuthenticationTokenWithRequest:request
                                              completion:completion];
        }
    }
    else
    {
        [self retrieveClientTokenWithRequest:request
                                  completion:completion
                                bearerHeader:bearerHeader];
    }
}

- (void)retrieveClientTokenWithRequest:(ORCURLRequest *)request
                            completion:(ORCGIGURLRequestCompletion)completion
                          bearerHeader:(NSDictionary *)bearerHeader
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
            [this manageAuthenticationErrorForResponse:response
                                               request:request
                                            completion:completion];
        }
    }];
    
}

- (void)manageAuthenticationErrorForResponse:(ORCGIGURLJSONResponse *)response
                                     request:(ORCURLRequest *)request
                                  completion:(ORCGIGURLRequestCompletion)completion
{
    if (response.error.code == ERROR_AUTHENTICATION_ACCESSTOKEN)
    {
        [self.orchextraStorage storeAcessToken:nil];
        
        if ([request.requestTag isEqualToString:@"accessToken"])
        {
            [self.orchextraStorage storeClientToken:nil];
        }
        
        [self send:request completion:completion];
        self.numConnection++;
    }
    else
    {
        completion(response);
        //[self cancelQueueRequest:request completion:completion response:response];
    }
}

- (void)retrieveAuthenticationTokenWithRequest:(ORCURLRequest *)request
                                    completion:(ORCGIGURLRequestCompletion)completion
{
    NSLog(@"requestAuthenticationTokenWithRequest");
    
    NSString *clientToken = [self.orchextraStorage loadClientToken];
    
    if ([clientToken length] > 0)
    {
        [self retrieveAccessTokenWithClientToken:clientToken
                                         request:request
                                      completion:completion];
    }
    else
    {
        [self retrieveClientTokenForRequest:request
                                 completion:completion];
    }
}

- (void)retrieveAccessTokenWithClientToken:(NSString *)clientToken
                                   request:(ORCURLRequest *)request
                                completion:(ORCGIGURLRequestCompletion)completion
{
    __weak typeof(self) this = self;
    [self deviceAuthenticationWithClientToken:clientToken completion:^(ORCGIGURLJSONResponse *response) {
        
        if (response.success)
        {
            NSString *accessToken = response.jsonData[@"value"];
            [this.orchextraStorage storeAcessToken:accessToken];
            [this performQueueRequests:this.queueRequests];
        }
        else
        {
            [this.orchextraStorage storeClientToken:nil];
            [this performAuthenticationErrorActionsForRequest:request
                                                   completion:completion
                                                     response:response];
        }
    }];
    
}

- (void)retrieveClientTokenForRequest:(ORCURLRequest *)request
                           completion:(ORCGIGURLRequestCompletion)completion
{
    __weak typeof(self) this = self;
    [self sendAuthWithCompletion:^(ORCGIGURLJSONResponse *response) {
        
        if (response.success)
        {
            [this performQueueRequests:self.queueRequests];
        }
        else
        {
            if ([request.requestTag isEqualToString:@"accessToken"]) {
                
                [this.orchextraStorage storeClientToken:nil];
            }
            
            [this performAuthenticationErrorActionsForRequest:request
                                                   completion:completion
                                                     response:response];
        }
    }];
}

- (void)performAuthenticationErrorActionsForRequest:(ORCURLRequest *)request
                                         completion:(ORCGIGURLRequestCompletion)completion
                                           response:(ORCGIGURLJSONResponse *)response
{
    if (response.error.code == ERROR_AUTHENTICATION_ACCESSTOKEN)
    {
        [self.orchextraStorage storeAcessToken:nil];
        
        if (self.numConnection < MAX_ATTEMPTS_CONNECTION)
        {
            [self send:request completion:completion];
            self.numConnection++;
        }
        else
        {
            ORCGIGURLJSONResponse *errorResponse = [[ORCGIGURLJSONResponse alloc]
                                                    initWithError:[NSError errorWithDomain:@"com.gigigo.error"
                                                                                      code:401 userInfo:nil]];
            [self cancelQueueRequest:request completion:completion response:errorResponse];
        }
    }
    else
    {
        [self cancelQueueRequest:request completion:completion response:response];
    }
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

- (void)cancelQueueRequest:(ORCURLRequest *)request
                completion:(ORCGIGURLRequestCompletion)completion
                  response:(ORCGIGURLJSONResponse *)response
{
    for (NSDictionary *item in self.queueRequests)
    {
        ORCURLRequest *queueRequest = item[@"request"];
        if (queueRequest != nil && queueRequest == request) {
            [self.queueRequests removeObject:item];
            break;
        }
    }
    completion(response);
}

@end
