//
//  ORCStayProximityInteractor.h
//  Orchestra
//
//  Created by Judith Medina on 11/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORCTriggerRegion.h"

@interface ORCStayInteractor : NSObject

- (void)performStayRequestWithRegion:(ORCTriggerRegion*)region
                         completion:(ORCCompletionStayTime)completion;

@end
