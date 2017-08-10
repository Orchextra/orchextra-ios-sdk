//
//  ORCURLActionResponse.h
//  Orchestra
//
//  Created by Judith Medina on 24/6/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <GIGLibrary/GIGURLJSONResponse.h>

@class ORCAction;

@interface ORCURLActionResponse : GIGURLJSONResponse

@property (strong, nonatomic) ORCAction *action;

@end
