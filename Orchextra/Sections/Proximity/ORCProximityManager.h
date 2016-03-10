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
#import "ORCLocationManagerWrapper.h"

@class ORCActionCommunicator;
@class ORCValidatorActionInterator;
@class ORCSettingsInteractor;
@class ORCStayInteractor;

@interface ORCProximityManager : NSObject
<ORCLocationManagerDelegate>


- (instancetype)initWithActionInterface:(id<ORCActionInterface>)actionInterface;

- (instancetype)initWithActionInterface:(id<ORCActionInterface>)actionInterface
                    coreLocationManager:(ORCLocationManagerWrapper *)orcLocation
                             interactor:(ORCValidatorActionInterator *)interactor
                     settingsInteractor:(ORCSettingsInteractor *)settingsInteractor;


- (void)startMonitoringAndRangingOfRegions;
- (void)stopMonitoringAndRangingOfRegions;
- (void)updateUserLocation;

@end
