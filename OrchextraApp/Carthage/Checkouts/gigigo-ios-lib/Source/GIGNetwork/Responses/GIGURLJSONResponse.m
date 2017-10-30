//
//  GIGURLJSONResponse.m
//  GIGLibrary
//
//  Created by Sergio Baró on 29/06/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GIGURLJSONResponse.h"

#import "GIGJSON.h"


@implementation GIGURLJSONResponse

- (instancetype)initWithData:(NSData *)data headers:(NSDictionary *)headers;
{
	self = [super initWithData:data headers:headers];
	
	if (self)
	{
		[self initializeJSONResponseWithData:data];
	}
	
	return self;
}


- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self)
    {
		[self initializeJSONResponseWithData:data];
    }
    return self;
}

- (instancetype)initWithJSON:(id)json
{
    NSData *data = [json toData];
	
    return [self initWithData:data];
}


#pragma mark - Private Helpers

- (void)initializeJSONResponseWithData:(NSData *)data
{
	if (self.success)
	{
		NSError *error = nil;
		self.json = [data toJSONError:&error];
		if (self.json == nil)
		{
			self.success = NO;
			self.error = error;
		}
	}
}


@end
