//
//  ORCDevice.h
//  Orchestra
//
//  Created by Judith Medina on 6/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORCDevice : NSObject

@property (strong, nonatomic) NSString *advertisingID;
@property (strong, nonatomic) NSString *vendorID;
@property (strong, nonatomic) NSString *versionIOS;
@property (strong, nonatomic) NSString *deviceOS;
@property (strong, nonatomic) NSString *handset;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *bundleId;
@property (strong, nonatomic) NSString *appVersion;
@property (strong, nonatomic) NSString *buildVersion;
@property (strong, nonatomic) NSString *timeZone;

@end
