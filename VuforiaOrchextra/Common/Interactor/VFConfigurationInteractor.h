//
//  VFConfigurationInteractor.h
//  Orchextra
//
//  Created by Judith Medina on 18/11/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORCVuforiaConfig;
@class ORCThemeSdk;

@interface VFConfigurationInteractor : NSObject

- (NSString *)vuforiaLicense;
- (ORCVuforiaConfig *)vuforiaCredentials;
- (ORCThemeSdk *)themeSDK;

@end
