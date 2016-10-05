//
//  ORCConfigurationInteractorTests.m
//  Orchextra
//
//  Created by Judith Medina on 2/12/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ORCSettingsInteractor.h"

#import "ORCUserLocationPersisterMock.h"
#import "ORCSettingsPersisterMock.h"
#import "ORCAppConfigCommunicatorMock.h"
#import "ORCFormatterParametersMock.h"

#import "ORCAppConfigResponse.h"
#import "ORCBusinessUnit.h"
#import "ORCCustomField.h"
#import "ORCUser.h"
#import "ORCTag.h"

@interface ORCSettingsInteractorTests : XCTestCase

@property (strong, nonatomic) ORCSettingsPersisterMock *settingsPersisterMock;
@property (strong, nonatomic) ORCUserLocationPersisterMock *userLocationPersisterMock;
@property (strong, nonatomic) ORCAppConfigCommunicatorMock *communicatorMock;

@property (strong, nonatomic) ORCFormatterParametersMock *formatterMock;
@property (strong, nonatomic) ORCSettingsInteractor *settingsInteractor;
@property (strong, nonatomic) NSBundle *testBundle;

@end

@implementation ORCSettingsInteractorTests

- (void)setUp
{
    [super setUp];
    
    self.settingsPersisterMock      = [[ORCSettingsPersisterMock alloc] init];
    self.userLocationPersisterMock  = [[ORCUserLocationPersisterMock alloc] init];
    self.communicatorMock           = [[ORCAppConfigCommunicatorMock alloc] init];
    self.formatterMock              = [[ORCFormatterParametersMock alloc] init];
    
    self.settingsInteractor = [[ORCSettingsInteractor alloc]
                               initWithSettingsPersister:self.settingsPersisterMock
                               userLocationPersister:self.userLocationPersisterMock
                               communicator:self.communicatorMock
                               formatter:self.formatterMock];
    
    self.testBundle = [NSBundle bundleForClass:self.class];
}

- (void)tearDown
{
    [super tearDown];
    
    self.settingsPersisterMock = nil;
    self.userLocationPersisterMock = nil;
    self.communicatorMock = nil;
    self.formatterMock = nil;
    self.testBundle = nil;
}

