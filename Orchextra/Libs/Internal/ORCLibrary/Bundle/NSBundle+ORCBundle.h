//
//  NSBundle+ORCBundle.h
//  Orchestra
//
//  Created by Judith Medina on 22/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (ORCBundle)

+ (NSBundle *)bundleSDK;
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;
+ (UIFont *)fontORCWithSize:(CGFloat)size;
+ (NSURL *)fileFromBundleWithName:(NSString *)filename;
+ (NSString *)localize:(NSString *)key comment:(NSString *)comment;

@end
