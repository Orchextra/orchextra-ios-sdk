//
//  ORCSettingsDataManagerTests.m
//  Orchextra
//
//  Created by Judith Medina on 15/2/16.
//  Copyright © 2016 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ORCSettingsDataManager.h"
#import "ORCSettingsPersisterMock.h"
#import "ORCUserLocationPersisterMock.h"

#import "ORCVuforiaConfig.h"
#import "ORCThemeSdk.h"


@interface ORCSettingsDataManagerTests : XCTestCase

@property (strong, nonatomic) ORCSettingsDataManager *settingsDataManager;
@property (strong, nonatomic) ORCSettingsPersisterMock *settingsPersisterMock;
@property (strong, nonatomic) ORCUserLocationPersisterMock *userLocationPersisterMock;

@end

@implementation ORCSettingsDataManagerTests

- (void)setUp
{
    [super setUp];
    
    self.settingsPersisterMock = [[ORCSettingsPersisterMock alloc] init];
    self.userLocationPersisterMock = [[ORCUserLocationPersisterMock alloc] init];
    self.settingsDataManager = [[ORCSettingsDataManager alloc] initWithSettingsPersister:self.settingsPersisterMock
                                                                   userLocationPersister:self.userLocationPersisterMock];
}

- (void)tearDown
{
    [super tearDown];
    self.settingsPersisterMock = nil;
    self.userLocationPersisterMock = nil;
    self.settingsDataManager = nil;
}

- (void)test_fetchVuforiaCredentials_ReturnValues
{
    ORCVuforiaConfig *vuforiaConfig = [[ORCVuforiaConfig alloc] init];
    vuforiaConfig.licenseKey = @"licenseVuforia";
    vuforiaConfig.accessKey = @"accessKeyVuforia";
    vuforiaConfig.secretKey = @"secretKeyVuforia";
    
    self.settingsPersisterMock.inVuforiaConfig = vuforiaConfig;
    
    ORCVuforiaConfig *vuforiaConfigStored = [self.settingsDataManager fetchVuforiaCredentials];
    
    XCTAssertTrue([vuforiaConfigStored.licenseKey isEqualToString:@"licenseVuforia"]);
    XCTAssertTrue([vuforiaConfigStored.accessKey isEqualToString:@"accessKeyVuforia"]);
    XCTAssertTrue([vuforiaConfigStored.secretKey isEqualToString:@"secretKeyVuforia"]);
}

- (void)test_fetchThemeSdk_ReturnTheme
{
    ORCThemeSdk *theme = [[ORCThemeSdk alloc] init];
    theme.primaryColor = [UIColor blackColor];
    theme.secondaryColor = [UIColor whiteColor];
    
    self.settingsPersisterMock.inTheme = theme;
    
    ORCThemeSdk *themeStored = [self.settingsDataManager fetchThemeSdk];
    
    XCTAssertTrue([themeStored.primaryColor isEqual:[UIColor blackColor]]);
    XCTAssertTrue([themeStored.secondaryColor isEqual:[UIColor whiteColor]]);
}

- (void)test_extendBackgroundTime_returnTrue_whenBackgroundTimeLessThan180AndBiggerThan10
{
    //Arrange
    BOOL extendedBackgroundTime = NO;
    NSInteger backgroundTime = 20;
    
    //Assert
    extendedBackgroundTime = [self.settingsDataManager extendBackgroundTime:backgroundTime];
    
    //Act
    XCTAssertTrue(extendedBackgroundTime);
    XCTAssert(self.settingsPersisterMock.outBackgroundTime = 20);
}

- (void)test_extendBackgroundTime_returnFalse_whenBackgroundTimeBiggerThan180
{
    //Arrange
    BOOL extendedBackgroundTime = NO;
    NSInteger backgroundTime = 190;
    
    //Assert
    extendedBackgroundTime = [self.settingsDataManager extendBackgroundTime:backgroundTime];
    
    //Act
    XCTAssertFalse(extendedBackgroundTime);
    XCTAssert(self.settingsPersisterMock.outBackgroundTime = 10);
}

- (void)test_extendBackgroundTime_returnFalseAndDefaultValue_whenBackgroundTimeLesThanDefaultValue
{
    //Arrange
    BOOL extendedBackgroundTime = NO;
    NSInteger backgroundTime = 5;
    
    //Assert
    extendedBackgroundTime = [self.settingsDataManager extendBackgroundTime:backgroundTime];
    
    //Act
    XCTAssertFalse(extendedBackgroundTime);
    XCTAssert(self.settingsPersisterMock.outBackgroundTime = 10);
    
}

@end
