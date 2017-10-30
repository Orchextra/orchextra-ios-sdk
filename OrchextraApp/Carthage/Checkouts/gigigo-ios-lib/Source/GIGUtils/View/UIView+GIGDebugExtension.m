//
//  UIView+GIGDebug.m
//  giglibrary
//
//  Created by Sergio Baró on 13/03/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "UIView+GIGDebugExtension.h"

@implementation UIView (GIGDebugExtension)

- (NSString *)subtreeDescription
{
	return [self subtreeDescriptionWithIndent:@""];
}

- (NSString *)subtreeDescriptionWithIndent:(NSString *)indent
{
	NSMutableString * desc = [NSMutableString string];
	[desc appendFormat:@"%@%@\n", indent, [self description]];
	NSString * subindent = [indent stringByAppendingString:@"    "];
	for (UIView * v in [self subviews]) {
		[desc appendFormat:@"%@", [v subtreeDescriptionWithIndent:subindent]];
	}
	return desc;
}

@end
