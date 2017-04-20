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

#import "ORCSettingsPersister.h"
#import "ORCVuforiaConfig.h"
#import "ORCGIGLogManager.h"
#import "NSBundle+ORCBundle.h"
#import <Orchextra/ORCLog.h>

@interface ORCActionVuforia ()

@property (nonatomic, strong) ORCSettingsPersister *persister;

@end

@implementation ORCActionVuforia

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
        [self executeIfHasVuforiaCredentialsWithActionInterface:actionInterface];
    }
    else
    {
        [ORCLog logError:@"Orchextra has been stopped - start orchextra before continuing."];
    }

}

- (void)executeIfHasVuforiaCredentialsWithActionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCVuforiaConfig *vuforiaConfig = [self.persister loadVuforiaConfig];

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
        [ORCLog logError:NSLocalizedString(@"orc_vuforia_error_missing_vuforia_credentials", nil)];
    }
}

@end
