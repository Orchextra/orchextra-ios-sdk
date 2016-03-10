//
//  ORCSettingsPersisterMock.h
//  Orchextra
//
//  Created by Judith Medina on 10/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORCSettingsPersister.h"

@interface ORCSettingsPersisterMock : ORCSettingsPersister

@property (strong, nonatomic) NSString *inApiKey;
@property (strong, nonatomic) NSString *inApiSecret;
@property (strong, nonatomic) ORCVuforiaConfig *inVuforiaConfig;
@property (strong, nonatomic) ORCThemeSdk *inTheme;
@property (strong, nonatomic) ORCUser *inUser;

@property (assign, nonatomic) BOOL outStoreUserCalled;
@property (assign, nonatomic) BOOL outLoadUserCalled;
@property (assign, nonatomic) BOOL outLoadVuforiaConfigCalled;
@property (assign, nonatomic) BOOL outStoreAccessToken;
@property (assign, nonatomic) BOOL outStoreApiKey;
@property (assign, nonatomic) BOOL outStoreApiSecret;
@property (assign, nonatomic) BOOL outStoreThemeSdk;
@property (assign, nonatomic) BOOL outStoreRequestWaitTime;
@property (assign, nonatomic) BOOL outStoreVuforiaConfig;
@property (assign, nonatomic) BOOL outStoreBackgroundTimeCalled;

@property (strong, nonatomic) NSString *outAccessToken;
@property (strong, nonatomic) ORCUser *outUser;
@property (assign, nonatomic) NSInteger outBackgroundTime;



- (void)storeAcessToken:(NSString *)accessToken;

@end
