//
//  GIGURLStorage.m
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLStorage.h"

#import "GIGURLDomain.h"
#import "GIGURLFixture.h"
#import "NSBundle+GIGExtension.h"
#import "NSUserDefaults+GIGArchive.h"


NSString * const GIGURLManagerUseFixtureKey = @"GIGURLManagerUseFixtureKey";
NSString * const GIGURLManagerFixtureKey = @"GIGURLManagerFixtureKey";
NSString * const GIGURLManagerFixturesKey = @"GIGURLManagerFixturesKey";

NSString * const GIGURLManagerDomainKey = @"GIGURLManagerDomainKey";
NSString * const GIGURLManagerDomainsKey = @"GIGURLManagerDomainsKey";


@interface GIGURLStorage ()

@property (strong, nonatomic) NSBundle *bundle;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end


@implementation GIGURLStorage

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
    return [self.userDefaults boolForKey:GIGURLManagerUseFixtureKey];
}

- (void)storeUseFixture:(BOOL)useFixture
{
    [self.userDefaults setBool:useFixture forKey:GIGURLManagerUseFixtureKey];
    [self.userDefaults synchronize];
}

- (GIGURLFixture *)loadFixture
{
    return [self.userDefaults unarchiveObjectForKey:GIGURLManagerFixtureKey];
}

- (void)storeFixture:(GIGURLFixture *)fixture
{
    [self.userDefaults archiveObject:fixture forKey:GIGURLManagerFixtureKey];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Domain)

- (GIGURLDomain *)loadDomain
{
    return [self.userDefaults unarchiveObjectForKey:GIGURLManagerDomainKey];
}

- (void)storeDomain:(GIGURLDomain *)domain
{
    [self.userDefaults archiveObject:domain forKey:GIGURLManagerDomainKey];
    [self.userDefaults synchronize];
}

- (NSArray *)loadDomains
{
    return [self.userDefaults unarchiveObjectForKey:GIGURLManagerDomainsKey];
}

- (void)storeDomains:(NSArray *)domains
{
    [self.userDefaults archiveObject:domains forKey:GIGURLManagerDomainsKey];
    [self.userDefaults synchronize];
}

#pragma mark - PUBLIC (Files)

- (NSArray *)loadDomainsFromFile:(NSString *)domainsFilename
{
    NSArray *domainsJSON = [self.bundle loadJSONFile:domainsFilename rootNode:@"domains"];
    
    return [GIGURLDomain domainsWithJSON:domainsJSON];
}

- (NSArray *)loadFixturesFromFile:(NSString *)fixtureFilename
{
    NSArray *fixturesJSON = [self.bundle loadJSONFile:fixtureFilename rootNode:@"fixtures"];
    
    return [GIGURLFixture fixturesWithJSON:fixturesJSON bundle:self.bundle];
}

- (NSData *)loadMockFromFile:(NSString *)filename
{
    return [self.bundle dataForFile:filename];
}

@end
