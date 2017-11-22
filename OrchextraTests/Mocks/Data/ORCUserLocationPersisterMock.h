//
//  ORCUserLocationPersisterMock.h
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCUserLocationPersister.h"

@interface ORCUserLocationPersisterMock : ORCUserLocationPersister

@property (assign, nonatomic) BOOL outStoreLastLocation;
@property (assign, nonatomic) BOOL outStoreLastPlacemark;
@property (assign, nonatomic) BOOL outStoreRegions;
@property (assign, nonatomic) BOOL outStoreLocationPersmissions;
@property (assign, nonatomic) BOOL outStoreEddystoneRegions;

@end
