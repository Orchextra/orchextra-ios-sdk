//
//  UIView+GIGTransformExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 13/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "UIView+GIGTransformExtension.h"


@implementation UIView (GIGTransformExtension)

- (void)rotateDegrees:(NSInteger)degrees
{
	CGFloat radians = (degrees * M_PI) / 180.0f;
	self.transform = CGAffineTransformMakeRotation(radians);
}

- (void)scale:(CGFloat)scale
{
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

@end
