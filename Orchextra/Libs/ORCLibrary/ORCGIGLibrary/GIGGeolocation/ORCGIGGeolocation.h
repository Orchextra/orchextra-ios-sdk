//
//  GIGGeolocation.h
//  giglibrary
//
//  Created by Sergio Baró on 18/03/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^GIGGeolocationCompletion)(BOOL authorized, CLLocation *location, NSError *error);


@interface ORCGIGGeolocation : NSObject

- (BOOL)isAuthorized;
- (void)locateCompletion:(GIGGeolocationCompletion)completion;

@end
