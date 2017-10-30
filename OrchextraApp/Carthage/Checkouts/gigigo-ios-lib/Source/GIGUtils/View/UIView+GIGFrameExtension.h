//
//  UIView+GIGFrameExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 02/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (GIGFrameExtension)

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGSize)size;
- (void)setSize:(CGSize)size;
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGFloat)maxX;
- (CGFloat)maxY;

@end
