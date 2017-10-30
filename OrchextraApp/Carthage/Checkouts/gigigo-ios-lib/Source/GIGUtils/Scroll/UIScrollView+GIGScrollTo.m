//
//  UIScrollView+GIGScrollTo.m
//  giglibrary
//
//  Created by Sergio Baró on 10/09/2013.
//  Copyright (c) 2013 Gigigo. All rights reserved.
//

#import "UIScrollView+GIGScrollTo.h"


@implementation UIScrollView (GIGScrollTo)

- (void)scrollToTop
{
	CGPoint topOffset = CGPointMake(self.contentOffset.x, 0);
	[self setContentOffset:topOffset animated:YES];
}

- (void)scrollToBottom
{
	CGPoint bottomOffset = CGPointMake(self.contentOffset.x, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom);
	[self setContentOffset:bottomOffset animated:YES];
}

@end
