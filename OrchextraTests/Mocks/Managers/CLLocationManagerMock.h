//
//  CLLocationManagerMock.h
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocationManagerMock : CLLocationManager
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *didLocationUpdate;

@property (assign, nonatomic) BOOL outStartMonitoringRegionCalled;
@property (assign, nonatomic) BOOL outStartRangingBeaconCalled;
@property (assign, nonatomic) BOOL outDidUpdateLocationCalled;
@property (assign, nonatomic) BOOL outstartUpdatingLocationCalled;
@property (assign, nonatomic) BOOL outstopUpdatingLocationCalled;


@property (strong, nonatomic) NSSet<CLRegion *> *inRangedBeacons;

@end
