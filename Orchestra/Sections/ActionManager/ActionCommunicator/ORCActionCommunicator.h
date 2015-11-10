//
//  ORCActionCommunicator.h
//  Orchestra
//
//  Created by Judith Medina on 29/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORCURLActionResponse.h"
#import "ORCURLCommunicator.h"

typedef void(^ORCActionResponse)(ORCURLActionResponse *responseAction);

@interface ORCActionCommunicator : ORCURLCommunicator

- (void)loadActionWithTriggerValues:(NSDictionary *)values completion:(ORCActionResponse)completion;

@end
