//
//  GLAMainViewController.m
//  GIGLibraryApp
//
//  Created by Alejandro Jiménez Agudo on 28/4/15.
//  Copyright (c) 2015 Gigigo SL. All rights reserved.
//

#import "GLAMainViewController.h"

#import "GIGURLManager.h"


@interface GLAMainViewController ()

@end


@implementation GLAMainViewController

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [[GIGURLManager sharedManager] showConfig];
    }
}

@end
