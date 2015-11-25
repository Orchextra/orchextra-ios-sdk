//
//  GIGCommunicator.h
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORCGIGURLRequest.h"

#import "ORCGIGURLImageResponse.h"
#import "ORCGIGURLJSONResponse.h"

@class ORCGIGURLRequestFactory;


typedef void(^GIGURLMultiRequestCompletion)(NSDictionary *responses);


@interface ORCGIGURLCommunicator : NSObject

@property (assign, nonatomic) GIGLogLevel logLevel;
@property (assign, nonatomic, readonly) NSString *host;

- (instancetype)initWithManager:(ORCGIGURLManager *)manager;
- (instancetype)initWithRequestFactory:(ORCGIGURLRequestFactory *)requestFactory;
- (instancetype)initWithRequestFactory:(ORCGIGURLRequestFactory *)requestFactory manager:(ORCGIGURLManager *)manager;

- (ORCGIGURLRequest *)GET:(NSString *)url;
- (ORCGIGURLRequest *)POST:(NSString *)url;
- (ORCGIGURLRequest *)DELETE:(NSString *)url;
- (ORCGIGURLRequest *)PUT:(NSString *)url;
- (ORCGIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url;

- (void)sendRequest:(ORCGIGURLRequest *)request completion:(ORCGIGURLRequestCompletion)completion;
- (void)sendRequests:(NSDictionary *)requests completion:(GIGURLMultiRequestCompletion)completion;
- (void)cancelLastRequest;

@end
