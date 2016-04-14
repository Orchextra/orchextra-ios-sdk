//
//  ORCUserTests.m
//  Orchextra
//
//  Created by Judith Medina on 30/11/15.
//  Copyright © 2015 Gigigo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ORCUser.h"
#import "ORCSettingsInteractor.h"
#import "ORCSettingsPersister.h"
#import "ORCAppConfigCommunicator.h"

@interface ORCUserTests : XCTestCase

@property (nonatomic, strong) ORCUser *user;

@end

@implementation ORCUserTests

- (void)setUp
{
    [super setUp];
    self.user = [[ORCUser alloc] init];
    self.user.deviceToken = @"123456789";
    self.user.birthday = [NSDate dateWithTimeIntervalSince1970:100];
    self.user.gender = ORCGenderMale;
    self.user.crmID = @"crmid";
    self.user.tags = @[@"mobile"];
}

- (void)tearDown
{
    [super tearDown];
    self.user = nil;
}

- (void)test_is_same_user
{
    ORCUser *sameUser = [[ORCUser alloc] init];
    sameUser.deviceToken = @"123456789";
    sameUser.birthday = [NSDate dateWithTimeIntervalSince1970:100];
    sameUser.gender = ORCGenderMale;
    sameUser.crmID = @"crmid";
    sameUser.tags = @[@"mobile"];
    
    XCTAssertTrue([sameUser isSameUser:self.user]);
}

- (void)test_is_same_user_with_nil_values
{
    ORCUser *user1 = [[ORCUser alloc] init];
    user1.deviceToken = nil;
    user1.birthday = nil;
    user1.crmID = nil;
    user1.tags = nil;
    
    ORCUser *user2 = [[ORCUser alloc] init];
    user2.deviceToken = nil;
    user2.birthday = nil;
    user2.crmID = nil;
    user2.tags = nil;
    
    XCTAssertTrue([user2 isSameUser:user1]);
}

- (void)test_is_same_user_with_birthday_crmid_tags_nil
{
    ORCUser *user1 = [[ORCUser alloc] init];
    user1.deviceToken = @"123456789";
    user1.birthday = nil;
    user1.crmID = nil;
    user1.tags = nil;
    user1.gender = ORCGenderNone;

    ORCUser *user2 = [[ORCUser alloc] init];
    user2.deviceToken = @"123456789";
    user2.birthday = nil;
    user2.crmID = nil;
    user2.tags = nil;
    user2.gender = ORCGenderNone;
    
    XCTAssertTrue([user2 isSameUser:user1]);
}

- (void)test_is_not_same_user
{
    ORCUser *user1 = [[ORCUser alloc] init];
    user1.deviceToken = @"123456789";
    user1.birthday = nil;
    user1.crmID = nil;
    user1.tags = nil;
    user1.gender = ORCGenderNone;
    
    XCTAssertFalse([self.user isSameUser:user1]);
}

- (void)test_not_same_user_different_birthday
{
    ORCUser *user1 = [[ORCUser alloc] init];
    user1.deviceToken = @"123456789";
    user1.birthday = [NSDate dateWithTimeIntervalSince1970:10000];
    user1.crmID = @"crmid";
    user1.tags = @[@"mobile"];
    user1.gender = ORCGenderMale;
    
    XCTAssertFalse([self.user isSameUser:user1]);
}

@end
