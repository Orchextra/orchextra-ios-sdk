//
//  ORCStatisticsInteractorMock.m
//  Orchextra
//
//  Created by Judith Medina on 12/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCStatisticsInteractorMock.h"

@implementation ORCStatisticsInteractorMock

- (void)trackActionHasBeenLaunched:(ORCAction *)action
{
    self.outTrackActionHasBeenLaunchedCalled = YES;
}


@end