- (void)test_load_apiKey_apiSecret_first_time_success
{
    // Prepare
    
    NSString *apiKey = @"key";
    NSString *apiSecret = @"secret";
    
    self.settingsPersisterMock.inApiKey = nil;
    self.settingsPersisterMock.inApiSecret = nil;
    
    NSString *path = [self.testBundle pathForResource:@"POST_configuration" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    self.communicatorMock.inAppConfigResponse = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    
    // Execute
    
    __block BOOL closureCalled = NO;
    [self.settingsInteractor loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:^(BOOL success, NSError *error) {
        
        // Verify
        closureCalled = YES;
        XCTAssertTrue(self.settingsPersisterMock.outStoreAccessToken);
        XCTAssertTrue(self.settingsPersisterMock.outStoreApiKey);
        XCTAssertTrue(self.settingsPersisterMock.outStoreApiSecret);
        XCTAssertTrue(self.communicatorMock.outLoadCustomConfiguration);
        
        XCTAssertTrue(success);
        XCTAssertNil(error);
        
    }];
    
    XCTAssertTrue(closureCalled);
    
}

- (void)test_loadProjectWithApiKey_same_apiKey_apiSecret_success
{
    // Prepare
    
    NSString *apiKey = @"key";
    NSString *apiSecret = @"secret";
    
    self.settingsPersisterMock.inApiKey = @"key";
    self.settingsPersisterMock.inApiSecret = @"secret";
    
    NSString *path = [self.testBundle pathForResource:@"POST_Configuration_Complex" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    self.communicatorMock.inAppConfigResponse = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    
    // Execute
    
    __block BOOL closureCalled = NO;
    [self.settingsInteractor loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:^(BOOL success, NSError *error) {
        
        // Verify
        closureCalled = YES;
        XCTAssertFalse(self.settingsPersisterMock.outStoreAccessToken);
        XCTAssertFalse(self.settingsPersisterMock.outStoreApiKey);
        XCTAssertFalse(self.settingsPersisterMock.outStoreApiSecret);
        
        XCTAssertTrue(self.communicatorMock.outLoadCustomConfiguration);
        
        XCTAssertTrue(success);
        XCTAssertNil(error);
    }];
    
    XCTAssertTrue(closureCalled);
}

- (void)test_loadProjectWithApiKey_returnFailure_whereApikeyAndSecretAreIncorrect
{
    // Prepare
    
    NSString *apiKey = @"key";
    NSString *apiSecret = @"secret";
    
    NSString *path = [self.testBundle pathForResource:@"POST_configuration_failure" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    self.communicatorMock.inAppConfigResponse = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    
    // Execute
    
    __block BOOL closureCalled = NO;
    [self.settingsInteractor loadProjectWithApiKey:apiKey apiSecret:apiSecret completion:^(BOOL success, NSError *error) {
        
        // Verify
        closureCalled = YES;
        XCTAssertTrue(self.settingsPersisterMock.outStoreAccessToken);
        XCTAssertTrue(self.settingsPersisterMock.outStoreApiKey);
        XCTAssertTrue(self.settingsPersisterMock.outStoreApiSecret);
        
        XCTAssertTrue(self.communicatorMock.outLoadCustomConfiguration);
        
        XCTAssertFalse(success);
        XCTAssertNotNil(error);
        
    }];
    
    XCTAssertTrue(closureCalled);
    
}

- (void)test_current_user_empty
{
    // Prepare
    self.settingsPersisterMock.inUser = nil;
    
    // Execute
    ORCUser *user = [self.settingsInteractor currentUser];
    
    // Verify
    XCTAssertNotNil(user);
    XCTAssertNil(user.crmID);
    XCTAssertNil(user.birthday);
    XCTAssertNil(user.deviceToken);
    XCTAssertNil(user.tags);
    XCTAssert(user.gender == ORCGenderNone);
    
}

- (void)test_current_user_not_empty
{
    // Prepare
    ORCUser *userExample = [[ORCUser alloc] init];
    userExample.birthday = [NSDate date];
    userExample.gender = ORCGenderMale;
    userExample.deviceToken = @"123456789";
    userExample.tags = @[@"mobile"];
    
    self.settingsPersisterMock.inUser = userExample;
    
    // Execute
    ORCUser *user = [self.settingsInteractor currentUser];
    
    // Verify
    XCTAssert([user.birthday isEqualToDate:userExample.birthday]);
    XCTAssert(user.gender == userExample.gender);
    XCTAssert([user.deviceToken isEqualToString:userExample.deviceToken]);
    XCTAssert([user.tags isEqualToArray:userExample.tags]);
    
}

- (void)test_save_user_with_previous_user_db
{
    // Prepare
    ORCUser *userDB = [[ORCUser alloc] init];
    userDB.birthday = [NSDate date];
    userDB.gender = ORCGenderMale;
    userDB.deviceToken = @"123456789";
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"mobile"];
    userDB.tags = @[tag];
    self.settingsPersisterMock.inUser = userDB;
    
    ORCUser *newUserDB = [[ORCUser alloc] init];
    newUserDB.birthday = [NSDate date];
    newUserDB.gender = ORCGenderFemale;
    newUserDB.deviceToken = @"987456321";
    ORCTag *tagUserDB = [[ORCTag alloc] initWithPrefix:@"spain"];
    newUserDB.tags = @[tagUserDB];
    
    [self.settingsPersisterMock storeOrchextraState:YES];
    
    // Execute
    [self.settingsInteractor saveUser:newUserDB];
    
    // Verify
    XCTAssertTrue(self.communicatorMock.outLoadCustomConfiguration);
}

- (void)test_save_same_user_previously_store_db
{
    // Prepare
    ORCUser *userDB = [[ORCUser alloc] init];
    userDB.birthday = [NSDate dateWithTimeIntervalSince1970:100];
    userDB.gender = ORCGenderMale;
    userDB.deviceToken = @"123456789";
    userDB.tags = @[@"mobile"];
    self.settingsPersisterMock.inUser = userDB;
    
    // Execute
    [self.settingsInteractor saveUser:userDB];
    
    // Verify
    XCTAssertFalse(self.communicatorMock.outLoadCustomConfiguration);
}

- (void)test_save_empty_user
{
    // Prepare
    ORCUser *userDB = [[ORCUser alloc] init];
    userDB.birthday = [NSDate dateWithTimeIntervalSince1970:100];
    userDB.gender = ORCGenderMale;
    userDB.deviceToken = @"123456789";
    ORCTag *tagUserDB = [[ORCTag alloc] initWithPrefix:@"spain"];
    userDB.tags = @[tagUserDB];
    self.settingsPersisterMock.inUser = userDB;
    
    // Execute
    [self.settingsInteractor saveUser:nil];
    
    // Verify
    XCTAssertFalse(self.communicatorMock.outLoadCustomConfiguration);
}

- (void)test_saveUser_response_success
{
    // Prepare
    self.settingsPersisterMock.inUser = nil;
    
    ORCUser *user = [[ORCUser alloc] init];
    user.birthday = [NSDate date];
    user.gender = ORCGenderMale;
    user.deviceToken = @"123456789";
    ORCTag *tagUserDB = [[ORCTag alloc] initWithPrefix:@"mobile"];
    user.tags = @[tagUserDB];
    
    
    NSString *path = [self.testBundle pathForResource:@"POST_configuration" ofType:@"json"];
    NSData *dataResponse = [NSData dataWithContentsOfFile:path];
    self.communicatorMock.inAppConfigResponse = [[ORCAppConfigResponse alloc] initWithData:dataResponse];
    
    [self.settingsPersisterMock storeOrchextraState:YES];
    
    // Execute
    [self.settingsInteractor saveUser:user];
    
    // Verify
    XCTAssertTrue(self.communicatorMock.outLoadCustomConfiguration);
    XCTAssertTrue(self.settingsPersisterMock.outStoreVuforiaConfig);
    XCTAssertTrue(self.settingsPersisterMock.outStoreThemeSdk);
    XCTAssertTrue(self.settingsPersisterMock.outStoreRequestWaitTime);
}

- (void)test_saveUser_returnAccessTokenNil_whenCRMIDChanged
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    user.crmID = @"crmid";
    self.settingsPersisterMock.inUser = user;
    [self.settingsPersisterMock storeAcessToken:@"accessToken"];
    
    ORCUser *newUser = [[ORCUser alloc] init];
    newUser.crmID = @"crmid_changed";
    
    // Execute
    [self.settingsInteractor saveUser:newUser];
    
    XCTAssertTrue(self.settingsPersisterMock.outStoreAccessToken);
    XCTAssertNil(self.settingsPersisterMock.outAccessToken);
}

- (void)test_saveUser_returnSameAccessToken_whenCRMIDisSame
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    user.crmID = @"crmid";
    self.settingsPersisterMock.inUser = user;
    [self.settingsPersisterMock storeAcessToken:@"accessToken"];
    
    ORCUser *newUser = [[ORCUser alloc] init];
    newUser.crmID = @"crmid";
    
    // Execute
    [self.settingsInteractor saveUser:user];
    
    XCTAssertTrue(self.settingsPersisterMock.outStoreAccessToken);
    XCTAssertNotNil(self.settingsPersisterMock.outAccessToken);
    XCTAssert([self.settingsPersisterMock.outAccessToken isEqualToString:@"accessToken"]);
    
}

