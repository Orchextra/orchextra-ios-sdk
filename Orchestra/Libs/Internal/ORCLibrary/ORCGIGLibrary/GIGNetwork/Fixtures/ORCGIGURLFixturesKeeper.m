//
//  GIGURLFixturesKeeper.m
//  giglibrary
//
//  Created by Sergio Baró on 15/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLFixturesKeeper.h"

#import "ORCGIGURLStorage.h"


@interface ORCGIGURLFixturesKeeper ()

@property (strong, nonatomic) ORCGIGURLStorage *storage;

@end


@implementation ORCGIGURLFixturesKeeper

- (instancetype)initWithStorage:(ORCGIGURLStorage *)storage
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

- (void)setCurrentFixture:(ORCGIGURLFixture *)currentFixture
{
    _currentFixture = currentFixture;
    
    [self.storage storeFixture:currentFixture];
}

- (void)setFixtures:(NSArray *)fixtures
{
    _fixtures = fixtures;
    
    [self.storage storeFixtures:fixtures];
}

#pragma mark - PUBLIC

- (void)loadFixturesFromFile:(NSString *)fixtureFilename
{
    self.fixtures = [self.storage loadFixturesFromFile:fixtureFilename];
}

- (NSData *)mockForRequestTag:(NSString *)requestTag
{
    NSString *mockFileName = self.currentFixture.mocks[requestTag];
    
    if (mockFileName.length == 0) return nil;
    
    return [self.storage loadMockFromFile:mockFileName];
}

#pragma mark - PRIVATE

- (void)loadFixtures
{
    _useFixture = [self.storage loadUseFixture];
    _currentFixture = [self.storage loadFixture];
    _fixtures = [self.storage loadFixtures];
    
    if (_fixtures.count == 0)
    {
        self.fixtures = [self.storage loadFixturesFromFile:GIGURLFixturesKeeperDefaultFile];
    }
    
    if (self.currentFixture == nil && self.fixtures.count > 0)
    {
        self.currentFixture = self.fixtures[0];
    }
}

@end
