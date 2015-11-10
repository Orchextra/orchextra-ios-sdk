//
//  NSBundle+ORCBundle.h
//  Orchestra
//
//  Created by Judith Medina on 22/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORCLocalizedBundle(key, comment, chapter) \
NSLocalizedStringFromTableInBundle((key),(chapter),[NSBundle preferredLanguageResourcesBundle],(comment))

@interface NSBundle (ORCBundle)

+ (NSBundle*)preferredLanguageResourcesBundle;
+ (NSBundle *)bundleSDK;
+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;
+ (UIFont *)fontORCWithSize:(CGFloat)size;
+ (NSURL *)fileFromBundleWithName:(NSString *)filename;

@end
