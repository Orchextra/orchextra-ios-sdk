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

#import "ORCStorage.h"
#import "ORCLocationStorage.h"
#import "ORCUser.h"
#import "ORCAppConfigCommunicator.h"

@interface ORCStorageTests : XCTestCase

@property (strong, nonatomic) ORCStorage *storage;
@property (strong, nonatomic) ORCLocationStorage *locationStorageMock;
@property (strong, nonatomic) ORCAppConfigCommunicator *communicatorMock;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation ORCStorageTests

- (void)setUp
{
    [super setUp];
    self.locationStorageMock = MKTMock([ORCLocationStorage class]);
    self.userDefaults = [[NSUserDefaults alloc] init];
    self.storage = [[ORCStorage alloc] initWithUserDefaults:self.userDefaults
                                            locationStorage:self.locationStorageMock];
}

- (void)tearDown
{
    [super tearDown];
    
    self.storage = nil;
    self.communicatorMock = nil;
    self.userDefaults = nil;
}

- (void)test_store_userData
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSDate *birth = [NSDate date];
    
    ORCUser *userData = [[ORCUser alloc] init];
    userData.crmID = uuid;
    userData.birthday = birth;
    userData.gender = ORCGenderFemale;
    userData.tags = @[@"Spain", @"Fashion"];
    
    [self.storage storeUserData:userData];
    
    // VERIFY
    ORCUser *retrieveUser = [self.storage loadCurrentUserData];
    XCTAssertNotNil(retrieveUser);
    XCTAssertTrue([retrieveUser.crmID isEqual:userData.crmID]);
    XCTAssertTrue([retrieveUser.birthday isEqual:userData.birthday]);
    XCTAssertTrue([[retrieveUser genderUser] isEqual:[userData genderUser]]);
    XCTAssertTrue([retrieveUser.tags isEqual:userData.tags]);
}

- (void)test_store_userData_tags_nil
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    ORCUser *userData = [[ORCUser alloc] init];
    userData.crmID = uuid;
    userData.birthday = [NSDate date];
    userData.gender = ORCGenderFemale;
    
    [self.storage storeUserData:userData];
    
    ORCUser *retrieveUser = [self.storage loadCurrentUserData];
    XCTAssertNil(retrieveUser.tags);
}



@end
