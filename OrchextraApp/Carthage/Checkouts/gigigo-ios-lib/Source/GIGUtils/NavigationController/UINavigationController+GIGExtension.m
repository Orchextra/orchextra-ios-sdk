//
//  UINavigationController+GIGExtension.m
//  giglibrary
//
//  Created by Sergio Baró on 01/07/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "UINavigationController+GIGExtension.h"


@implementation UINavigationController (GIGExtension)

- (NSArray *)popNumberOfViewControllers:(NSInteger)numberOfViewControllers animated:(BOOL)animated
{
    NSInteger index = (self.viewControllers.count - 1) - numberOfViewControllers;
    
    if (index <= 0)
    {
        return [self popToRootViewControllerAnimated:animated];
    }
    else
    {
        UIViewController *viewController = self.viewControllers[index];
        
        return [self popToViewController:viewController animated:animated];
    }
}

@end