- (void)test_set_custom_fields_without_crm_id
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    self.settingsPersisterMock.inUser = user;
    
    ORCCustomField *customField = [[ORCCustomField alloc] initWithKey:@"name"
                                                                label:@"Name"
                                                                 type:ORCCustomFieldTypeString
                                                                value:@"Carlos"];
    
    NSArray <ORCCustomField *> *customFields = [NSArray arrayWithObject:customField];
    
    // Execute
    [self.settingsInteractor saveCustomFields:customFields];
    
    user = [self.settingsPersisterMock loadCurrentUser];
    
    XCTAssertNil(user.customFields);
    XCTAssertTrue(user.customFields.count == 0);
    
}

- (void)test_set_custom_fields_with_valid_crm_id
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    user.crmID = @"userId";
    self.settingsPersisterMock.inUser = user;
    
    ORCCustomField *customField = [[ORCCustomField alloc] initWithKey:@"name"
                                                                label:@"Name"
                                                                 type:ORCCustomFieldTypeString
                                                                value:@"Carlos"];
    
    NSArray <ORCCustomField *> *customFields = [NSArray arrayWithObject:customField];
    
    // Execute
    [self.settingsInteractor saveCustomFields:customFields];
    
    // Verify
    user = [self.settingsPersisterMock loadCurrentUser];
    
    XCTAssertNotNil(user.customFields);
    XCTAssertTrue(user.customFields.count == 1);
    
}

