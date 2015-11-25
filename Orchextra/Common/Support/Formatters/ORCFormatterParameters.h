//
//  ORCDeviceStorage.h
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ORCUser;

@interface ORCFormatterParameters : NSObject

- (NSDictionary *)formatterParameteresDevice;
- (NSDictionary *)formattedPlacemark:(CLPlacemark *)placemark;
- (NSDictionary *)formattedUserLocation:(CLLocation *)userLocation;
- (NSDictionary *)formattedUserData:(ORCUser *)userData;

- (NSDictionary *)formattedCurrentUserLocation;

@end
