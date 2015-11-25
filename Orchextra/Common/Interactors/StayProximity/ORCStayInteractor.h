//
//  ORCStayProximityInteractor.h
//  Orchestra
//
//  Created by Judith Medina on 11/9/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionStayTime)(BOOL success);

@class ORCTriggerRegion;

@interface ORCStayInteractor : NSObject

- (void)performStayRequestWithRegion:(ORCTriggerRegion*)region
                         completion:(CompletionStayTime)completion;

@end
