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

#import "ORCBusinessUnit.h"
#import "ORCCustomField.h"
#import "ORCUser.h"
#import "ORCTag.h"
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

- (void)test_store_custom_field_config
{
    //Prepare
    [self givenAnUser];
    
    NSMutableArray<ORCCustomField *> *customFields = [[NSMutableArray alloc] init];
    
    ORCCustomField *customField1 = [[ORCCustomField alloc] initWithKey:@"name"
                                                                    label:@"Nombre"
                                                                     type:ORCCustomFieldTypeString
                                                                    value:nil];
    ORCCustomField *customField2 = [[ORCCustomField alloc] initWithKey:@"surname"
                                                                    label:@"Surname"
                                                                     type:ORCCustomFieldTypeString
                                                                    value:nil];
    ORCCustomField *customField3 = [[ORCCustomField alloc] initWithKey:@"email"
                                                                    label:@"Email"
                                                                     type:ORCCustomFieldTypeString
                                                                    value:nil];
    
    [customFields addObject:customField1];
    [customFields addObject:customField2];
    [customFields addObject:customField3];
    
    //Execute
    [self.settingPersister setCustomFields:customFields];
    
    //Verify
    NSArray <ORCCustomField *> *loadedCustomFields = [self.settingPersister loadCustomFields];
    ORCCustomField *customFieldToBeTest = [loadedCustomFields objectAtIndex:0];
    
    BOOL customFieldEqual = [self givenCustomField:customField1 isEqualTo:customFieldToBeTest];
    XCTAssertTrue(customFieldEqual);
    
    customFieldToBeTest = [loadedCustomFields objectAtIndex:1];
    customFieldEqual = [self givenCustomField:customField2 isEqualTo:customFieldToBeTest];
    XCTAssertTrue(customFieldEqual);
    
    customFieldToBeTest = [loadedCustomFields objectAtIndex:2];
    customFieldEqual = [self givenCustomField:customField3 isEqualTo:customFieldToBeTest];
    XCTAssertTrue(customFieldEqual);
}

- (void)test_update_custom_field_value_valid_key
{
    //Prepare
    [self givenAnUser];
    NSMutableArray<ORCCustomField *> *customFields = [[NSMutableArray alloc] init];
    ORCCustomField *customField = [[ORCCustomField alloc] initWithKey:@"name"
                                                                    label:@"Nombre"
                                                                     type:ORCCustomFieldTypeString
                                                                    value:nil];
    [customFields addObject:customField];
    [self.settingPersister setCustomFields:customFields];
    
    //Execute
    BOOL updatedSuccesfully = [self.settingPersister updateCustomFieldValue:@"Carlos" withKey:@"name"];
    
    //Verify
    NSArray <ORCCustomField *> *loadedCustomFields = [self.settingPersister loadCustomFields];
    ORCCustomField *customFieldModified = [loadedCustomFields objectAtIndex:0];
    BOOL isEqualCustomFieldValue = [@"Carlos" isEqualToString:customFieldModified.value];
    
    XCTAssertTrue(updatedSuccesfully);
    XCTAssertNotNil(customFieldModified.value);
    XCTAssertTrue(isEqualCustomFieldValue);
}

- (void)test_update_custom_field_value_not_valid_key
{
    //Prepare
    NSMutableArray<ORCCustomField *> *customFields = [[NSMutableArray alloc] init];
    ORCCustomField *customField = [[ORCCustomField alloc] initWithKey:@"name"
                                                                label:@"Nombre"
                                                                 type:ORCCustomFieldTypeString
                                                                value:nil];
    [customFields addObject:customField];
    [self.settingPersister setCustomFields:customFields];
    
    //Execute
    BOOL updatedSuccesfully = [self.settingPersister updateCustomFieldValue:@"NoName" withKey:@"key"];
    
    //Verify
    NSArray <ORCCustomField *> *loadedCustomFields = [self.settingPersister loadCustomFields];
    ORCCustomField *customFieldModified = [loadedCustomFields objectAtIndex:0];
    BOOL isEqualCustomFieldValue = [@"NoName" isEqualToString:customFieldModified.value];
    
    XCTAssertFalse(updatedSuccesfully);
    XCTAssertNil(customFieldModified.value);
    XCTAssertFalse(isEqualCustomFieldValue);
}

- (void)test_store_user_tags
{
    //Prepare
    [self givenAnUser];
    NSArray <ORCTag *> *tags = [self givenTags];
    
    //Execute
    [self.settingPersister setUserTags:tags];
    
    //Verify
    NSArray <ORCTag *> *loadedTags = [self.settingPersister loadUserTags];
    
    for (NSUInteger i = 0; i < tags.count; i++)
    {
        ORCTag *tag = [tags objectAtIndex:i];
        ORCTag *loadedTag = [loadedTags objectAtIndex:i];
        
        BOOL tagAreEquals = [self givenTag:tag
                                 isEqualTo:loadedTag];
        
        XCTAssertTrue(tagAreEquals);
    }
    
    XCTAssertNotNil(loadedTags);
    XCTAssertTrue(loadedTags.count == 3);
}

