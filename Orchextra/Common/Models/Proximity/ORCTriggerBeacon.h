//
//  ORCTriggerBeacon.h
//  Orchestra
//
//  Created by Judith Medina on 7/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORCTriggerRegion.h"

@interface ORCTriggerBeacon : ORCTriggerRegion <NSCoding>

@property (strong, nonatomic) NSUUID *uuid;
@property (strong, nonatomic) NSNumber *major;
@property (strong, nonatomic) NSNumber *minor;
@property (assign, nonatomic) CLProximity currentProximity;

- (instancetype)initWithJSON:(NSDictionary *)json;
- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;
- (BOOL)setNewProximity:(CLProximity)newProximity;

@end

