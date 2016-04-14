//
//  VuforiaOrchextra.h
//  VuforiaOrchextra
//
//  Created by Judith Medina on 18/11/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VFConfigurationInteractor;
@protocol ORCActionInterface;

@interface VuforiaOrchextra : NSObject

+ (instancetype)sharedInstance;
- (instancetype)initWithCoreInputInterface:(id<ORCActionInterface>)coreInput
                                interactor:(VFConfigurationInteractor *)interactor;

- (BOOL)isVuforiaEnable;
- (void)startImageRecognition;

@end
