//
//  ORCActionVuforia.m
//  Orchestra
//
//  Created by Judith Medina on 8/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "ORCActionVuforia.h"
#import "ORCVuforiaPresenter.h"
#import "ORCVuforiaViewController.h"
#import "ORCActionInterface.h"

#import "ORCStorage.h"
#import "ORCVuforiaConfig.h"
#import "ORCGIGLogManager.h"
#import "NSBundle+ORCBundle.h"

@interface ORCActionVuforia ()

@end

@implementation ORCActionVuforia

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCStorage *storage = [[ORCStorage alloc] init];
    ORCVuforiaConfig *vuforiaConfig = [storage loadVuforiaConfig];
    
    if (vuforiaConfig)
    {
        ORCVuforiaViewController *vuforiaViewController = [[ORCVuforiaViewController alloc] init];
        ORCVuforiaPresenter *presenter = [[ORCVuforiaPresenter alloc] initWithViewController:vuforiaViewController
                                                                             actionInterface:actionInterface];
        
        vuforiaViewController.presenter = presenter;
        [actionInterface presentViewController:vuforiaViewController];
    }
    else
    {
        [ORCGIGLogManager log:ORCLocalizedBundle(@"ERROR_MISSING_VUFORIA_CREDENTIALS", nil, nil)];
    }
}

@end
