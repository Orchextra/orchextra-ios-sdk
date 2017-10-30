//
//  GIGURLDomainsKeeperTests.m
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <OCMockitoIOS/OCMockitoIOS.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "GIGURLDomainsKeeper.h"
#import "GIGURLDomain.h"
#import "GIGURLStorage.h"
#import "GIGURLDomain+GIGTesting.h"


@interface GIGURLDomainsKeeperTests : XCTestCase

@property (strong, nonatomic) GIGURLStorage *storageMock;
@property (strong, nonatomic) GIGURLDomainsKeeper *keeper;

@end


@implementation GIGURLDomainsKeeperTests

- (void)setUp
{
    [super setUp];
    
    self.storageMock = MKTMock([GIGURLStorage class]);
    self.keeper = [[GIGURLDomainsKeeper alloc] initWithStorage:self.storageMock];
}

- (void)tearDown
{
    self.storageMock = nil;
    self.keeper = nil;
    
    [super tearDown];
}

#pragma mark - TESTS (Load domains)

- (void)test_load_no_domains
{
    [MKTGiven([self.storageMock loadDomain]) willReturn:nil];
    [MKTGiven([self.storageMock loadDomains]) willReturn:nil];
    [MKTGiven([self.storageMock loadDomainsFromFile:nil]) willReturn:nil];
    
    GIGURLDomainsKeeper *keeper = [[GIGURLDomainsKeeper alloc] initWithStorage:self.storageMock];
    XCTAssertNil(keeper.currentDomain);
    XCTAssertNil(keeper.domains);
}

- (void)test_first_load
{
    NSArray *fileDomains = [GIGURLDomain buildDomains:3];
    
    [MKTGiven([self.storageMock loadDomain]) willReturn:nil];
    [MKTGiven([self.storageMock loadDomains]) willReturn:nil];
    [MKTGiven([self.storageMock loadDomainsFromFile:GIGURLDomainsKeeperDefaultFile]) willReturn:fileDomains];
    
    GIGURLDomainsKeeper *keeper = [[GIGURLDomainsKeeper alloc] initWithStorage:self.storageMock];
    XCTAssertTrue([keeper.currentDomain isEqualToDomain:fileDomains[0]]);
    XCTAssertTrue([keeper.domains isEqualToArray:fileDomains]);
}

- (void)test_load_with_stored_domains
{
    NSString *domainsFile = @"domains.json";
    NSArray *fileDomains = [GIGURLDomain buildDomains:3];
    NSArray *storedDomains = [GIGURLDomain buildDomains:4];
    
    [MKTGiven([self.storageMock loadDomain]) willReturn:nil];
    [MKTGiven([self.storageMock loadDomains]) willReturn:storedDomains];
    [MKTGiven([self.storageMock loadDomainsFromFile:domainsFile]) willReturn:fileDomains];
    
    GIGURLDomainsKeeper *keeper = [[GIGURLDomainsKeeper alloc] initWithStorage:self.storageMock];
    XCTAssertTrue([keeper.currentDomain isEqualToDomain:storedDomains[0]]);
    XCTAssertTrue([keeper.domains isEqualToArray:storedDomains]);
}

- (void)test_load_with_stored_domains_and_current_domain
{
    NSString *domainsFilename = @"domains.json";
    NSArray *fileDomains = [GIGURLDomain buildDomains:3];
    NSArray *storedDomains = [GIGURLDomain buildDomains:4];
    
    [MKTGiven([self.storageMock loadDomain]) willReturn:storedDomains[2]];
    [MKTGiven([self.storageMock loadDomains]) willReturn:storedDomains];
    [MKTGiven([self.storageMock loadDomainsFromFile:domainsFilename]) willReturn:fileDomains];
    
    GIGURLDomainsKeeper *keeper = [[GIGURLDomainsKeeper alloc] initWithStorage:self.storageMock];
    XCTAssertTrue([keeper.currentDomain isEqualToDomain:storedDomains[2]]);
    XCTAssertTrue([keeper.domains isEqualToArray:storedDomains]);
}

