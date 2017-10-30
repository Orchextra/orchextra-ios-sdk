//
//  UIView+GIGSubviewsExtension.m
//  giglibrary
//
//  Created by sergiobaro on 26/02/14.
//  Copyright (c) 2014 Gigigo. All rights reserved.
//

#import "UIView+GIGSubviewsExtension.h"


@implementation UIView (GIGSubviewsExtension)

- (void)removeSubviews
{
    for (UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
}

@end
