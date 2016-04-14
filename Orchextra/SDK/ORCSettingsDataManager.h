//
//  ORCSettingsDataManager.h
//  Orchestra
//
//  Created by Judith Medina on 10/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrchextraOutputInterface.h"

@class ORCUser;
@class ORCSettingsPersister;
@class ORCUserLocationPersister;

typedef void(^CompletionUpdateUser)(BOOL success);

@interface ORCSettingsDataManager : NSObject
<OrchextraOutputInterface>

- (instancetype)initWithSettingsPersister:(ORCSettingsPersister *)settingsPersister
                    userLocationPersister:(ORCUserLocationPersister *)userLocationPersister;

// INPUT DATA
- (void)setEnvironment:(NSString *)environment;
- (BOOL)extendBackgroundTime:(NSInteger)backgroundTime;


@end
