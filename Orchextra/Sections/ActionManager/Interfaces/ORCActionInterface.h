//
//  Header.h
//  Orchextra
//
//  Created by Judith Medina on 20/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Orchestra_Header_h
#define Orchestra_Header_h

@class ORCAction;

@protocol ORCActionInterface <NSObject>

- (void)didFireTriggerWithAction:(ORCAction *)action;
- (void)didFireTriggerWithAction:(ORCAction *)action fromViewController:(UIViewController *)viewController;

- (void)presentViewController:(UIViewController *)toViewController;
- (void)presentActionWithCustomScheme:(NSString *)customScheme;
- (void)pushActionToViewController:(UIViewController *)toViewController;

@end

#endif
