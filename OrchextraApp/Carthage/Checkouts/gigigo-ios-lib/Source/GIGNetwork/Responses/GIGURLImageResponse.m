//
//  GIGURLImageResponse.m
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLImageResponse.h"


@implementation GIGURLImageResponse

- (instancetype)initWithData:(NSData *)data headers:(NSDictionary *)headers
{
	self = [super initWithData:data headers:headers];
	if (self)
	{
		[self initializeImageWithData:data];
	}
	return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self)
    {
		[self initializeImageWithData:data];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    
    return [self initWithData:data];
}


- (void)initializeImageWithData:(NSData *)data
{
	self.image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
	self.success = (self.image != nil);
}


@end
