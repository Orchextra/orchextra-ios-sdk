//
//  UIScreen+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 04/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "UIScreen+GIGExtension.h"


@implementation UIScreen (GIGExtension)

+ (BOOL)isRetina
{
	return [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2;
}

+ (BOOL)isWidescreen
{
	return ([UIScreen mainScreen].bounds.size.height == 568);
}

@end
