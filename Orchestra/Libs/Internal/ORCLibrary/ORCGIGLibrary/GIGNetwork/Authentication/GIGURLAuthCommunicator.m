//
//  GIGURLAuthCommunicator.m
//  Orchestra
//
//  Created by Judith Medina on 27/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLAuthCommunicator.h"
#import "ORCGIGURLRequest.h"
#import "ORCGIGURLJSONResponse.h"
#import "ORCGIGURLDomain.h"
#import "ORCStorage.h"
#import "ORCURLProvider.h"

NSInteger MAX_ATTEMPTS_CONNECTION = 5;

@interface GIGURLAuthCommunicator()

@property (strong, nonatomic) ORCURLRequest *nextRequest;

@property (copy, nonatomic) NSString *apiKey;
@property (copy, nonatomic) NSString *apiSecret;
@property (assign, nonatomic) NSInteger numConnection;
@property (strong, nonatomic) ORCStorage *orchextraStorage;
@property (strong, nonatomic) NSString *domain;

@end


@implementation GIGURLAuthCommunicator

#pragma mark - INIT

- (instancetype)init
{
    ORCGIGURLStorage *storage = [[ORCGIGURLStorage alloc] init];
    ORCStorage *orchextraStorage = [[ORCStorage alloc] init];

    return [self initWithStorage:storage orchextraStorage:orchextraStorage];
}

- (instancetype)initWithStorage:(ORCGIGURLStorage *)storage orchextraStorage:(ORCStorage *)orchextraStorage
{
    self = [super init];
    if (self)
    {
        _storage = storage;
        _orchextraStorage = orchextraStorage;
        _numConnection = 0;
        
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
        self.nextRequest = (ORCURLRequest *)request;

        __weak typeof(self) this = self;
        [this sendAuthWithCompletion:^(ORCGIGURLJSONResponse *response) {
           
            if (response.success)
            {
                this.nextRequest.headers = [this bearerHeader];
                
                [self sendRequest:this.nextRequest completion:^(id response) {
                    this.nextRequest = nil;
                    completion(response);
                }];
                
            }
            else
            {
                if(response.error.code == 401)
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
                if(response.error.code == 401)
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
    [this clientAuthenticationRequest:^(ORCGIGURLJSONResponse *response) {
        
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
    
    NSDictionary *parametersJSON = @{
                                     @"grantType" : @"auth_user",
                                     @"credentials" : @{@"clientToken" : clientToken,
                                                        @"advertiserId" : advertiserId,
                                                        @"vendorId" : vendorId}};
    

    NSString *urlRequest = [ORCURLProvider endPointSecurityToken];
    
    ORCURLRequest *request = [[ORCURLRequest alloc] initWithMethod:@"POST" url:urlRequest];
    request.responseClass = [ORCGIGURLJSONResponse class];
    request.json = parametersJSON;
    request.logLevel = GIGLogLevelBasic;
    request.requestTag = @"accessToken";

    [self sendRequest:request completion:^(ORCGIGURLJSONResponse *response) {
        completion(response);
    }];

}


@end
