//
//  ORCWireframe.m
//  Orchestra
//
//  Created by Judith Medina on 14/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCWireframe.h"

#import "ORCScannerViewController.h"

@interface ORCWireframe ()

@property (weak, nonatomic) id <ORCActionInterface> actionInterface;

@end

@implementation ORCWireframe


#pragma mark - PUBLIC

- (void)presentViewController:(UIViewController *)toViewController
{
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topViewController.presentedViewController)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)topViewController;
        UIViewController *firstViewController = navController.viewControllers[0];
        
        if ([firstViewController isKindOfClass:[toViewController class]])
        {
            topViewController = nil;
        }
    }
    
    if (topViewController)
    {
        UINavigationController *navController = [[UINavigationController alloc]
                                                 initWithRootViewController:toViewController];
        [topViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)dismissActionWithViewController:(UIViewController *)viewController completion: (void (^)(void))completion
{
    if (viewController)
    {
        [viewController dismissViewControllerAnimated:YES completion:^{
            completion();
        }];
    }
    else
    {
        completion();
    }
}

- (void)pushActionToViewController:(UIViewController *)toViewController
{
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topViewController.presentedViewController)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)topViewController;
        UIViewController *firstViewController = navController.viewControllers[0];
        
        if ([firstViewController isKindOfClass:[toViewController class]])
        {
            topViewController = nil;
        }
    }
    
    [topViewController.navigationController pushViewController:toViewController animated:YES];
}


@end
