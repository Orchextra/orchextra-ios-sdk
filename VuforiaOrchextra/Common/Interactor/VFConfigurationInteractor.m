//
//  VFConfigurationInteractor.m
//  Orchextra
//
//  Created by Judith Medina on 18/11/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import "VFConfigurationInteractor.h"
#import <Orchextra/Orchextra.h>


@interface VFConfigurationInteractor ()

@property (strong, nonatomic) id<OrchextraOutputInterface> coreOutput;
@property (strong, nonatomic) ORCVuforiaConfig *config;

@end

@implementation VFConfigurationInteractor

#pragma mark - INIT

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _coreOutput = [[ORCData alloc] init];
    }
    
    return self;
}


#pragma mark - PUBLIC 

- (NSString *)vuforiaLicense
{
    return [[self.coreOutput fetchVuforiaCredentials] licenseKey];
}

- (ORCVuforiaConfig *)vuforiaCredentials
{
    return [self.coreOutput fetchVuforiaCredentials];
}

- (ORCThemeSdk *)themeSDK
{
    return [self.coreOutput fetchThemeSdk];
}

@end
