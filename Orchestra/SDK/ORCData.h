//
//  ORCDataSource.h
//  Orchestra
//
//  Created by Judith Medina on 10/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORCData : NSObject

- (NSArray *)loadGeofencesRegistered;
- (NSArray *)loadBeaconsRegistered;

- (void)setEnvironment:(NSString *)environment;


@end
