//
//  ORCApplicationCenter.h
//  Orchextra
//
//  Created by Judith Medina on 4/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ORCActionManager;
@class ORCSettingsInteractor;

@interface ORCApplicationCenter : NSObject

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter
                             actionManager:(ORCActionManager *)actionManager
                        settingsInteractor:(ORCSettingsInteractor *)settingsInteractor;

- (void)observeAppDelegateEvents;
- (void)extendBackgroundRunningTime;

@end
