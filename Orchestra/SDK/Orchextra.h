//
//  Orchestra.h
//  Orchestra
//
//  Created by Judith Medina on 27/4/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ORCUser.h"
#import "ORCData.h"
#import "ORCPushManager.h"
#import "ORCConstants.h"

@class ORCActionManager;
@class ORCConfigurationInteractor;

@protocol OrchextraCustomActionDelegate <NSObject>

- (void)executeCustomScheme:(NSString *)scheme;

@end


@interface Orchextra : NSObject

@property (weak, nonatomic) id <OrchextraCustomActionDelegate> delegate;

+ (instancetype)sharedInstance;
- (instancetype)initWithActionManager:(ORCActionManager *)actionManager
                     configInteractor:(ORCConfigurationInteractor *)configInteractor;

- (void)setApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
       completion:(void(^)(BOOL success, NSError *error))completion;

- (void)startScanner;
- (void)startImageRecognition;

// CONFIGURATION
- (void)debug:(BOOL)debug;
- (BOOL)isImageRecognitionAvailable;


@end
