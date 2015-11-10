//
//  GIGURLRequest.h
//  gignetwork
//
//  Created by Sergio Baró on 26/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORCGIGConstants.h"
#import "ORCGIGURLFile.h"
#import "ORCGIGURLResponse.h"

@class ORCGIGURLConnectionBuilder;
@class ORCGIGURLRequestLogger;
@class ORCGIGURLManager;


extern NSTimeInterval const ORCGIGURLRequestTimeoutDefault;
extern NSTimeInterval const ORCGIGURLRequestFixtureDelayDefault;
extern NSTimeInterval const ORCGIGURLRequestFixtureDelayNone;


typedef void(^ORCGIGURLRequestCompletion)(id response);
typedef void(^ORCGIGURLRequestProgress)(float progress); // 0.0 to 1.0
typedef NSURLCredential* (^GIGURLRequestCredential)(NSURLAuthenticationChallenge *challenge);


@interface ORCGIGURLRequest : NSObject
<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;
@property (assign, nonatomic) NSTimeInterval timeout;
@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSArray *files; // GIGURLFile instances
@property (strong, nonatomic) NSDictionary *json;
@property (strong, nonatomic) Class responseClass; // GIGURLResponse or subclass

@property (strong, nonatomic) NSString *requestTag;
@property (assign, nonatomic) GIGLogLevel logLevel;
@property (assign, nonatomic) NSTimeInterval fixtureDelay;
@property (assign, nonatomic) BOOL ignoreSSL;

@property (copy, nonatomic) ORCGIGURLRequestCompletion completion;
@property (copy, nonatomic) ORCGIGURLRequestProgress downloadProgress;
@property (copy, nonatomic) ORCGIGURLRequestProgress uploadProgress;
@property (copy, nonatomic) GIGURLRequestCredential authentication;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url;
- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url manager:(ORCGIGURLManager *)manager;
- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
             connectionBuilder:(ORCGIGURLConnectionBuilder *)connectionBuilder
                 requestLogger:(ORCGIGURLRequestLogger *)requestLogger
                       manager:(ORCGIGURLManager *)manager NS_DESIGNATED_INITIALIZER;

- (void)send;
- (void)cancel;

- (void)setHTTPBasicUser:(NSString *)user password:(NSString *)password;

@end
