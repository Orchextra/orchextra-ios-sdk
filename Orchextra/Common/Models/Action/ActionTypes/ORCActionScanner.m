//
//  ORCActionScanner.m
//  Orchestra
//
//  Created by Judith Medina on 14/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCActionScanner.h"
#import "ORCScannerViewController.h"
#import "ORCActionInterface.h"
#import "ORCScannerPresenter.H"


@implementation ORCActionScanner

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCScannerPresenter *presenter = [[ORCScannerPresenter alloc] init];
    presenter.actionInterface = actionInterface;
    presenter.actionLaunched = self;

    ORCScannerViewController *scannerViewController = [[ORCScannerViewController alloc] init];
    [actionInterface presentViewController:scannerViewController];
    scannerViewController.presenter = presenter;
    
    presenter.viewController = scannerViewController;
}

@end
