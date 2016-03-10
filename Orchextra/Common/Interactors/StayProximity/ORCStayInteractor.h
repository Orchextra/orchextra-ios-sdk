//
//  ORCStayProximityInteractor.h
//  Orchestra
//
//  Created by Judith Medina on 11/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORCRegion.h"

@interface ORCStayInteractor : NSObject

- (void)performStayRequestWithRegion:(ORCRegion*)region
                         completion:(ORCCompletionStayTime)completion;

@end
