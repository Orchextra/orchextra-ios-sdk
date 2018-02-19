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
#import "ORCScannerPresenter.h"
#import "ORCSettingsPersister.h"

@interface ORCActionScanner()

@property (nonatomic, strong) ORCSettingsPersister *persister;

@end

@implementation ORCActionScanner

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _persister = [[ORCSettingsPersister alloc] init];
    }
    
    return self;
}

- (void)executeActionWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    BOOL isOrchextraRunning = [self.persister loadOrchextraState];

    if (isOrchextraRunning)
    {
        ORCScannerPresenter *presenter = [[ORCScannerPresenter alloc] init];
        presenter.actionInterface = actionInterface;
        presenter.actionLaunched = self;
        
        ORCScannerViewController *scannerViewController = [[ORCScannerViewController alloc] init];
        [actionInterface presentViewController:scannerViewController];
        scannerViewController.presenter = presenter;
        
        presenter.viewController = scannerViewController;
    }
    else
    {
        [[ORCLog sharedInstance] logError:@"Orchextra has been stopped - start orchextra before continuing."];
    }
}

@end
