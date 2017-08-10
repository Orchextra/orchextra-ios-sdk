//
//  ORCURLActionResponse.h
//  Orchestra
//
//  Created by Judith Medina on 24/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLJSONResponse.h"

@class ORCAction;

@interface ORCURLActionResponse : ORCGIGURLJSONResponse

@property (strong, nonatomic) ORCAction *action;

@end
