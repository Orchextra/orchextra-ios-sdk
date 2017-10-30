//
//  GIGURLRequest.m
//  gignetwork
//
//  Created by Sergio Baró on 26/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLRequest.h"

#import "GIGURLSessionFactory.h"
#import "GIGURLRequestFactory.h"
#import "GIGURLRequestLogger.h"
#import "GIGURLManager.h"

#import "GIGDispatch.h"

NSString * const GIGNetworkErrorDomain = @"com.gigigo.network";
NSString * const GIGNetworkErrorMessage = @"GIGNETWORK_ERROR_MESSAGE";

NSTimeInterval const GIGURLRequestTimeoutDefault = 0.0f;
NSTimeInterval const GIGURLRequestFixtureDelayDefault = 0.5f;
NSTimeInterval const GIGURLRequestFixtureDelayNone = 0.0f;


@interface GIGURLRequest ()

@property (strong, nonatomic) GIGURLSessionFactory *sessionFactory;
@property (strong, nonatomic) GIGURLRequestFactory *requestFactory;
@property (strong, nonatomic) GIGURLRequestLogger *logger;
@property (strong, nonatomic) GIGURLManager *manager;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

@property (copy, nonatomic) NSURLCredential *httpBasicCredential;

@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSError *error;

@end


@implementation GIGURLRequest

- (instancetype)init
{
    return [self initWithMethod:@"GET" url:nil];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
{
    GIGURLManager *manager = [GIGURLManager sharedManager];
    
    return [self initWithMethod:method url:url manager:manager];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url manager:(GIGURLManager *)manager
{
    GIGURLSessionFactory *sessionFactory = [[GIGURLSessionFactory alloc] init];
    GIGURLRequestFactory *requestFactory = [[GIGURLRequestFactory alloc] init];
    GIGURLRequestLogger *logger = [[GIGURLRequestLogger alloc] init];
    
    return [self initWithMethod:method url:url sessionFactory:sessionFactory requestFactory:requestFactory logger:logger manager:manager];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
                sessionFactory:(GIGURLSessionFactory *)sessionFactory
                requestFactory:(GIGURLRequestFactory *)requestFactory
                        logger:(GIGURLRequestLogger *)logger
                       manager:(GIGURLManager *)manager
{
    self = [super init];
    if (self)
    {
        _method = method;
        _url = url;
        _sessionFactory = sessionFactory;
        _requestFactory = requestFactory;
        _logger = logger;
        _manager = manager;
        
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _timeout = GIGURLRequestTimeoutDefault;
        _fixtureDelay = GIGURLRequestFixtureDelayDefault;
        _responseClass = [GIGURLResponse class];
        _logLevel = GIGLogLevelError;
    }
    return self;
}

#pragma mark - ACCESSOR

- (void)setRequestTag:(NSString *)requestTag
{
    _requestTag = requestTag;
    
    self.logger.tag = requestTag;
}

- (void)setLogLevel:(GIGLogLevel)logLevel
{
    _logLevel = logLevel;
    
    self.logger.logLevel = logLevel;
}

#pragma mark - PUBLIC

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

- (void)send
{
    if ([self.manager requestShouldUseMock:self])
    {
        [self doFixtureRequest];
    }
    else
    {
        [self doActualRequest];
    }
}

- (void)cancel
{
    [self.session invalidateAndCancel];
}

#pragma mark - PRIVATE

- (void)doFixtureRequest
{
    if (self.fixtureDelay == GIGURLRequestFixtureDelayNone)
    {
        [self completeWithFixture];
    }
    else
    {
        __weak typeof(self) this = self;
        gig_dispatch_after_seconds(GIGURLRequestFixtureDelayDefault, ^{
            [this completeWithFixture];
        });
    }
}

- (void)doActualRequest
{
    self.session = [self.sessionFactory sessionForRequest:self];
    self.request = [self.requestFactory requestForRequest:self];
	
	[self.logger logRequest:self.request encoding:self.requestFactory.stringEncoding];
	
	if (!self.request) {
		[self completeWithInvalidRequest];
		return;
	}
	
	
    self.dataTask = [self.session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

- (void)completeWithData
{
    [self.logger logResponse:self.response data:self.data error:self.error stringEncoding:self.requestFactory.stringEncoding];
    
    if (self.completion != nil)
    {
        GIGURLResponse *response = [[self.responseClass alloc] initWithData:self.data headers:self.response.allHeaderFields];
        self.completion(response);
    }
    
    [self.session finishTasksAndInvalidate];
}

- (void)completeWithError
{
    [self.logger logResponse:self.response data:self.data error:self.error stringEncoding:self.requestFactory.stringEncoding];
    
    if (self.completion != nil)
    {
        GIGURLResponse *response = [[self.responseClass alloc] initWithError:self.error headers:self.response.allHeaderFields data:self.data];
        self.completion(response);
    }
    
    [self.session finishTasksAndInvalidate];
}

- (void)completeWithInvalidRequest
{
	self.error = [[NSError alloc] initWithDomain:GIGNetworkErrorDomain
											code:-1
										userInfo:@{NSLocalizedDescriptionKey: @"Invalid request"}];
	
	[self completeWithError];
}


- (void)completeWithFixture
{
    NSURL *URL = [NSURL URLWithString:self.url];
    self.response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    
    NSData *mockData = [self.manager mockForRequest:self];
    if (mockData == nil)
    {
        self.error = [NSError errorWithDomain:GIGNetworkErrorDomain code:404 userInfo:nil];
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

- (NSURLCredential *)credentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
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
    
    return credential;
}

#pragma mark - <NSObject>

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@: %@", super.description, self.method, self.url];
}

#pragma mark - DELEGATES

#pragma mark - <NSURLSessionDelegate>

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    if (error != nil)
    {
        self.error = error;
        [self completeWithError];
    }
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    NSURLCredential *credential = [self credentialForAuthenticationChallenge:challenge];
    
    if (credential != nil)
    {
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
    else
    {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

#pragma mark - <NSURLSessionTaskDelegate>

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (error == nil)
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
    else
    {
        self.error = error;
        [self completeWithError];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (self.uploadProgress != nil)
    {
        float progress = (float)totalBytesSent / (float)totalBytesExpectedToSend;
        self.uploadProgress(progress);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSURLCredential *credential = [self credentialForAuthenticationChallenge:challenge];
    
    if (credential != nil)
    {
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
    else
    {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

#pragma mark - <NSURLSessionDataDelegate>

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    self.response = (NSHTTPURLResponse *)response;
    self.data = [NSMutableData data];
    
    if (![self isSuccess])
    {
        self.error = [NSError errorWithDomain:NSURLErrorDomain code:self.response.statusCode userInfo:nil];
    }
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.data appendData:data];
    
    if (self.downloadProgress != nil)
    {
        float progress = ((float)self.data.length / (float)[self.response expectedContentLength]);
        self.downloadProgress(progress);
    }
}

@end
