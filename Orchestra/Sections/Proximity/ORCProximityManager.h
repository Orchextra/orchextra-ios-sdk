//
//  GIGGeoMarketing.h
//  Orchestra
//
//  Created by Judith Medina on 17/4/15.
//  Copyright (c) 2015 Judith Medina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ORCActionInterface.h"
#import "ORCLocationManager.h"

@class ORCActionCommunicator;
@class ORCValidatorActionInterator;
@class ORCStayInteractor;

@interface ORCProximityManager : NSObject
<ORCLocationManagerDelegate>


- (instancetype)initWithActionManager:(id<ORCActionInterface>)actionInterface;
- (instancetype)initWithCoreLocationManager:(ORCLocationManager *)orcLocation
                            actionInterface:(id<ORCActionInterface>)actionInterface
                                 interactor:(ORCValidatorActionInterator *)interactor;
- (void)startProximityWithRegions:(NSArray *)geoRegions;
- (void)stopProximity;

- (void)updateUserLocation;
- (void)loadActionWithLocationEvent:(CLRegion *)region event:(NSInteger)event;

@end
