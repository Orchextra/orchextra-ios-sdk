//
//  ORCStatisticsInteractor.h
//  Orchextra
//
//  Created by Judith Medina on 12/1/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORCAction;

@interface ORCStatisticsInteractor : NSObject

- (void)trackActionHasBeenLaunched:(ORCAction *)action;
- (void)trackValue:(NSString *)value type:(NSString *)type withAction:(ORCAction *)action;

@end
