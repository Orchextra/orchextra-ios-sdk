//
//  ORCScannerViewController.m
//  Orchestra
//
//  Created by Judith Medina on 8/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ORCScannerViewController.h"
#import "ORCBarButtonItem.h"
#import "ORCSettingsPersister.h"
#import "ORCGIGLayout.h"
#import "ORCThemeSdk.h"
#import "UIImage+ORCGIGExtension.h"
#import "NSBundle+ORCBundle.h"
#import "ORCMBProgressHUD.h"

NSInteger PADDING_IMAGE = 20;
NSInteger MARGIN_TOP = 44;
NSInteger COPYRIGHT_RIGHT_MARGIN = 80;
NSInteger PADDING_SCANNER = 100;


@interface ORCScannerViewController ()

@property (strong, nonatomic) ORCSettingsPersister *storage;
@property (strong, nonatomic) UIView *containerScanner;
@property (strong, nonatomic) UIImageView *imageViewScanner;
@property (strong, nonatomic) UIImageView *imageViewCopyright;
@property (strong, nonatomic) UIImageView *torchImage;

@property (strong, nonatomic) NSArray *constraintSize;
@property (assign, nonatomic) BOOL *scannerBeingDissmissing;
@property (assign, nonatomic) BOOL enableTorch;

@end


@implementation ORCScannerViewController

#pragma mark - LIFECYCLE

- (instancetype)init
{
    ORCSettingsPersister *storage = [[ORCSettingsPersister alloc] init];
    return [self initWithStorage:storage];
}

- (instancetype)initWithStorage:(ORCSettingsPersister *)storage
{
    self = [super init];
    
    if (self)
    {
        _storage = storage;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startScanning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.presenter viewIsReady];
    
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ACTIONS

- (void)cancelButtonTapped
{
    [self.presenter userDidTapCancelScanner];
}

#pragma mark - DELEGATE

- (void)dismissScanner
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showScanner
{
    [self initialize];
}

- (void)stopScanner
{
    [self stopScanning];
}

- (void)showScannedValue:(NSString *)scannedValue statusMessage:(NSString *)statusMessage
{
    ORCMBProgressHUD *hud = [ORCMBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = statusMessage;
    hud.detailsLabelText = scannedValue;
    
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

        ORCMBProgressHUD *HUD = [[ORCMBProgressHUD alloc]
                                 initWithView:self.navigationController.view];
        
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:
                          [NSBundle imageFromBundleWithName:imageStatus]];
        
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = message;
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:1.0];
    });
}

- (void)scanViewController:(GIGScannerViewController *)aCtler didSuccessfullyScan:(NSString *)aScannedValue
                      type:(NSString *)type
{
    [self.presenter didSuccessfullyScan:aScannedValue type:type];
}

- (void)showCameraPermissionAlert
{
    NSString *title;
    title = LocalizableConstants.kLocaleOrcCameraPermissionOffTitle;
    
    NSString *message = LocalizableConstants.kLocaleOrcCameraPermissionOffMessage;
    
    NSString *otherButton = LocalizableConstants.kLocaleOrcGlobalSettingsButton;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:LocalizableConstants.kLocaleOrcGlobalCancelButton
                                              otherButtonTitles:otherButton, nil];
    [alertView show];
}

#pragma mark - PRIVATE

#pragma mark - Custom View

- (void)initialize
{
    [self customNavigationBar];
    
    self.containerScanner = [[UIView alloc] init];
    self.containerScanner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerScanner];
    gig_layout_top(self.containerScanner, MARGIN_TOP);
    gig_layout_right(self.containerScanner, 0);
    gig_layout_left(self.containerScanner, 0);
    gig_layout_bottom(self.containerScanner, 0);
    [self.view layoutIfNeeded];

    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(PADDING_IMAGE, PADDING_IMAGE, PADDING_IMAGE, PADDING_IMAGE);
    UIImage *imageScanner = [[NSBundle imageFromBundleWithName:@"frame-scan"] resizableImageWithCapInsets:edgeInsets];
    self.imageViewScanner = [[UIImageView alloc] initWithImage:imageScanner];
    self.imageViewScanner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerScanner addSubview:self.imageViewScanner];
    gig_layout_center(self.imageViewScanner);
    
    CGFloat minimumSize = MIN(CGRectGetHeight(self.containerScanner.bounds),
                              CGRectGetWidth(self.containerScanner.bounds)) - PADDING_SCANNER;
    CGSize sizeSquare = CGSizeMake(minimumSize, minimumSize);
    self.constraintSize = gig_constrain_size(self.imageViewScanner, sizeSquare);
    
    UIImage *copyrightScanner = [NSBundle imageFromBundleWithName:@"scanning-by"];
    self.imageViewCopyright = [[UIImageView alloc] initWithImage:copyrightScanner];
    self.imageViewCopyright.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerScanner addSubview:self.imageViewCopyright];
    gig_layout_below(self.imageViewCopyright, self.imageViewScanner, 0);
    
    NSLayoutConstraint *constraintPadding= [NSLayoutConstraint
                                            constraintWithItem:self.imageViewCopyright
                                            attribute:NSLayoutAttributeTrailing
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.imageViewScanner
                                            attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
    [self.containerScanner addConstraint:constraintPadding];
    [self.containerScanner layoutIfNeeded];
    
    [self addTorch];
    
    if (![self isCameraAvailable])
    {
        [self.presenter userNeedsCameraPermission];
    }
}

- (void)addTorch
{
    UIImage *torch = [NSBundle imageFromBundleWithName:@"torch"];
    
    UIBarButtonItem *torchButton = [[UIBarButtonItem alloc] initWithImage:torch style:UIBarButtonItemStylePlain target:self action:@selector(enableTorchButton)];
    self.navigationItem.rightBarButtonItem = torchButton;
}

- (void)enableTorchButton
{
    self.enableTorch = !self.enableTorch;
    [self setTorch:self.enableTorch];
}

- (void)customNavigationBar
{
    self.title = LocalizableConstants.kLocaleOrcScannerTitle;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self action:@selector(cancelButtonTapped)];
    
    self.navigationItem.leftBarButtonItem.title = LocalizableConstants.kLocaleOrcGlobalCancelButton;
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.presenter userDidTapSettingsButton];
    }
}

@end
