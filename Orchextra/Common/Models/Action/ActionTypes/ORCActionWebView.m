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


@implementation ORCActionWebView

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCWebViewController *webViewController = [[ORCWebViewController alloc] initWithURLString:self.urlString];
    [actionInterface presentViewController:webViewController];
}

@end
