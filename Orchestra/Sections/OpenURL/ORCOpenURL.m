//
//  ORCOpenURLPresenter.m
//  Orchestra
//
//  Created by Judith Medina on 30/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCOpenURL.h"
#import "ORCWebViewController.h"

@implementation ORCOpenURL

- (void)openBrowserWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

@end
