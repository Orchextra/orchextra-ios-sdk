//
//  GIGURLSessionFactory.m
//  GIGLibrary
//
//  Created by Sergio Baró on 16/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import "GIGURLSessionFactory.h"

#import "GIGURLRequest.h"


@interface GIGURLSessionFactory ()

@property (nonnull, strong, nonatomic) NSURLSessionConfiguration *configuration;
@property (nullable, strong, nonatomic) NSOperationQueue *queue;

@end


@implementation GIGURLSessionFactory

#pragma mark - INIT

- (instancetype)init
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    return [self initWithConfiguration:configuration queue:queue];
}

- (instancetype)initWithConfiguration:(nonnull NSURLSessionConfiguration *)configuration queue:(nullable NSOperationQueue *)queue
{
    self = [super init];
    if (self)
    {
        _configuration = configuration;
        _queue = queue;
    }
    return self;
}

#pragma mark - PUBLIC

- (NSURLSession *)sessionForRequest:(nonnull GIGURLRequest<NSURLSessionDataDelegate> *)request
{
    return [NSURLSession sessionWithConfiguration:self.configuration delegate:request delegateQueue:self.queue];
}

@end
