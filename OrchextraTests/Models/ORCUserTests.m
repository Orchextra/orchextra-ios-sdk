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
#import "ORCConfigurationInteractor.h"
#import "ORCStorage.h"
#import "ORCAppConfigCommunicator.h"

@interface ORCUserTests : XCTestCase

@property (nonatomic, strong) ORCConfigurationInteractor *interactorMock;
@property (nonatomic, strong) ORCUser *user;


@end

@implementation ORCUserTests

- (void)setUp
{
    [super setUp];
    
    self.interactorMock = MKTMock([ORCConfigurationInteractor class]);
    self.user = [[ORCUser alloc] initWithConfigurationInteractor:self.interactorMock];
}

- (void)tearDown
{
    [super tearDown];
    
    self.interactorMock = nil;
    self.user = nil;
}

- (void)test_user_empty_with_devicetoken
{
    NSString *deviceToken = @"3ba4a4385fbb6ee902ff471c4ff78bb0aa0f069da6c62f18ac0d9a26a38532c7";
    self.user.deviceToken = deviceToken;
    [self.user saveUser];
    
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.interactorMock) saveUserData:[captor capture]];
    
    ORCUser *userToBeSaved = [captor value];
    XCTAssertTrue([userToBeSaved.deviceToken isEqualToString:deviceToken]);
    XCTAssertNil(userToBeSaved.crmID);
    XCTAssertNil(userToBeSaved.birthday);
    XCTAssertNil(userToBeSaved.tags);
}

- (void)test_user_not_empty_with_deviceToken
{
    NSDate *birthday = [NSDate date];
    NSString *deviceToken = @"3ba4a4385fbb6ee902ff471c4ff78bb0aa0f069da6c62f18ac0d9a26a38532c7";
    NSString *crmid1 = @"CRMID_01";
    NSArray *tags = @[@"Mobile", @"London"];

    self.user.deviceToken = deviceToken;
    self.user.birthday = birthday;
    self.user.gender = ORCGenderMale;
    self.user.crmID = crmid1;
    self.user.tags = tags;
    [self.user saveUser];
    
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [MKTVerify(self.interactorMock) saveUserData:[captor capture]];
    
    ORCUser *userToBeSaved = [captor value];
    
    XCTAssertTrue([userToBeSaved.deviceToken isEqualToString:deviceToken]);
    XCTAssertTrue([userToBeSaved.crmID isEqualToString:crmid1]);
    XCTAssertTrue([userToBeSaved.birthday isEqualToDate:birthday]);
    XCTAssertTrue([userToBeSaved.tags isEqualToArray:tags]);
    XCTAssertTrue([[userToBeSaved genderUser] isEqualToString:@"m"]);
}

- (void)test_birth_formatted_sent_to_server
{
    NSDate *birthday = [self convertToDate:@"1987-05-28"];
    self.user.birthday = birthday;
    
    NSString *birthdayString = [self.user birthdayFormatted];
   
    XCTAssertTrue([birthdayString isEqualToString:@"1987-05-28"]);
}


- (void)test_genderUser_female
{
    self.user.gender = ORCGenderFemale;
    NSString *gender = [self.user genderUser];
    XCTAssert([gender isEqualToString:@"f"]);
}

- (void)test_genderUser_male
{
    self.user.gender = ORCGenderMale;
    NSString *gender = [self.user genderUser];
    XCTAssert([gender isEqualToString:@"m"]);
}

- (void)test_genderUser_default
{
    NSString *gender = [self.user genderUser];
    XCTAssert([gender isEqualToString:@"m"]);
}

- (void)test_not_same_user
{
    ORCUser *user1 = [[ORCUser alloc] initWithConfigurationInteractor:self.interactorMock];
    user1.birthday = [NSDate dateWithTimeIntervalSinceNow:10];
    user1.crmID = @"crmid1";
    user1.tags = @[@"Mobile"];
    user1.deviceToken = @"3ba4a4385fbb6ee902ff471c4ff78bb0aa0f069da6c62f18ac0d9a26a38532c7";
    
    ORCUser *user2 = [[ORCUser alloc] initWithConfigurationInteractor:self.interactorMock];
    user2.birthday = [NSDate dateWithTimeIntervalSinceNow:10];
    user2.crmID = @"crmid2";
    user2.tags = @[@"Mobile"];
    user2.deviceToken = @"adda4385fbb6ee902ff4asdfasdc4ff78bb0aa0f069da6c62f18ac0d9a26a3222fc7";
    
    XCTAssertFalse([user1 isSameUser:user2]);
}

- (void)test_same_user
{
    ORCUser *user1 = [[ORCUser alloc] initWithConfigurationInteractor:self.interactorMock];
    user1.birthday = [self convertToDate:@"1987-05-28"];
    user1.crmID = @"crmid1";
    user1.tags = @[@"Mobile"];
    user1.deviceToken = @"3ba4a4385fbb6ee902ff471c4ff78bb0aa0f069da6c62f18ac0d9a26a38532c7";
    
    ORCUser *user2 = [[ORCUser alloc] initWithConfigurationInteractor:self.interactorMock];
    user2.birthday = [self convertToDate:@"1987-05-28"];
    user2.crmID = @"crmid1";
    user2.tags = @[@"Mobile"];
    user2.deviceToken = @"3ba4a4385fbb6ee902ff471c4ff78bb0aa0f069da6c62f18ac0d9a26a38532c7";
    
    XCTAssertTrue([user1 isSameUser:user2]);
}

- (void)test_current_user_not_nil
{
    ORCUser *user1 = [[ORCUser alloc] initWithConfigurationInteractor:self.interactorMock];
    user1.birthday = [self convertToDate:@"1987-05-28"];
    user1.crmID = @"crmid1";
    user1.tags = @[@"Mobile"];
    user1.deviceToken = @"3ba4a4385fbb6ee902ff471c4ff78bb0aa0f069da6c62f18ac0d9a26a38532c7";
    [user1 saveUser];
    
    [MKTGiven([self.interactorMock currentUser]) willReturn:user1];
    ORCUser *userSaved = [self.user.interactor currentUser];
    
    XCTAssertNotNil(userSaved);
    XCTAssertTrue([userSaved.deviceToken isEqualToString:user1.deviceToken]);
    XCTAssertTrue([userSaved.crmID isEqualToString:user1.crmID]);
    XCTAssertTrue([userSaved.birthday isEqualToDate:user1.birthday]);
    XCTAssertTrue([userSaved.tags isEqualToArray:user1.tags]);
    XCTAssertTrue([[userSaved genderUser] isEqualToString:user1.genderUser]);
}

- (void)test_current_user_from_saved
{
    ORCUser *user = [ORCUser currentUser];
    XCTAssertNotNil(user);
}

#pragma mark - HELPERS

- (NSDate *)convertToDate:(NSString *)dateString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}
@end
