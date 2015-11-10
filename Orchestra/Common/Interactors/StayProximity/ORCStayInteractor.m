//
//  ORCStayProximityInteractor.m
//  Orchestra
//
//  Created by Judith Medina on 11/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCStayInteractor.h"
#import "ORCTriggerRegion.h"
#import "ORCTriggerBeacon.h"

@interface ORCStayInteractor ()

@property (strong, nonatomic) CompletionStayTime completion;
@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (strong, nonatomic) NSTimer *timerRegion;

@end

@implementation ORCStayInteractor


- (void)performStayRequestWithRegion:(ORCTriggerRegion*)region completion:(CompletionStayTime)completion
{
    
    self.completion = completion;
    
    if(region.timer > 0)
    {
        UIApplication  *app = [UIApplication sharedApplication];
        self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:self.bgTask];
        }];
        
        self.timerRegion = [NSTimer scheduledTimerWithTimeInterval:region.timer target:self
                                                          selector:@selector(resetTimer)
                                                          userInfo:nil repeats:NO];
    }
    else
    {
        if ([region isKindOfClass:[ORCTriggerBeacon class]])
        {
            completion(YES);
        }
        else
        {
            completion(NO);
        }
    }
}

-(void)resetTimer
{
    self.timerRegion = nil;
    self.completion(YES);
}

@end