- (void)test_set_domains
{
    NSArray *domains = [GIGURLDomain buildDomains:3];
    self.keeper.domains = domains;
    
    XCTAssertTrue([self.keeper.domains isEqualToArray:domains]);
    XCTAssertTrue([self.keeper.currentDomain isEqualToDomain:domains[0]]);
    
    [MKTVerify(self.storageMock) storeDomains:domains];
    [MKTVerify(self.storageMock) storeDomain:domains[0]];
}

- (void)test_set_domains_filename
{
    NSString *domainsFilename = @"domains.json";
    NSArray *fileDomains = [GIGURLDomain buildDomains:3];
    
    [MKTGiven([self.storageMock loadDomainsFromFile:domainsFilename]) willReturn:fileDomains];
    
    [self.keeper loadDomainsFromFilename:domainsFilename];
    
    XCTAssertTrue([self.keeper.domains isEqualToArray:fileDomains]);
    XCTAssertTrue([self.keeper.currentDomain isEqualToDomain:fileDomains[0]]);
}

#pragma mark - TESTS (Change current domain)

- (void)test_set_current_domain
{
    GIGURLDomain *domain = [[GIGURLDomain alloc] initWithName:@"domain" url:@"http://url"];
    self.keeper.currentDomain = domain;
    
    XCTAssertTrue([self.keeper.currentDomain isEqualToDomain:domain]);
    
    [MKTVerify(self.storageMock) storeDomain:domain];
}

#pragma mark - TESTS (Add domain)

- (void)test_add_domain
{
    NSArray *domains = [GIGURLDomain buildDomains:2];
    self.keeper.domains = domains;
    
    GIGURLDomain *addDomain = [[GIGURLDomain alloc] initWithName:@"domain" url:@"http://url"];
    [self.keeper addDomain:addDomain];
    
    NSArray *expectedDomains = @[addDomain, domains[0], domains[1]];
    
    XCTAssertTrue([self.keeper.domains isEqualToArray:expectedDomains]);
    
    [MKTVerify(self.storageMock) storeDomains:expectedDomains];
    
}

#pragma mark - TESTS (Remove domain)

- (void)test_remove_domain
{
    NSArray *domains = [GIGURLDomain buildDomains:4];
    self.keeper.domains = domains;
    
    GIGURLDomain *removeDomain = domains[2];
    
    [self.keeper removeDomain:removeDomain];
    
    NSArray *expectedDomains = @[domains[0], domains[1], domains[3]];
    
    XCTAssertTrue([self.keeper.domains isEqualToArray:expectedDomains]);
    
    [MKTVerify(self.storageMock) storeDomains:expectedDomains];
}

#pragma mark - TESTS (Move domain)

- (void)test_move_domain
{
    NSArray *domains = [GIGURLDomain buildDomains:4];
    self.keeper.domains = domains;
    
    GIGURLDomain *moveDomain = domains[1];
    
    [self.keeper moveDomain:moveDomain toIndex:3];
    
    NSArray *expectedDomains = @[domains[0], domains[2], domains[3], domains[1]];
    
    XCTAssertTrue([self.keeper.domains isEqualToArray:expectedDomains]);
    
    [MKTVerify(self.storageMock) storeDomains:expectedDomains];
}

#pragma mark - TESTS (Replace domain)

- (void)test_replace_domain
{
    NSArray *domains = [GIGURLDomain buildDomains:3];
    
    self.keeper.domains = domains;
    
    GIGURLDomain *oldDomain = domains[1];
    GIGURLDomain *newDomain = [[GIGURLDomain alloc] initWithName:@"new" url:@"http://new"];
    
    [self.keeper replaceDomain:oldDomain withDomain:newDomain];
    
    NSArray *expectedDomains = @[domains[0], newDomain, domains[2]];
    XCTAssertTrue([self.keeper.domains isEqualToArray:expectedDomains]);
}

@end
