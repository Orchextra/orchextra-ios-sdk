//
//  ConfigurationInteractor.h
//  Orchestra
//
//  Created by Judith Medina on 5/10/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ORCStorage.h"

@class ORCUser;
@class ORCAppConfigCommunicator;

typedef void(^CompletionProjectRegions)(NSArray *regions, NSError *error);

@interface ORCConfigurationInteractor : NSObject

- (instancetype)initWithStorage:(ORCStorage *)storage communicator:(ORCAppConfigCommunicator *)communicator;

- (void)loadProjectWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret completion:(CompletionProjectRegions)completion;

- (void)saveUserData:(ORCUser *)userData;

- (ORCUser *)currentUser;

// --- GEOLOCATION --- //

- (void)storeLastLocation:(CLLocation *)location;

- (void)storeLastPlacemark:(CLPlacemark *)placemark;

@end
