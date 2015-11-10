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

@class ORCValidatorActionInterator;

@protocol ORCScannerViewControllerInterface <NSObject>

- (void)showScanner;
- (void)stopScanner;
- (void)dismissScanner;
- (void)showScannedValue:(NSString *)scannedValue
           statusMessage:(NSString *)statusMessage;
- (void)showImageStatus:(NSString *)imageStatus message:(NSString *)message;

@end


@interface ORCScannerPresenter : NSObject

- (instancetype)initWithViewController:(UIViewController<ORCScannerViewControllerInterface> *)viewController
                          actionInterface:(id<ORCActionInterface>)actionInterface;
- (instancetype)initWithViewController:(UIViewController<ORCScannerViewControllerInterface> *)viewController
                         actionInterface:(id<ORCActionInterface>)actionInterface
                            interactor:(ORCValidatorActionInterator *)interactor;

- (void)viewIsReady;
- (void)userDidTapCancelScanner;
- (void)didSuccessfullyScan:(NSString *)aScannedValue type:(NSString *)type;

@end



