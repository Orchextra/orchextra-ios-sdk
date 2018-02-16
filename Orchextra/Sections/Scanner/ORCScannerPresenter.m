//
//  ORCScanner.m
//  Orchestra
//
//  Created by Judith Medina on 8/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCScannerPresenter.h"
#import "ORCScannerViewController.h"
#import "ORCValidatorActionInterator.h"
#import "ORCStatisticsInteractor.h"
#import "ORCWireframe.h"
#import "NSBundle+ORCBundle.h"
#import "ORCConstants.h"

@interface ORCScannerPresenter()

@property (strong, nonatomic) ORCValidatorActionInterator *validator;
@property (strong, nonatomic) ORCStatisticsInteractor *statistics;
@property (strong, nonatomic) ORCWireframe *wireframe;
@property (strong, nonatomic) NSString *scannedValue;
@property (assign, nonatomic) BOOL waitingResponseScannedValue;

@end

@implementation ORCScannerPresenter

#pragma mark - INIT

- (instancetype)init
{
    ORCValidatorActionInterator *validator = [[ORCValidatorActionInterator alloc] init];
    ORCStatisticsInteractor *statistics = [[ORCStatisticsInteractor alloc] init];
    
    return [self initWithValidator:validator statistics:statistics];
}

- (instancetype)initWithValidator:(ORCValidatorActionInterator *)validator
                       statistics:(ORCStatisticsInteractor *)statistics
{
    self = [super init];
    
    if (self)
    {
        _validator = validator;
        _statistics = statistics;
        _waitingResponseScannedValue = NO;
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)viewIsReady
{
    [self.viewController showScanner];
}

- (void)userDidTapCancelScanner
{
    [self.viewController dismissScanner];
}

- (void)userNeedsCameraPermission
{
    [self.viewController showCameraPermissionAlert];
}

- (void)userDidTapSettingsButton {
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingsURL];
}

#pragma mark - PRIVATE

- (void)resetScannedValue
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scannedValue = @"";
        self.waitingResponseScannedValue = NO;
        [[ORCLog sharedInstance] logVerbose:@"Reset scanned value"];
    });
}

-(void)foundAction:(ORCAction *)action
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.waitingResponseScannedValue = NO;
        [self.viewController showImageStatus:@"37-Checkmark" message:LocalizableConstants.kLocaleOrcMatchFoundMessage];
        [self.viewController stopScanner];
        [self.actionInterface didFireTriggerWithAction:action fromViewController:self.viewController];
    });
}

- (void)notFoundAction
{
    [self.viewController showImageStatus:@"Fail_cross" message:LocalizableConstants.kLocaleOrcMatchNotFoundMessage];
    [self resetScannedValue];
}

#pragma mark - DELEGATE

- (void)didSuccessfullyScan:(NSString *)scannedValue type:(NSString *)type
{
    NSString *typeScanner = ORCTypeBarcode;
    
    if ([type isEqualToString:AVMetadataObjectTypeQRCode])
    {
        typeScanner = ORCTypeQR;
    }
    
    if (!self.waitingResponseScannedValue)
    {
        //Scanning ...
        [self.viewController showScannedValue:scannedValue statusMessage:@"Scanning..."];
        
        if (self.actionLaunched.launchedByTriggerCode) [self.statistics trackValue:scannedValue type:typeScanner withAction:self.actionLaunched];
        
        self.waitingResponseScannedValue = YES;
        self.scannedValue = scannedValue;
        
        __weak typeof(self) this = self;
        [self.validator validateScanType:typeScanner scannedValue:scannedValue completion:^(ORCAction *action, NSError *error) {
            
            if (action)
            {
                //Match ...
                [this performSelector:@selector(foundAction:) withObject:action afterDelay:1.0];
            }
            else
            {
                //Not match ...
                [this performSelector:@selector(notFoundAction) withObject:nil afterDelay:1.0];
                [[ORCLog sharedInstance] logError:@"%@", error.localizedDescription];
            }
        }];
    }
}

@end
