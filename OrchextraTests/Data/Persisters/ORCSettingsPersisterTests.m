//
//  ORCDeviceInfo.m
//  Orchestra
//
//  Created by Judith Medina on 26/5/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCSettingsPersister.h"
#import "ORCUserLocationPersisterMock.h"
#import "ORCAppConfigCommunicator.h"

#import "ORCUser.h"
#import "ORCThemeSdk.h"
#import "ORCVuforiaConfig.h"


@interface ORCSettingsPersisterTests : XCTestCase

@property (strong, nonatomic) ORCSettingsPersister *settingPersister;
@property (strong, nonatomic) ORCUserLocationPersisterMock *userLocationPersisterMock;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation ORCSettingsPersisterTests

- (void)setUp
{
    [super setUp];
    
    self.userLocationPersisterMock = [[ORCUserLocationPersisterMock alloc] init];
    self.userDefaults = [[NSUserDefaults alloc] init];
    self.settingPersister = [[ORCSettingsPersister alloc]
                             initWithUserDefaults:self.userDefaults];
}

- (void)tearDown
{
    [super tearDown];
    
    self.settingPersister = nil;
    self.userLocationPersisterMock = nil;
    self.userDefaults = nil;
}

- (void)test_store_apikey
{
    //Prepare
    NSString *apikey = @"key";
    
    //Execute
    [self.settingPersister storeApiKey:apikey];
    
    //Verify
     NSString *apikeyStored = [self.settingPersister loadApiKey];
    XCTAssertTrue([apikey isEqualToString:apikeyStored]);
}

- (void)test_store_apikey_nil
{
    //Execute
    [self.settingPersister storeApiKey:nil];
    
    //Verify
    NSString *apikeyStored = [self.settingPersister loadApiKey];
    XCTAssertNil(apikeyStored);
}

- (void)test_store_apiSecret
{
    //Prepare
    NSString *apiSecret = @"secret";
    
    //Execute
    [self.settingPersister storeApiSecret:apiSecret];
    
    //Verify
    NSString *apiSecretStored = [self.settingPersister loadApiSecret];
    XCTAssertTrue([apiSecret isEqualToString:apiSecretStored]);
}

- (void)test_store_apiSecret_nil
{
    //Execute
    [self.settingPersister storeApiSecret:nil];
    
    //Verify
    NSString *apiSecretStored = [self.settingPersister loadApiSecret];
    XCTAssertNil(apiSecretStored);
}

- (void)test_store_user
{
    //Prepare
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSDate *birth = [NSDate date];
    
    ORCUser *userData = [[ORCUser alloc] init];
    userData.crmID = uuid;
    userData.birthday = birth;
    userData.gender = ORCGenderMale;
    userData.tags = @[@"Spain", @"Fashion"];
    
    //Execute
    [self.settingPersister storeUser:userData];
    
    // Verify
    ORCUser *retrieveUser = [self.settingPersister loadCurrentUser];
    XCTAssertNotNil(retrieveUser);
    XCTAssertTrue([retrieveUser isSameUser:userData]);
}

- (void)test_store_userData_nil
{
    ORCUser *userData = nil;
    [self.settingPersister storeUser:userData];
    
    ORCUser *retrieveUser = [self.settingPersister loadCurrentUser];
    XCTAssertNil(retrieveUser);
}

- (void)test_background_time
{
    //Prepare
    NSInteger backgroundTime = 20;
    
    //Execute
    [self.settingPersister storeBackgroundTime:backgroundTime];
    
    //Verify
    NSInteger backgroundTimeStored = [self.settingPersister loadBackgroundTime];
    XCTAssert(backgroundTime == backgroundTimeStored);
}

- (void)test_background_time_default
{
    //Prepare
    NSInteger backgroundTime = 5;
    
    //Execute
    [self.settingPersister storeBackgroundTime:backgroundTime];
    
    //Verify
    NSInteger backgroundTimeStored = [self.settingPersister loadBackgroundTime];
    XCTAssert(backgroundTimeStored == 10);
}

- (void)test_store_theme_sdk
{
    //Prepare
    UIColor *primaryColor = [UIColor blueColor];
    UIColor *secondaryColor = [UIColor whiteColor];
    
    ORCThemeSdk *theme = [[ORCThemeSdk alloc] init];
    theme.primaryColor = primaryColor;
    theme.secondaryColor = secondaryColor;
    
    //Execute
    [self.settingPersister storeThemeSdk:theme];
    
    //Verify
    ORCThemeSdk *themeStored = [self.settingPersister loadThemeSdk];

    XCTAssert([theme.primaryColor isEqual:themeStored.primaryColor]);
    XCTAssert([theme.secondaryColor isEqual:themeStored.secondaryColor]);
}

- (void)test_request_wait_time
{
    //Prepare
    NSInteger requestWaitTime = 120;
    
    //Execute
    [self.settingPersister storeRequestWaitTime:requestWaitTime];
    
    //Verify
    NSInteger requestWaitTimeStored = [self.settingPersister loadRequestWaitTime];
    XCTAssert(requestWaitTimeStored == requestWaitTime);
}

- (void)test_store_vuforia_config
{
    //Prepare
    NSString *license = @"license";
    NSString *accessKey = @"accessKey";
    NSString *secretKey = @"secretKey";

    ORCVuforiaConfig *vuforia = [[ORCVuforiaConfig alloc] init];
    vuforia.licenseKey = license;
    vuforia.accessKey = accessKey;
    vuforia.secretKey = secretKey;
    
    //Execute
    [self.settingPersister storeVuforiaConfig:vuforia];
    
    //Verify
    ORCVuforiaConfig *vuforiaStored = [self.settingPersister loadVuforiaConfig];
    
    XCTAssert([vuforia.licenseKey isEqualToString:vuforiaStored.licenseKey]);
    XCTAssert([vuforia.accessKey isEqualToString:vuforiaStored.accessKey]);
    XCTAssert([vuforia.secretKey isEqualToString:vuforiaStored.secretKey]);

}

@end
