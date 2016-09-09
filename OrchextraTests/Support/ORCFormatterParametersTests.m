//
//  ORCDeviceStorageTests.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ORCCustomField.h"
#import "ORCFormatterParameters.h"
#import "ORCUserLocationPersisterMock.h"
#import "ORCSettingsPersisterMock.h"
#import "ORCBusinessUnit.h"
#import "ORCDevice.h"
#import "ORCUser.h"
#import "ORCTag.h"

@interface ORCFormatterParametersTests : XCTestCase

@property (strong, nonatomic) ORCFormatterParameters *formatter;
@property (strong, nonatomic) ORCUserLocationPersisterMock *userLocationPersisterMock;
@property (strong, nonatomic) ORCSettingsPersisterMock *settingsPersisterMock;
@property (strong, nonatomic) ORCDevice *deviceMock;
@property (strong, nonatomic) ORCUser *user;

@end

@implementation ORCFormatterParametersTests

- (void)setUp
{
    [super setUp];
    
    self.userLocationPersisterMock = [[ORCUserLocationPersisterMock alloc] init];
    self.settingsPersisterMock = [[ORCSettingsPersisterMock alloc] init];
    
    self.deviceMock = [[ORCDevice alloc] init];
    self.deviceMock.advertisingID = @"advertisingID";
    self.deviceMock.vendorID = @"vendorID";
    self.deviceMock.versionIOS = @"9.0.0";
    self.deviceMock.deviceOS = @"iOS";
    self.deviceMock.handset = @"Iphone";
    self.deviceMock.language = @"en_EN";
    self.deviceMock.bundleId = @"com.gigigo.Orchextra";
    self.deviceMock.appVersion = @"1.0.0";
    self.deviceMock.buildVersion = @"2.0.0";
    self.deviceMock.timeZone = @"Madrid/Europe";
    
    
    self.user = [[ORCUser alloc] init];
    self.user.deviceToken = @"123456789";
    self.user.birthday = [NSDate dateWithTimeIntervalSince1970:100];
    self.user.gender = ORCGenderMale;
    self.user.crmID = @"crmid";
    
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobile"];
    self.user.tags = @[tagMobile];
    
    
    self.formatter = [[ORCFormatterParameters alloc] initWithDevice:self.deviceMock
                                              userLocationPersister:self.userLocationPersisterMock
                                                  settingsPersister:self.settingsPersisterMock];
}

- (void)tearDown
{
    [super tearDown];
    
    self.formatter = nil;
    self.settingsPersisterMock = nil;
    self.deviceMock = nil;
    self.userLocationPersisterMock = nil;
    
}

- (void)test_formatter_parameters_device
{
    //Prepare
    self.settingsPersisterMock.inUser = self.user;
    
    NSDictionary *dictionary = [self.formatter formatterParameteresDevice];
    XCTAssertNotNil(dictionary);
    XCTAssertTrue(dictionary[@"device"]);
    
    NSDictionary *device = dictionary[@"device"];
    XCTAssertTrue([device[@"advertiserId"] isEqualToString:@"advertisingID"]);
    XCTAssertTrue([device[@"osVersion"] isEqualToString:@"9.0.0"]);
    XCTAssertTrue([device[@"handset"] isEqualToString:@"Iphone"]);
    XCTAssertTrue([device[@"languaje"] isEqualToString:@"en_EN"]);
    XCTAssertTrue([device[@"os"] isEqualToString:@"iOS"]);
    XCTAssertTrue([device[@"timeZone"] isEqualToString:@"Madrid/Europe"]);
    XCTAssertTrue([device[@"vendorId"] isEqualToString:@"vendorID"]);
    
    NSDictionary *app = dictionary[@"app"];
    XCTAssertNotNil(app);
    XCTAssertTrue([app[@"appVersion"] isEqualToString:@"1.0.0"]);
    XCTAssertTrue([app[@"buildVersion"] isEqualToString:@"2.0.0"]);
    XCTAssertTrue([app[@"bundleId"] isEqualToString:@"com.gigigo.Orchextra"]);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    XCTAssertTrue([crm[@"crmId"] isEqualToString:@"crmid"]);
    XCTAssertTrue([crm[@"birthDate"] isEqualToString:@"1970-01-01"]);
    XCTAssertTrue([crm[@"tags"] isEqualToArray:@[@"mobile"]]);
    XCTAssertTrue([crm[@"gender"] isEqualToString:@"m"]);
    
    NSDictionary *notificationPush = dictionary[@"notificationPush"];
    XCTAssertNotNil(notificationPush);
    XCTAssertTrue([notificationPush[@"token"] isEqualToString:@"123456789"]);
}

