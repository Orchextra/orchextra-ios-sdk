//
//  ORCActionWebView.m
//  Orchestra
//
//  Created by Judith Medina on 14/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCActionWebView.h"
#import "ORCWebViewController.h"
#import "ORCActionInterface.h"
#import <SafariServices/SafariServices.h>

@implementation ORCActionWebView

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    UIViewController *webViewController = nil;
    if (NSClassFromString(@"SFSafariViewController"))
    {
        webViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.urlString]];
        UIViewController *topViewController = [actionInterface topViewController];
        
        BOOL viewControllerHasBeenPresented = [actionInterface viewControllerToBePresented:webViewController
                                                                isEqualToTopViewController:topViewController];
        
        if (!viewControllerHasBeenPresented)
        {
            [topViewController presentViewController:webViewController
                                            animated:YES
                                          completion:nil];
        }
    }
    else
    {
        webViewController = [[ORCWebViewController alloc] initWithURLString:self.urlString];
        [actionInterface presentViewController:webViewController];
    }
}

@end
