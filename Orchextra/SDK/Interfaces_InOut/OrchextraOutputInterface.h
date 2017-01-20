//
//  OrchextraOutputInterface.h
//  Orchextra
//
//  Created by Judith Medina on 17/11/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORCVuforiaConfig;
@class ORCThemeSdk;

@protocol OrchextraOutputInterface <NSObject>

// ** GLOBAL CONFIGURATION **
- (BOOL)isOrchextraRunning;
- (NSString *)apiKey;
- (NSString *)apiSecret;
- (NSString *)clientToken;
- (NSString *)accessToken;

// ** CONFIGURATION **
- (ORCVuforiaConfig *)fetchVuforiaCredentials;
- (ORCThemeSdk *)fetchThemeSdk;


// ** PROXIMITY **
- (NSArray *)fetchGeofencesRegistered;
- (NSArray *)fetchBeaconsRegistered;

@end
