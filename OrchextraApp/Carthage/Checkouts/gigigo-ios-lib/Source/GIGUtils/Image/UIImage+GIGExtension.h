//
//  UIImage+GIGExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 29/10/13.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (GIGExtension)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageFromMaskImage:(UIImage *)mask withColor:(UIColor *) color;

- (UIImage *)imageWithSize:(CGSize)size;
- (UIImage *)imageProportionallyWithSize:(CGSize)size;

- (UIImage *)imageCroppedWithSize:(CGSize)size;

@end
