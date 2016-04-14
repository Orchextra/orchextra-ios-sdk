//
//  VuforiaOrchextra.m
//  VuforiaOrchextra
//
//  Created by Judith Medina on 18/11/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "VuforiaOrchextra.h"
#import "VFConfigurationInteractor.h"
#import <Orchextra/Orchextra.h>

@interface VuforiaOrchextra ()

@property (strong, nonatomic) VFConfigurationInteractor *interactor;
@property (strong, nonatomic) id<ORCActionInterface> coreInput;

@end

@implementation VuforiaOrchextra


+ (instancetype)sharedInstance
{
    static VuforiaOrchextra *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VuforiaOrchextra alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    VFConfigurationInteractor *interactor = [[VFConfigurationInteractor alloc] init];
    id<ORCActionInterface> coreInput = [ORCActionManager sharedInstance];
    return [self initWithCoreInputInterface:coreInput interactor:interactor];
}

- (instancetype)initWithCoreInputInterface:(id<ORCActionInterface>)coreInput interactor:(VFConfigurationInteractor *)interactor
{
    self = [super init];
    
    if (self)
    {
        _interactor = interactor;
        _coreInput = coreInput;
    }
    
    return self;
}

- (BOOL)isVuforiaEnable
{
    if ([self.interactor vuforiaCredentials])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)startImageRecognition
{
    ORCAction *vuforiaAction = [[ORCAction alloc] initWithType:ORCActionVuforiaID];
    vuforiaAction.urlString = ORCSchemeImageRecognition;
    [self.coreInput didFireTriggerWithAction:vuforiaAction fromViewController:nil];
}

@end
