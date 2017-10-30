//
//  UIView+GIGFrameExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 02/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "UIView+GIGFrameExtension.h"


@implementation UIView (GIGFrameExtension)

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat)x
{
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setSize:(CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (CGPoint)origin
{
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}

- (CGFloat)maxX
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)maxY
{
    return self.frame.origin.y + self.frame.size.height;
}

@end