- (void)test_set_tags_without_crm_id
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    self.settingsPersisterMock.inUser = user;
    
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color"
                                            name:@"yellow"];
    
    NSArray <ORCTag *> *tags = [NSArray arrayWithObject:tag];
    
    // Execute
    [self.settingsInteractor saveUserTags:tags];
    
    // Verify
    user = [self.settingsPersisterMock loadCurrentUser];
    
    XCTAssertNil(user.tags);
    XCTAssertTrue(user.tags.count == 0);
    
}

- (void)test_set_tags_with_valid_crm_id
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    user.crmID = @"userId";
    self.settingsPersisterMock.inUser = user;
    
    ORCTag *tag = [[ORCTag alloc] initWithPrefix:@"color"
                                            name:@"yellow"];
    
    NSArray <ORCTag *> *tags = [NSArray arrayWithObject:tag];
    
    // Execute
    [self.settingsInteractor saveUserTags:tags];
    
    // Verify
    user = [self.settingsPersisterMock loadCurrentUser];
    
    ORCTag *loadedTag = [user.tags objectAtIndex:0];
    NSString *tagFormatted = [tag tag];
    NSString *loadedTagFormatted = [loadedTag tag];
    
    XCTAssertNotNil(user.tags);
    XCTAssertTrue(user.tags.count == 1);
    XCTAssertTrue([tagFormatted isEqualToString:loadedTagFormatted]);
}

- (void)test_set_business_units_without_crm_id
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    self.settingsPersisterMock.inUser = user;
    
    ORCBusinessUnit *businessUnit = [[ORCBusinessUnit alloc] initWithPrefix:@"brand"
                                                                       name:@"bmw"];
    
    NSArray <ORCBusinessUnit *> *businessUnits = [NSArray arrayWithObject:businessUnit];
    
    // Execute
    [self.settingsInteractor saveUserBusinessUnits:businessUnits];
    
    // Verify
    user = [self.settingsPersisterMock loadCurrentUser];
    
    XCTAssertNil(user.businessUnits);
    XCTAssertTrue(user.businessUnits.count == 0);
    
}

- (void)test_set_business_units_with_valid_crm_id
{
    // Prepare
    ORCUser *user = [[ORCUser alloc] init];
    user.crmID = @"userId";
    self.settingsPersisterMock.inUser = user;
    
    ORCBusinessUnit *businessUnit = [[ORCBusinessUnit alloc] initWithPrefix:@"brand"
                                                                       name:@"bmw"];
    
    NSArray <ORCBusinessUnit *> *businessUnits = [NSArray arrayWithObject:businessUnit];
    
    // Execute
    [self.settingsInteractor saveUserBusinessUnits:businessUnits];
    
    // Verify
    user = [self.settingsPersisterMock loadCurrentUser];
    
    ORCBusinessUnit *loadedBusinessUnit = [user.businessUnits objectAtIndex:0];
    NSString *businessUnitFormatted = [businessUnit tag];
    NSString *loadedBusinessUnitFormatted = [loadedBusinessUnit tag];
    
    XCTAssertNotNil(user.businessUnits);
    XCTAssertTrue(user.businessUnits.count == 1);
    XCTAssertTrue([businessUnitFormatted isEqualToString:loadedBusinessUnitFormatted]);
}

@end
