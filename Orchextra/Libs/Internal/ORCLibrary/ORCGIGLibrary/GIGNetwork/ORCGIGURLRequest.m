//
//  GIGURLRequest.m
//  gignetwork
//
//  Created by Sergio Baró on 26/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLRequest.h"

#import "ORCGIGURLConnectionBuilder.h"
#import "ORCGIGURLRequestLogger.h"
#import "ORCGIGURLManager.h"

#import "GIGDispatch.h"


NSString * const ORCGIGNetworkErrorDomain = @"com.orchextra.network";

NSTimeInterval const ORCGIGURLRequestTimeoutDefault = 0.0f;
NSTimeInterval const ORCGIGURLRequestFixtureDelayDefault = 0.5f;
NSTimeInterval const ORCGIGURLRequestFixtureDelayNone = 0.0f;



@interface ORCGIGURLRequest ()

@property (strong, nonatomic) ORCGIGURLConnectionBuilder *connectionBuilder;
@property (strong, nonatomic) ORCGIGURLRequestLogger *requestLogger;
@property (strong, nonatomic) ORCGIGURLManager *manager;

@property (strong, nonatomic) NSURLConnection *connection;

@property (copy, nonatomic) NSURLCredential *httpBasicCredential;

@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSError *error;

@end


@implementation ORCGIGURLRequest

- (instancetype)init
{
    return [self initWithMethod:@"GET" url:nil];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
{
    ORCGIGURLManager *manager = [ORCGIGURLManager sharedManager];
    
    return [self initWithMethod:method url:url manager:manager];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url manager:(ORCGIGURLManager *)manager
{
    ORCGIGURLConnectionBuilder *connectionBuilder = [[ORCGIGURLConnectionBuilder alloc] init];
    ORCGIGURLRequestLogger *requestLogger = [[ORCGIGURLRequestLogger alloc] init];
    
    return [self initWithMethod:method url:url connectionBuilder:connectionBuilder requestLogger:requestLogger manager:manager];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
             connectionBuilder:(ORCGIGURLConnectionBuilder *)connectionBuilder
                 requestLogger:(ORCGIGURLRequestLogger *)requestLogger
                       manager:(ORCGIGURLManager *)manager
{
    self = [super init];
    if (self)
    {
        _method = method;
        _url = url;
        _connectionBuilder = connectionBuilder;
        _requestLogger = requestLogger;
        _manager = manager;
        
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _timeout = ORCGIGURLRequestTimeoutDefault;
        _fixtureDelay = ORCGIGURLRequestFixtureDelayDefault;
        _responseClass = [ORCGIGURLResponse class];
        _logLevel = GIGLogLevelError;
    }
    return self;
}

#pragma mark - ACCESSOR

- (void)setRequestTag:(NSString *)requestTag
{
    _requestTag = requestTag;
    
    self.requestLogger.tag = requestTag;
}

- (void)setLogLevel:(GIGLogLevel)logLevel
{
    _logLevel = logLevel;
    
    self.requestLogger.logLevel = logLevel;
}

#pragma mark - PUBLIC

- (void)send
{
    if (self.manager.useFixture)
    {
        if (self.fixtureDelay == ORCGIGURLRequestFixtureDelayNone)
        {
            [self completeWithFixture];
        }
        else
        {
            __weak typeof(self) this = self;
            gig_dispatch_after_seconds(ORCGIGURLRequestFixtureDelayDefault, ^{
                [this completeWithFixture];
            });
        }
        
        return;
    }

    self.connection = [self.connectionBuilder buildConnectionWithRequest:self];
    [self.requestLogger logRequest:self.connection.originalRequest encoding:self.connectionBuilder.stringEncoding];
    
    [self.connection start];
}

- (void)cancel
{
    [self.connection cancel];
}

- (void)setHTTPBasicUser:(NSString *)user password:(NSString *)password
{
    if (user.length > 0 && password.length > 0)
    {
        self.httpBasicCredential = [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceForSession];
    }
    else
    {
        self.httpBasicCredential = nil;
    }
}

#pragma mark - PRIVATE

- (void)completeWithData
{
    [self.requestLogger logResponse:self.response data:self.data error:self.error stringEncoding:self.connectionBuilder.stringEncoding];
    
    if (self.completion != nil)
    {
        ORCGIGURLResponse *response = [[self.responseClass alloc] initWithData:self.data headers:self.response.allHeaderFields];
        self.completion(response);
    }
}

- (void)completeWithError
{
    [self.requestLogger logResponse:self.response data:self.data error:self.error stringEncoding:self.connectionBuilder.stringEncoding];

    if (self.completion != nil)
    {
        ORCGIGURLResponse *response = [[self.responseClass alloc] initWithError:self.error headers:self.response.allHeaderFields data:self.data];
        self.completion(response);
    }
}

- (void)completeWithFixture
{
    NSURL *URL = [NSURL URLWithString:self.url];
    self.response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    
    NSData *mockData = [self.manager fixtureForRequestTag:self.requestTag];
    if (!mockData)
    {
        self.error = [NSError errorWithDomain:ORCGIGNetworkErrorDomain code:404 userInfo:nil];
        [self completeWithError];
        
        return;
    }
    
    self.data = [[NSMutableData alloc] initWithData:mockData];
    
    [self completeWithData];
}

- (BOOL)isSuccess
{
    return (self.response.statusCode >= 200 && self.response.statusCode < 300);
}

#pragma mark - DELEGATES

#pragma mark - <NSURLConnectionDelegate>

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    [self completeWithError];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSString *authenticationMethod = challenge.protectionSpace.authenticationMethod;
    
    NSURLCredential *credential = nil;
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] && self.ignoreSSL)
    {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    }
    
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        credential = self.httpBasicCredential;
    }
    
    if (credential == nil && self.authentication != nil)
    {
        credential = self.authentication(challenge);
    }
    
    if (credential != nil)
    {
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }
    else
    {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

#pragma mark - <NSURLConnectionDataDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    self.response = (NSHTTPURLResponse *)aResponse;
    self.data = [NSMutableData data];
    
    if (![self isSuccess])
    {
        self.error = [NSError errorWithDomain:ORCGIGNetworkErrorDomain code:self.response.statusCode userInfo:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData
{
    [self.data appendData:someData];
    
    if (self.downloadProgress)
    {
        float progress = ((float)self.data.length / (float)[self.response expectedContentLength]);
        self.downloadProgress(progress);
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.uploadProgress)
    {
        float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
        self.uploadProgress(progress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self isSuccess])
    {
        [self completeWithData];
    }
    else
    {
        [self completeWithError];
    }
}

@end
