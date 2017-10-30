//
//  GIGURLRequest.h
//  gignetwork
//
//  Created by Sergio Baró on 26/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGConstants.h"
#import "GIGURLFile.h"
#import "GIGURLResponse.h"

@class GIGURLSessionFactory;
@class GIGURLRequestFactory;
@class GIGURLRequestLogger;
@class GIGURLManager;


extern NSTimeInterval const GIGURLRequestTimeoutDefault;
extern NSTimeInterval const GIGURLRequestFixtureDelayDefault;
extern NSTimeInterval const GIGURLRequestFixtureDelayNone;


typedef void(^GIGURLRequestCompletion)(id response);
typedef void(^GIGURLRequestProgress)(float progress); // 0.0 to 1.0
typedef NSURLCredential* (^GIGURLRequestCredential)(NSURLAuthenticationChallenge *challenge);


@interface GIGURLRequest : NSObject
<NSURLSessionDataDelegate>

@property (copy, nonatomic) NSString *method;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) Class /* GIGURLResponse */ responseClass;

@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;
@property (assign, nonatomic) NSTimeInterval timeout;
@property (assign, nonatomic) BOOL ignoreSSL;

@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSArray<GIGURLFile *> *files;
@property (strong, nonatomic) NSDictionary *json;

@property (copy, nonatomic) NSString *requestId;
@property (copy, nonatomic) NSString *requestTag;
@property (assign, nonatomic) GIGLogLevel logLevel;
@property (assign, nonatomic) NSTimeInterval fixtureDelay;
@property (copy, nonatomic) NSString *mockFilename;

@property (copy, nonatomic) GIGURLRequestCompletion completion;
@property (copy, nonatomic) GIGURLRequestProgress downloadProgress;
@property (copy, nonatomic) GIGURLRequestProgress uploadProgress;
@property (copy, nonatomic) GIGURLRequestCredential authentication;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url;
- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url manager:(GIGURLManager *)manager;
- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
                sessionFactory:(GIGURLSessionFactory *)sessionFactory
                requestFactory:(GIGURLRequestFactory *)requestFactory
                        logger:(GIGURLRequestLogger *)logger
                       manager:(GIGURLManager *)manager NS_DESIGNATED_INITIALIZER;

- (void)setHTTPBasicUser:(NSString *)user password:(NSString *)password;

- (void)send;
- (void)cancel;

@end
