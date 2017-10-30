//
//  UIView+GIGBorderShadowExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 02/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (GIGBorderShadowExtension)

- (void)setBorderWidth:(CGFloat)borderWidth color:(UIColor *)color;
- (void)setCornerRadius:(CGFloat)cornerRadius;

@end
