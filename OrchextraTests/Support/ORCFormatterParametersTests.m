//
//  ORCDeviceStorageTests.m
//  Orchestra
//
//  Created by Judith Medina on 8/7/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ORCFormatterParameters.h"
#import "ORCUserLocationPersisterMock.h"
#import "ORCSettingsPersisterMock.h"
#import "ORCDevice.h"
#import "ORCUser.h"

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
    self.user.tags = @[@"mobile"];

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
    XCTAssertTrue([crm[@"keywords"] isEqualToArray:@[@"mobile"]]);
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


@end
