//
//  ORCWireframe.h
//  Orchestra
//
//  Created by Judith Medina on 14/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORCWireframe : NSObject

- (void)presentViewController:(UIViewController *)toViewController;
- (void)dismissActionWithViewController:(UIViewController *)viewController completion: (void (^)(void))completion;
- (void)pushActionToViewController:(UIViewController *)toViewController;
@end