- (void)test_formatterUser_whenDeviceToken
{
    ORCUser *userWithToken = [[ORCUser alloc] init];
    userWithToken.deviceToken = @"123456789";
    self.settingsPersisterMock.inUser = userWithToken;
    
    NSDictionary *dictionary = [self.formatter formatterParameteresDevice];
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNil(crm);
    
    NSDictionary *notificationPush = dictionary[@"notificationPush"];
    XCTAssertNotNil(notificationPush);
}

- (void)test_formatterUser_whenUserNil
{
    self.settingsPersisterMock.inUser = nil;
    
    NSDictionary *dictionary = [self.formatter formatterParameteresDevice];
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNil(crm);
}

- (void)test_formatter_user_location
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.415055 longitude:-3.685271];
    
    NSDictionary *dictionary = [self.formatter formattedUserLocation:location];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *point = dictionary[@"point"];
    XCTAssertNotNil(point);
    
    XCTAssertTrue([point[@"lat"] isEqualToNumber:[NSNumber numberWithDouble:40.415055]]);
    XCTAssertTrue([point[@"lng"] isEqualToNumber:[NSNumber numberWithDouble:-3.685271]]);
}

- (void)test_formatterUserValues_withPrefix
{
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobile"];
    self.user.tags = @[tagMobile];
    
    NSDictionary *dictionary = [self.formatter formattedUserData:self.user];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    
    XCTAssert([crm[@"tags"] isEqualToArray:@[@"mobile"]]);
}

- (void)test_formatterUserValues_withPrefixAndName
{
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobile" name:@"iPhone"];
    self.user.tags = @[tagMobile];
    
    NSDictionary *dictionary = [self.formatter formattedUserData:self.user];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    
    XCTAssert([crm[@"tags"] isEqualToArray:@[@"mobile::iPhone"]]);
}

- (void)test_formatterUserValues_twoValidTags
{
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobile" name:@"iPhone"];
    ORCTag *tagCountry = [[ORCTag alloc] initWithPrefix:@"country" name:@"Spain"];
    
    self.user.tags = @[tagMobile, tagCountry];
    
    NSDictionary *dictionary = [self.formatter formattedUserData:self.user];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    
    NSArray *tags = crm[@"tags"];
    XCTAssert([tags[0] isEqualToString:@"mobile::iPhone"]);
    XCTAssert([tags[1] isEqualToString:@"country::Spain"]);
}

- (void)test_formatterUserValues_oneTagValid_oneTagInvalid
{
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobile" name:@"iPhone"];
    ORCTag *tagCountry = [[ORCTag alloc] initWithPrefix:@"country" name:@"_Spain"];
    
    self.user.tags = @[tagMobile, tagCountry];
    
    NSDictionary *dictionary = [self.formatter formattedUserData:self.user];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    
    NSArray *tags = crm[@"tags"];
    XCTAssert(tags.count == 1);
    XCTAssert([tags[0] isEqualToString:@"mobile::iPhone"]);
}

- (void)test_formatterUserValues_twoInvalid
{
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobi/le" name:@"iPhone"];
    ORCTag *tagCountry = [[ORCTag alloc] initWithPrefix:@"country" name:@"_Spain"];
    
    self.user.tags = @[tagMobile, tagCountry];
    
    NSDictionary *dictionary = [self.formatter formattedUserData:self.user];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    
    NSArray *tags = crm[@"tags"];
    XCTAssert(tags.count == 0);
}

- (void)test_formatterUserValues_fourTags
{
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobile"];
    ORCTag *tagCountry = [[ORCTag alloc] initWithPrefix:@"country"];
    ORCTag *tagGender = [[ORCTag alloc] initWithPrefix:@"gender" name:@"female"];
    ORCTag *tagCity = [[ORCTag alloc] initWithPrefix:@"city" name:@"madrid"];
    
    self.user.tags = @[tagMobile, tagCountry, tagGender, tagCity];
    
    NSDictionary *dictionary = [self.formatter formattedUserData:self.user];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    
    NSArray *tags = crm[@"tags"];
    XCTAssert(tags.count == 4);
    XCTAssert([tags[0] isEqualToString:@"mobile"]);
    XCTAssert([tags[1] isEqualToString:@"country"]);
    XCTAssert([tags[2] isEqualToString:@"gender::female"]);
    XCTAssert([tags[3] isEqualToString:@"city::madrid"]);
}

