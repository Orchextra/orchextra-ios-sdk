//
//  UIView+GIGBorderShadowExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 02/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "UIView+GIGBorderShadowExtension.h"

#import <QuartzCore/QuartzCore.h>


@implementation UIView (GIGBorderShadowExtension)

- (void)setBorderWidth:(CGFloat)borderWidth color:(UIColor *)color
{
	self.layer.borderWidth = borderWidth;
	self.layer.borderColor = color.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = cornerRadius;
}

@end
