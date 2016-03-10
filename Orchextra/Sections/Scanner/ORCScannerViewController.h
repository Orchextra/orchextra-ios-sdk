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
#import "ORCScannerPresenter.h"

@class ORCSettingsPersister;


@interface ORCScannerViewController : GIGScannerViewController <GIGScannerViewControllerDelegate , ORCScannerViewControllerInterface>

@property (strong, nonatomic) ORCScannerPresenter *presenter;

- (instancetype)initWithStorage:(ORCSettingsPersister *)storage;

@end
