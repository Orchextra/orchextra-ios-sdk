//
//  GIGURLImageResponse.h
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLResponse.h"

#import <UIKit/UIKit.h>


@interface ORCGIGURLImageResponse : ORCGIGURLResponse

@property (strong, nonatomic) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

@end
