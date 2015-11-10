//
//  ORCScannerViewController.h
//  Orchestra
//
//  Created by Judith Medina on 8/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIGScannerViewController.h"
#import "ORCActionInterface.h"

@class ORCScannerPresenter;
@class ORCStorage;


@interface ORCScannerViewController : GIGScannerViewController <GIGScannerViewControllerDelegate>

- (instancetype)initWithScanType:(NSString *)type actionInterface:(id<ORCActionInterface>)actionInterface;
- (instancetype)initWithScanType:(NSString *)type actionInterface:(id<ORCActionInterface>)actionInterface
                       presenter:(ORCScannerPresenter *)presenter
                         storage:(ORCStorage *)storage;
@end
