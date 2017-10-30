//
//  GIGCommunicator.h
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 16/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGURLRequest.h"
#import "GIGURLResponses.h"

@class GIGURLRequestFactory;


typedef void(^GIGURLMultiRequestCompletion)(NSDictionary *responses);


@interface GIGURLCommunicator : NSObject

@property (assign, nonatomic) GIGLogLevel logLevel;
@property (assign, nonatomic, readonly) NSString *host;

- (instancetype)initWithManager:(GIGURLManager *)manager;
- (instancetype)initWithManager:(GIGURLManager *)manager requestFactory:(GIGURLRequestFactory *)requestFactory;

- (GIGURLRequest *)GET:(NSString *)url, ... NS_FORMAT_FUNCTION(1, 2);
- (GIGURLRequest *)POST:(NSString *)url, ... NS_FORMAT_FUNCTION(1, 2);
- (GIGURLRequest *)DELETE:(NSString *)url, ... NS_FORMAT_FUNCTION(1, 2);
- (GIGURLRequest *)PUT:(NSString *)url, ... NS_FORMAT_FUNCTION(1, 2);
- (GIGURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url, ... NS_FORMAT_FUNCTION(2, 3);

- (void)sendRequest:(GIGURLRequest *)request completion:(GIGURLRequestCompletion)completion;
- (void)sendRequests:(NSDictionary *)requests completion:(GIGURLMultiRequestCompletion)completion;
- (void)cancelLastRequest;

@end