- (void)test_formatterDeviceValues_twoTags
{
    ORCTag *tagMobile = [[ORCTag alloc] initWithPrefix:@"mobile"];
    ORCTag *tagCountry = [[ORCTag alloc] initWithPrefix:@"country"];
    
    NSArray <ORCTag *> *tags = [NSArray arrayWithObjects:tagMobile, tagCountry, nil];
    
    [self.settingsPersisterMock setDeviceTags:tags];
    
    NSDictionary *dictionary = [self.formatter formatterParameteresDevice];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *device = dictionary[@"device"];
    XCTAssertNotNil(device);
    
    NSArray *tagsForatted = device[@"tags"];
    XCTAssert(tagsForatted.count == 2);
    XCTAssert([tagsForatted[0] isEqualToString:@"mobile"]);
    XCTAssert([tagsForatted[1] isEqualToString:@"country"]);
}

- (void)test_formatter_custom_fields
{
    self.settingsPersisterMock.inUser = self.user;
    ORCCustomField *customFieldName = [[ORCCustomField alloc] initWithKey:@"name"
                                                                    label:@"Name"
                                                                     type:ORCCustomFieldTypeString
                                                                    value:@"Carlos"];
    ORCCustomField *customFieldSurname = [[ORCCustomField alloc] initWithKey:@"surname"
                                                                       label:@"Surname"
                                                                        type:ORCCustomFieldTypeString
                                                                       value:@"Vicente"];
    ORCCustomField *customFieldAge = [[ORCCustomField alloc] initWithKey:@"age"
                                                                   label:@"Age"
                                                                    type:ORCCustomFieldTypeInteger
                                                                   value:nil];
    
    NSArray <ORCCustomField *> *customFields = [NSArray arrayWithObjects:customFieldName, customFieldSurname, customFieldAge, nil];
    [self.settingsPersisterMock setCustomFields:customFields];
    
    NSDictionary *formattedCustomFieldsDict = [self.formatter formattedCustomFields];
    NSArray *formattedCustomFieldsKeys = formattedCustomFieldsDict.allKeys;
    
    for (NSString *key in formattedCustomFieldsKeys)
    {
        NSDictionary *customField = formattedCustomFieldsDict[key];
        XCTAssertNotNil(customField);
    }
    
    XCTAssertNotNil(formattedCustomFieldsKeys);
    XCTAssertTrue(formattedCustomFieldsKeys.count == 2);
}

- (void)test_formatter_userValues_business_units_twoValid_twoInvalid
{
    self.settingsPersisterMock.inUser = self.user;
    
    ORCBusinessUnit *brand = [[ORCBusinessUnit alloc] initWithPrefix:@"brand" name:@"renault"];
    ORCBusinessUnit *color = [[ORCBusinessUnit alloc] initWithPrefix:@"color" name:@"blue"];
    ORCBusinessUnit *weight = [[ORCBusinessUnit alloc] initWithPrefix:@"_weight" name:@"1300"];
    ORCBusinessUnit *doors = [[ORCBusinessUnit alloc] initWithPrefix:@"doors" name:@"/5"];
    
    NSArray <ORCBusinessUnit *> *businessUnits = [NSArray arrayWithObjects:brand, color, weight, doors,  nil];
    [self.settingsPersisterMock setUserBusinessUnit:businessUnits];
    
    NSDictionary *dictionary = [self.formatter formattedUserData:self.user];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *crm = dictionary[@"crm"];
    XCTAssertNotNil(crm);
    
    NSArray *businessUnitsFormatted = crm[@"businessUnits"];
    XCTAssert(businessUnitsFormatted.count == 2);
    XCTAssert([businessUnitsFormatted[0] isEqualToString:@"brand::renault"]);
    XCTAssert([businessUnitsFormatted[1] isEqualToString:@"color::blue"]);
}

- (void)test_formatter_deviceValues_business_units_twoValid_oneInvalid
{
    ORCBusinessUnit *brand = [[ORCBusinessUnit alloc] initWithPrefix:@"brand" name:@"renault"];
    ORCBusinessUnit *color = [[ORCBusinessUnit alloc] initWithPrefix:@"color" name:@"blue"];
    ORCBusinessUnit *weight = [[ORCBusinessUnit alloc] initWithPrefix:@"_weight" name:@"1300"];
    
    NSArray <ORCBusinessUnit *> *businessUnits = [NSArray arrayWithObjects:brand, color, weight,  nil];
    [self.settingsPersisterMock setDeviceBusinessUnits:businessUnits];
    
    NSDictionary *dictionary = [self.formatter formatterParameteresDevice];
    XCTAssertNotNil(dictionary);
    
    NSDictionary *device = dictionary[@"device"];
    XCTAssertNotNil(device);
    
    NSArray *businessUnitsFormatted = device[@"businessUnits"];
    XCTAssert(businessUnitsFormatted.count == 2);
    XCTAssert([businessUnitsFormatted[0] isEqualToString:@"brand::renault"]);
    XCTAssert([businessUnitsFormatted[1] isEqualToString:@"color::blue"]);
}

@end
