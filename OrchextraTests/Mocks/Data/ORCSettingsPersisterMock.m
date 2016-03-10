//
//  ORCSettingsPersisterMock.m
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import "ORCSettingsPersisterMock.h"
#import "ORCUser.h"

@interface ORCSettingsPersisterMock ()


@end

@implementation ORCSettingsPersisterMock

- (void)storeUser:(ORCUser *)user
{
    self.outStoreUserCalled = YES;
}

- (ORCUser *)loadCurrentUser
{
    self.outLoadUserCalled = YES;
    return self.inUser;
}

- (NSString *)loadApiKey
{
    return self.inApiKey;
}

- (NSString *)loadApiSecret
{
    return self.inApiSecret;
}

- (void)storeApiKey:(NSString *)apiKey
{
    self.outStoreApiKey = YES;
}

- (void)storeApiSecret:(NSString *)apiSecret
{
    self.outStoreApiSecret = YES;
}

- (void)storeAcessToken:(NSString *)accessToken
{
    self.outAccessToken = accessToken;
    self.outStoreAccessToken = YES;
}

- (void)storeRequestWaitTime:(NSInteger)requestWaitTime
{
    self.outStoreRequestWaitTime = YES;
}

- (ORCThemeSdk *)loadThemeSdk
{
    return self.inTheme;
}

- (void)storeThemeSdk:(ORCThemeSdk *)theme
{
    self.outStoreThemeSdk = YES;
}

- (ORCVuforiaConfig *)loadVuforiaConfig
{
    self.outLoadVuforiaConfigCalled = YES;
    return self.inVuforiaConfig;
}

- (void)storeVuforiaConfig:(ORCVuforiaConfig *)vuforiaConfig
{
    self.outStoreVuforiaConfig = YES;
}

- (void)storeBackgroundTime:(NSInteger)backgroundTime
{
    self.outBackgroundTime = backgroundTime;
    self.outStoreBackgroundTimeCalled = YES;
}

@end
