//
//  ORCActionBrowser.m
//  Orchextra
//
//  Created by Judith Medina on 14/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCActionBrowser.h"
#import "ORCOpenURL.h"

@implementation ORCActionBrowser

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCOpenURL *openURL = [[ORCOpenURL alloc] init];
    [openURL openBrowserWithURL:[NSURL URLWithString:self.urlString]];
}

@end