- (void)test_store_device_tags
{
    //Prepare
    NSArray <ORCTag *> *tags = [self givenTags];
    
    //Execute
    [self.settingPersister setDeviceTags:tags];
    
    //Verify
    NSArray <ORCTag *> *loadedDevicetags = [self.settingPersister loadDeviceTags];
    
    for (NSUInteger i = 0; i < tags.count; i++)
    {
        ORCTag *tag = [tags objectAtIndex:i];
        ORCTag *loadedTag = [loadedDevicetags objectAtIndex:i];
        
        BOOL tagAreEquals = [self givenTag:tag
                                 isEqualTo:loadedTag];
        
        XCTAssertTrue(tagAreEquals);
    }

    XCTAssertNotNil(loadedDevicetags);
    XCTAssertTrue(loadedDevicetags.count == 3);
}

- (void)test_store_user_business_units
{
    //Prepare
    [self givenAnUser];
    NSArray <ORCBusinessUnit *> *businessUnits = [self givenBusinessUnits];
    
    //Execute
    [self.settingPersister setUserBusinessUnit:businessUnits];
    
    //Verify
    NSArray <ORCBusinessUnit *> *loadedBusinessUnits = [self.settingPersister loadUserBusinessUnits];
    
    for (NSUInteger i = 0; i < businessUnits.count; i++)
    {
        ORCBusinessUnit *businessUnit = [businessUnits objectAtIndex:i];
        ORCBusinessUnit *loadedBusinessUnit = [loadedBusinessUnits objectAtIndex:i];
        
        BOOL businessUnitsAreEquals = [self givenBusinessUnit:businessUnit
                                                    isEqualTo:loadedBusinessUnit];
        
        XCTAssertTrue(businessUnitsAreEquals);
    }
    
    XCTAssertNotNil(loadedBusinessUnits);
    XCTAssertTrue(loadedBusinessUnits.count == 3);
}

- (void)test_store_device_business_units
{
    //Prepare
    [self givenAnUser];
    NSArray <ORCBusinessUnit *> *businessUnits = [self givenBusinessUnits];
    
    //Execute
    [self.settingPersister setDeviceBusinessUnits:businessUnits];
    
    //Verify
    NSArray <ORCBusinessUnit *> *loadedBusinessUnits = [self.settingPersister loadDeviceBusinessUnits];
    
    for (NSUInteger i = 0; i < businessUnits.count; i++)
    {
        ORCBusinessUnit *businessUnit = [businessUnits objectAtIndex:i];
        ORCBusinessUnit *loadedBusinessUnit = [loadedBusinessUnits objectAtIndex:i];
        
        BOOL businessUnitsAreEquals = [self givenBusinessUnit:businessUnit
                                                    isEqualTo:loadedBusinessUnit];
        
        XCTAssertTrue(businessUnitsAreEquals);
    }
    
    XCTAssertNotNil(loadedBusinessUnits);
    XCTAssertTrue(loadedBusinessUnits.count == 3);
}


#pragma mark - Helper

- (void)givenAnUser
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    ORCUser *userData = [[ORCUser alloc] init];
    userData.crmID = uuid;
    
    [self.settingPersister storeUser:userData];
}

- (BOOL)givenCustomField:(ORCCustomField *)customField isEqualTo:(ORCCustomField *)customFieldToBeTest
{
    BOOL result = NO;
    
    BOOL isEqualKey = [customField.key isEqualToString:customFieldToBeTest.key];
    BOOL isEqualName = [customField.label isEqualToString:customFieldToBeTest.label];
    BOOL isEqualType = customField.type == customFieldToBeTest.type;
    BOOL isEqualValue = customField.value == customFieldToBeTest.value;

    if (isEqualKey  &&
        isEqualName &&
        isEqualType &&
        isEqualValue)
    {
        result = YES;
    }
    
    return result;
}

- (BOOL)givenTag:(ORCTag *)tag isEqualTo:(ORCTag *)tagToBeTest
{
    NSString *tagFormatted = [tag tag];
    NSString *tagToBeTestFormatted = [tagToBeTest tag];
    
    return [tagFormatted isEqualToString:tagToBeTestFormatted];
}

- (BOOL)givenBusinessUnit:(ORCBusinessUnit *)businessUnit isEqualTo:(ORCBusinessUnit *)businessUnitToBeTest
{
    NSString *businessUnitName = [businessUnit name];
    NSString *businessUnitToBeTestName = [businessUnitToBeTest name];
    
    return [businessUnitName isEqualToString:businessUnitToBeTestName];
}

- (NSArray <ORCTag *> *)givenTags
{
    NSMutableArray <ORCTag *> *tags = [[NSMutableArray alloc] init];
    
    ORCTag *tag1 = [[ORCTag alloc] initWithPrefix:@"color" name:@"green"];
    ORCTag *tag2 = [[ORCTag alloc] initWithPrefix:@"color" name:@"yellow"];
    ORCTag *tag3 = [[ORCTag alloc] initWithPrefix:@"color"];
    
    [tags addObject:tag1];
    [tags addObject:tag2];
    [tags addObject:tag3];
    
    return tags;
}

- (NSArray <ORCBusinessUnit *> *)givenBusinessUnits {

    NSMutableArray <ORCBusinessUnit *> *businessUnits = [[NSMutableArray alloc] init];
    
    ORCBusinessUnit *businessUnit1 = [[ORCBusinessUnit alloc] initWithName:@"renault"];
    ORCBusinessUnit *businessUnit2 = [[ORCBusinessUnit alloc] initWithName:@"bmw"];
    ORCBusinessUnit *businessUnit3 = [[ORCBusinessUnit alloc] initWithName:@"brand"];
    
    [businessUnits addObject:businessUnit1];
    [businessUnits addObject:businessUnit2];
    [businessUnits addObject:businessUnit3];
    
    return businessUnits;
}

@end
