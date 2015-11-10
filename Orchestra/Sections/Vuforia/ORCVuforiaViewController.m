//
//  ORCVuforiaViewController.m
//  Orchestra
//
//  Created by Judith Medina on 8/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "ORCVuforiaViewController.h"
#import "NSBundle+ORCBundle.h"
#import "ORCStorage.h"
#import "ORCThemeSdk.h"
#import "ORCBarButtonItem.h"
#import "ORCGIGLayout.h"
#import "ORCMBProgressHUD.h"

@interface ORCVuforiaViewController ()

@property (strong, nonatomic) ORCStorage *storage;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation ORCVuforiaViewController

#pragma mark - LIFECYCLE

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _storage = [[ORCStorage alloc] init];
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
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
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
        [HUD hide:YES afterDelay:2.0];
    });
    
}

#pragma mark - INITIALIZE

- (void)initialize
{
    ORCThemeSdk *theme = [self.storage loadThemeSdk];
    self.title = ORCLocalizedBundle(@"Vuforia", nil, nil);
    
    if (theme.secondaryColor)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : theme.secondaryColor}];
    }
    
    self.navigationItem.leftBarButtonItem = [[ORCBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem.title = ORCLocalizedBundle(@"cancel_button", nil, nil);
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.backgroundColor = theme.secondaryColor;
    self.infoLabel.layer.cornerRadius = 15;
    self.infoLabel.clipsToBounds = YES;
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.alpha = 0.0;
    self.infoLabel.font = [UIFont boldSystemFontOfSize:15.0];

    [self.view addSubview:self.infoLabel];
    gig_layout_bottom(self.infoLabel, 30);
    gig_constrain_size(self.infoLabel, CGSizeMake(self.view.frame.size.width - 80, 40));
    gig_layout_center_horizontal(self.infoLabel, 0);

}

@end
