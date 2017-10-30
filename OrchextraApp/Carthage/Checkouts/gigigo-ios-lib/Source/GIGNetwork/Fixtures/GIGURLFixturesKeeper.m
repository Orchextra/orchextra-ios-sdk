//
//  GIGURLFixturesKeeper.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLFixturesKeeper.h"

#import "GIGURLStorage.h"
#import "NSArray+GIGExtension.h"


@interface GIGURLFixturesKeeper ()

@property (strong, nonatomic) GIGURLStorage *storage;

@end


@implementation GIGURLFixturesKeeper

- (instancetype)initWithStorage:(GIGURLStorage *)storage
{
    self = [super init];
    if (self)
    {
        _storage = storage;
        
        [self loadFixtures];
    }
    return self;
}

#pragma mark - ACCESSORS

- (void)setUseFixture:(BOOL)useFixture
{
    _useFixture = useFixture;
    
    [self.storage storeUseFixture:useFixture];
}

- (void)setCurrentFixture:(GIGURLFixture *)currentFixture
{
    _currentFixture = currentFixture;
    
    [self.storage storeFixture:currentFixture];
}

#pragma mark - PUBLIC

- (NSData *)mockForRequestTag:(NSString *)requestTag
{
    NSString *mockFileName = self.currentFixture.mocks[requestTag];
    if (mockFileName.length == 0) return nil;
    
    return [self.storage loadMockFromFile:mockFileName];
}

- (NSData *)mockWithFilename:(NSString *)mockFileName
{
    return [self.storage loadMockFromFile:mockFileName];
}

- (BOOL)isMockDefinedForRequestTag:(NSString *)requestTag
{
    NSString *mockFileName = self.currentFixture.mocks[requestTag];
    
    return (mockFileName.length > 0);
}

#pragma mark - PRIVATE

- (void)loadFixtures
{
    _useFixture = [self.storage loadUseFixture];
    _currentFixture = [self.storage loadFixture];
    _fixtures = [self.storage loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile];
    
    NSArray *fixturesWithName = [self.fixtures filteredArrayWithBlock:^BOOL(GIGURLFixture *fixture) {
        return [fixture.name isEqualToString:self.currentFixture.name];
    }];
    
    if (fixturesWithName.count > 0)
    {
        self.currentFixture = fixturesWithName[0];
    }
    else
    {
        self.currentFixture = self.fixtures.firstObject;
    }
}

@end
