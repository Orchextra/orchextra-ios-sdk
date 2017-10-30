//
//  GIGURLResponse.m
//  gignetwork
//
//  Created by Sergio Baró on 05/03/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLResponse.h"


@implementation GIGURLResponse

#pragma mark - INIT

- (instancetype)initWithData:(NSData *)data headers:(NSDictionary *)headers
{
    self = [super init];
    if (self)
    {
		[self initializeResponseWithData:data];
        _headers = headers;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
		[self initializeResponseWithData:data];
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error headers:(NSDictionary *)headers data:(NSData *)data;
{
    self = [super init];
    if (self)
    {
		[self initializeResponseWithError:error];
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
		[self initializeResponseWithError:error];
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


#pragma mark - PRIVATE

- (void)initializeResponseWithError:(NSError *)error
{
	self.success = NO;
	self.error = error;
}

- (void)initializeResponseWithData:(NSData *)data
{
	self.success = (data != nil);
	self.data = data;
}


- (NSString *)description
{
    if (self.success)
    {
        return [NSString stringWithFormat:@"%@ Success: data.length = %d", super.description, (int)self.data.length];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ Error (%d): %@", super.description, (int)self.error.code, self.error.localizedDescription];
    }
}

@end
