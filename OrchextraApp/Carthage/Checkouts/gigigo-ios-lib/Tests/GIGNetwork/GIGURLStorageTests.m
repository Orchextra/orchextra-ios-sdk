//
//  GIGURLStorageTests.m
//  giglibrary
//
//  Created by Sergio Baró on 13/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>

#import "GIGURLStorage.h"
#import "GIGURLDomain.h"
#import "GIGURLFixture.h"
#import "GIGURLDomain+GIGTesting.h"
#import "NSUserDefaults+GIGArchive.h"


@interface GIGURLStorageTests : XCTestCase

@property (strong, nonatomic) NSBundle *bundleMock;
@property (strong, nonatomic) NSUserDefaults *userDefaultsMock;
@property (strong, nonatomic) GIGURLStorage *storage;

@end


@implementation GIGURLStorageTests

- (void)setUp
{
    [super setUp];
 
    self.bundleMock = MKTMock([NSBundle class]);
    self.userDefaultsMock = MKTMock([NSUserDefaults class]);
    self.storage = [[GIGURLStorage alloc] initWithBundle:self.bundleMock userDefaults:self.userDefaultsMock];
}

- (void)tearDown
{
    self.bundleMock = nil;
    self.userDefaultsMock = nil;
    self.storage = nil;
    
    [super tearDown];
}

#pragma mark - TESTS

- (void)testStoreDomainsArray
{
    GIGURLDomain *domain1 = [[GIGURLDomain alloc] initWithName:@"domain1" url:@"http://url1"];
    GIGURLDomain *domain2 = [[GIGURLDomain alloc] initWithName:@"domain2" url:@"http://url2"];
    NSArray *expectedDomains = @[domain1, domain2];
    
    MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
    [self.storage storeDomains:expectedDomains];
    [MKTVerify(self.userDefaultsMock) archiveObject:[captor capture] forKey:GIGURLManagerDomainsKey];
    NSArray *storedDomains = [captor value];
    
    XCTAssertTrue([expectedDomains isEqualToArray:storedDomains]);
}

@end
