//
//  GIGURLFixturesKeeperTests.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSData+GIGExtension.h"
#import "GIGTests.h"

#import "GIGURLStorage.h"
#import "GIGURLFixturesKeeper.h"
#import "GIGURLFixture+GIGTesting.h"


@interface GIGURLFixturesKeeperTests : XCTestCase

@property (strong, nonatomic) GIGURLStorage *storageMock;
@property (strong, nonatomic) NSArray<GIGURLFixture *> *fixtures;

@end


@implementation GIGURLFixturesKeeperTests

- (void)setUp
{
    [super setUp];
    
    self.storageMock = MKTMock([GIGURLStorage class]);
    self.fixtures = [GIGURLFixture buildFixtures:3];
}

#pragma mark - TESTS

- (void)test_first_values_load_default_file
{
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:NO];
    [MKTGiven([self.storageMock loadFixture]) willReturn:nil];
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:self.fixtures];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue([keeper.fixtures isEqualToArray:self.fixtures]);
    XCTAssertTrue([keeper.currentFixture isEqualToFixture:self.fixtures[0]]);
}

- (void)test_first_values
{
    GIGURLFixture *currentFixture = self.fixtures[1];
    
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:YES];
    [MKTGiven([self.storageMock loadFixture]) willReturn:currentFixture];
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:self.fixtures];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue(keeper.useFixture);
    XCTAssertTrue([keeper.currentFixture isEqualToFixture:currentFixture]);
    XCTAssertTrue([keeper.fixtures isEqualToArray:self.fixtures]);
}
    
- (void)test_first_values_no_fixtures
{
    GIGURLFixture *currentFixture = [[GIGURLFixture alloc] initWithName:@"fixture" mocks:@{@"request_tag": @"mock_file"}];
    
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:NO];
    [MKTGiven([self.storageMock loadFixture]) willReturn:currentFixture];
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:nil];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue(keeper.fixtures == nil);
    XCTAssertTrue(keeper.currentFixture == nil);
}

- (void)test_first_values_current_fixture_no_exists_should_be_replaced
{
    GIGURLFixture *currentFixture = [[GIGURLFixture alloc] initWithName:@"fixture_old" mocks:nil];
    
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:YES];
    [MKTGiven([self.storageMock loadFixture]) willReturn:currentFixture];
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:self.fixtures];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue(keeper.useFixture);
    XCTAssertTrue([keeper.currentFixture isEqualToFixture:self.fixtures[0]], @"%@", keeper.currentFixture.name);
    XCTAssertTrue([keeper.fixtures isEqualToArray:self.fixtures]);
}

- (void)test_first_values_current_fixture_has_changed_should_be_replaced
{
    GIGURLFixture *currentFixture = [[GIGURLFixture alloc] initWithName:@"fixture2" mocks:nil];
    
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:YES];
    [MKTGiven([self.storageMock loadFixture]) willReturn:currentFixture];
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:self.fixtures];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue(keeper.useFixture);
    XCTAssertTrue([keeper.currentFixture isEqualToFixture:self.fixtures[1]], @"%@", keeper.currentFixture.name);
    XCTAssertTrue([keeper.fixtures isEqualToArray:self.fixtures]);
}

- (void)test_is_fixture_defined_for_request_tag
{
    GIGURLFixture *currentFixture = [[GIGURLFixture alloc] initWithName:@"fixture1" mocks:@{@"request_tag": @"mock_file"}];
    NSArray *fixtures = @[currentFixture];
    
    [MKTGiven([self.storageMock loadUseFixture]) willReturnBool:YES];
    [MKTGiven([self.storageMock loadFixture]) willReturn:currentFixture];
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:fixtures];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue([keeper isMockDefinedForRequestTag:@"request_tag"]);
    XCTAssertFalse([keeper isMockDefinedForRequestTag:@"request"]);
}

- (void)test_mock_for_request_tag_found
{
    GIGURLFixture *currentFixture = [[GIGURLFixture alloc] initWithName:@"fixture1" mocks:@{@"request_tag": @"mock_file"}];
    NSArray *fixtures = @[currentFixture];
    
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:fixtures];
    
    NSData *data = [NSData randomData];
    
    [MKTGiven([self.storageMock loadMockFromFile:@"mock_file"]) willReturn:data];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue([[keeper mockForRequestTag:@"request_tag"] isEqualToData:data]);
}

- (void)test_mock_for_request_tag_not_found
{
    GIGURLFixture *currentFixture = [[GIGURLFixture alloc] initWithName:@"fixture1" mocks:@{@"request_tag": @"mock_file"}];
    NSArray *fixtures = @[currentFixture];
    
    [MKTGiven([self.storageMock loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile]) willReturn:fixtures];
    [MKTGiven([self.storageMock loadMockFromFile:@"mock_file"]) willReturn:nil];
    
    GIGURLFixturesKeeper *keeper = [[GIGURLFixturesKeeper alloc] initWithStorage:self.storageMock];
    
    XCTAssertTrue([keeper mockForRequestTag:@"request_tag"] == nil);
}

@end
