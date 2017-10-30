//
//  UIView+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 02/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "UIView+GIGNibExtension.h"


@implementation UIView (GIGExtension)

+ (id)loadFromNib
{
	return [self loadFromNibWithOwner:nil];
}

+ (id)loadFromNibWithOwner:(id)owner
{
	return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:nil][0];
}

@end
