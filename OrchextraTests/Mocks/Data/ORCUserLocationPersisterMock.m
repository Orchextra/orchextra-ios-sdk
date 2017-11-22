//
//  ORCUserLocationPersisterMock.m
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCUserLocationPersisterMock.h"

@implementation ORCUserLocationPersisterMock

-(void)storeLastLocation:(CLLocation *)location
{
    self.outStoreLastLocation = YES;
}

-(void)storeLastPlacemark:(CLPlacemark *)placemark
{
    self.outStoreLastPlacemark = YES;
}

-(void)storeRegions:(NSArray *)regions
{
    self.outStoreRegions = YES;
}

-(void)storeUserLocationPermission:(BOOL)hasPermission
{
    self.outStoreLocationPersmissions = YES;
}

- (void)storeEddystoneRegions:(NSArray<ORCEddystoneRegion *> *)regions
{
    self.outStoreEddystoneRegions = YES;
}

@end
