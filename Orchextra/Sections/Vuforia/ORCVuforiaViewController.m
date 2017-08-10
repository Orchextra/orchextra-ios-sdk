//
//  ORCVuforiaViewController.m
//  Orchestra
//
//  Created by Judith Medina on 8/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "ORCVuforiaViewController.h"
#import "ORCBarButtonItem.h"
#import "ORCMBProgressHUD.h"
#import "VFConfigurationInteractor.h"

#import <GIGLibrary/GIGLayout.h>
#import <Orchextra/NSBundle+ORCBundle.h>
#import <Orchextra/ORCThemeSdk.h>


@interface ORCVuforiaViewController ()

@property (strong, nonatomic) VFConfigurationInteractor *interactor;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation ORCVuforiaViewController

#pragma mark - LIFECYCLE

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _interactor = [[VFConfigurationInteractor alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.presenter.delegate = self;
    
    //-- Launch Vuforia --
    UIView *viewVuforia = self.presenter.cloudView;
    viewVuforia.frame = self.view.bounds;
    [self.view addSubview:viewVuforia];
    
    [self initialize];
}


#pragma mark - ACTIONS

- (void)cancelButtonTapped
{
    [self.presenter userDidTapCancelVuforia];
}

#pragma mark - INTERFACE

- (void)dismissVuforia
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showScannedValue:(NSString *)scannedValue statusMessage:(NSString *)statusMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ORCMBProgressHUD *hud = [ORCMBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = statusMessage;
        hud.detailsLabelText = scannedValue;
        
    });
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ORCMBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)showImageStatus:(NSString *)imageStatus message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ORCMBProgressHUD *HUD = [[ORCMBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage: [NSBundle imageFromBundleWithName:imageStatus]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = message;
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:1.0];
    });
    
}

#pragma mark - INITIALIZE

- (void)initialize
{
    self.title = NSLocalizedString(@"orc_vuforia_title", nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"orc_global_cancel_button", nil);
}

@end
