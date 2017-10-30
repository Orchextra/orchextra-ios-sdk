//
//  GIGURLSessionFactory.h
//  GIGLibrary
//
//  Created by Sergio Baró on 16/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLRequest;


@interface GIGURLSessionFactory : NSObject

- (nonnull instancetype)initWithConfiguration:(nonnull NSURLSessionConfiguration *)configuration queue:(nullable NSOperationQueue *)queue NS_DESIGNATED_INITIALIZER;

- (nonnull NSURLSession *)sessionForRequest:(nonnull GIGURLRequest<NSURLSessionDataDelegate> *)request;

@end
