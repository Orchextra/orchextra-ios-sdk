//
//  ORCProximityFormatter.h
//  Orchextra
//
//  Created by Judith Medina on 1/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ORCProximityFormatter : NSObject

+ (NSString *)applicationStateString;
+ (NSString *)proximityEventToString:(NSInteger)typeEvent;
+ (NSString *)proximityDistanceToString:(CLProximity)proximity;
+ (NSString *)eddystoneProximityDistanceToString:(proximity)proximity;

@end
