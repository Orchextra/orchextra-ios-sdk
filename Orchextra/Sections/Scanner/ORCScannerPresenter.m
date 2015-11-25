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
#import "ORCActionInterface.h"
#import "ORCWireframe.h"
#import "NSBundle+ORCBundle.h"
#import "ORCConstants.h"

@interface ORCScannerPresenter()

@property (weak, nonatomic) UIViewController<ORCScannerViewControllerInterface> *viewController;
@property (weak, nonatomic) id<ORCActionInterface> actionInterface;
@property (strong, nonatomic) ORCValidatorActionInterator *interactor;
@property (strong, nonatomic) ORCWireframe *wireframe;
@property (strong, nonatomic) NSString *scannedValue;
@property (assign, nonatomic) BOOL waitingResponseScannedValue;

@end

@implementation ORCScannerPresenter

#pragma mark - INIT

- (instancetype)initWithViewController:(UIViewController<ORCScannerViewControllerInterface> *)viewController
                       actionInterface:(id<ORCActionInterface>)actionInterface
{
    ORCValidatorActionInterator *interactor = [[ORCValidatorActionInterator alloc] init];
    return [self initWithViewController:viewController actionInterface:actionInterface interactor:interactor];
}

- (instancetype)initWithViewController:(UIViewController<ORCScannerViewControllerInterface> *)viewController
                         actionInterface:(id<ORCActionInterface>)actionInterface
                            interactor:(ORCValidatorActionInterator *)interactor
{
    self = [super init];
    
    if (self)
    {
        _viewController = viewController;
        _actionInterface = actionInterface;
        _interactor = interactor;
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

#pragma mark - PRIVATE

- (void)resetScannedValue
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scannedValue = @"";
        self.waitingResponseScannedValue = NO;
    });
}

-(void)foundAction:(ORCAction *)action
{
    self.waitingResponseScannedValue = NO;
    [self.viewController showImageStatus:@"37-Checkmark" message:ORCLocalizedBundle(@"match_found", nil, nil)];
    [self.viewController stopScanner];
    [self.actionInterface didFireTriggerWithAction:action fromViewController:self.viewController];
}

- (void)notFoundAction
{
    [self.viewController showImageStatus:@"Fail_cross" message:ORCLocalizedBundle(@"match_not_found", nil, nil)];
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
        
        self.waitingResponseScannedValue = YES;
        self.scannedValue = scannedValue;
        
        __weak typeof(self) this = self;
        [this.interactor validateScanType:typeScanner scannedValue:scannedValue completion:^(ORCAction *action, NSError *error) {
            
            if (action)
            {
                //Match ...
                [this performSelector:@selector(foundAction:) withObject:action afterDelay:2.0];
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
                //Not match ...
                [this performSelector:@selector(notFoundAction) withObject:nil afterDelay:2.0];
            }
        }];
    }
}

@end
