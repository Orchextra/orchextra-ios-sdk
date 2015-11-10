//
//  GIGURLImageResponse.m
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLImageResponse.h"


@implementation ORCGIGURLImageResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self)
    {
        self.image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
        self.success = (self.image != nil);
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    
    return [self initWithData:data];
}

@end
