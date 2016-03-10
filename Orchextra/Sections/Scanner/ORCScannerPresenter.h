//
//  ORCScanner.h
//  Orchestra
//
//  Created by Judith Medina on 8/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ORCActionInterface.h"
#import "ORCAction.h"

@class ORCValidatorActionInterator;
@class ORCStatisticsInteractor;

@protocol ORCScannerViewControllerInterface <NSObject>

- (void)showScanner;
- (void)stopScanner;
- (void)dismissScanner;
- (void)showScannedValue:(NSString *)scannedValue
           statusMessage:(NSString *)statusMessage;
- (void)showImageStatus:(NSString *)imageStatus message:(NSString *)message;

@end


@interface ORCScannerPresenter : NSObject


@property (weak, nonatomic) UIViewController<ORCScannerViewControllerInterface> *viewController;
@property (weak, nonatomic) id<ORCActionInterface> actionInterface;
@property (strong, nonatomic) ORCAction *actionLaunched;

- (instancetype)initWithValidator:(ORCValidatorActionInterator *)validator
                       statistics:(ORCStatisticsInteractor *)statistics;
- (void)viewIsReady;
- (void)userDidTapCancelScanner;
- (void)didSuccessfullyScan:(NSString *)aScannedValue type:(NSString *)type;

@end



