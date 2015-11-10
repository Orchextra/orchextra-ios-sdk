//
//  GIGURLResponse.m
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLResponse.h"


@implementation ORCGIGURLResponse

- (instancetype)initWithData:(NSData *)data headers:(NSDictionary *)headers
{
    self = [self initWithData:data];
    if (self)
    {
        _headers = headers;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        _success = (data != nil);
        _data = data;
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error headers:(NSDictionary *)headers data:(NSData *)data;
{
    self = [self initWithError:error];
    
    if (self)
    {
        _headers = headers;
        _data = data;
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error
{
    self = [super init];
    if (self)
    {
        _success = NO;
        _error = error;
    }
    return self;
}

- (instancetype)initWithSuccess:(BOOL)success
{
    self = [super init];
    if (self)
    {
        _success = success;
    }
    return self;
}

@end
