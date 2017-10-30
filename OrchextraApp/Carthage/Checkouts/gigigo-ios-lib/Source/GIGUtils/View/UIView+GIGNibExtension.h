//
//  UIView+GIGNibExtension.h
//  giglibrary
//
//  Created by Sergio Baró on 02/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (GIGNibExtension)

+ (id)loadFromNib;
+ (id)loadFromNibWithOwner:(id)owner;

@end
