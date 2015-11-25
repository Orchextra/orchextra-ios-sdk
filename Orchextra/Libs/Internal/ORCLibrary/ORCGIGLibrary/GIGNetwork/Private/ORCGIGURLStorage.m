//
//  GIGURLStorage.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "ORCGIGURLStorage.h"

#import "ORCGIGURLDomain.h"
#import "ORCGIGURLFixture.h"
#import "NSBundle+ORCGIGExtension.h"
#import "NSUserDefaults+ORCGIGArchive.h"


NSString * const ORCGIGURLManagerUseFixtureKey = @"ORCGIGURLManagerUseFixtureKey";
NSString * const ORCGIGURLManagerFixtureKey = @"ORCGIGURLManagerFixtureKey";
NSString * const ORCGIGURLManagerFixturesKey = @"ORCGIGURLManagerFixturesKey";

NSString * const ORCGIGURLManagerDomainKey = @"ORCGIGURLManagerDomainKey";
NSString * const ORCGIGURLManagerDomainsKey = @"ORCGIGURLManagerDomainsKey";


@interface ORCGIGURLStorage ()

@property (strong, nonatomic) NSBundle *bundle;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end


@implementation ORCGIGURLStorage

- (instancetype)init
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [self initWithBundle:bundle userDefaults:userDefaults];
}

- (instancetype)initWithBundle:(NSBundle *)bundle userDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self)
    {
        _bundle = bundle;
        _userDefaults = userDefaults;
    }
    return self;
}

#pragma mark - PUBLIC (Fixture)

- (BOOL)loadUseFixture
{
    return [self.userDefaults boolForKey:ORCGIGURLManagerUseFixtureKey];
}

- (void)storeUseFixture:(BOOL)useFixture
{
    [self.userDefaults setBool:useFixture forKey:ORCGIGURLManagerUseFixtureKey];
    [self.userDefaults synchronize];
}

- (ORCGIGURLFixture *)loadFixture
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerFixtureKey];
}

- (void)storeFixture:(ORCGIGURLFixture *)fixture
{
    [self.userDefaults archiveObject:fixture forKey:ORCGIGURLManagerFixtureKey];
    [self.userDefaults synchronize];
}

- (NSArray *)loadFixtures
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerFixturesKey];
}

- (void)storeFixtures:(NSArray *)fixtures
{
    [self.userDefaults archiveObject:fixtures forKey:ORCGIGURLManagerFixturesKey];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Domain)

- (ORCGIGURLDomain *)loadDomain
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerDomainKey];
}

- (void)storeDomain:(ORCGIGURLDomain *)domain
{
    [self.userDefaults archiveObject:domain forKey:ORCGIGURLManagerDomainKey];
    [self.userDefaults synchronize];
}

- (NSArray *)loadDomains
{
    return [self.userDefaults unarchiveObjectForKey:ORCGIGURLManagerDomainsKey];
}

- (void)storeDomains:(NSArray *)domains
{
    [self.userDefaults archiveObject:domains forKey:ORCGIGURLManagerDomainsKey];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Files)

- (NSArray *)loadDomainsFromFile:(NSString *)domainsFilename
{
    NSArray *domainsJSON = [self.bundle loadJSONFile:domainsFilename rootNode:@"domains"];
    
    return [ORCGIGURLDomain domainsWithJSON:domainsJSON];
}

- (NSArray *)loadFixturesFromFile:(NSString *)fixtureFilename
{
    NSArray *fixturesJSON = [self.bundle loadJSONFile:fixtureFilename rootNode:@"fixtures"];
    
    return [ORCGIGURLFixture fixturesWithJSON:fixturesJSON bundle:self.bundle];
}

- (NSData *)loadMockFromFile:(NSString *)filename
{
    return [self.bundle dataForFile:filename];
}



@end
