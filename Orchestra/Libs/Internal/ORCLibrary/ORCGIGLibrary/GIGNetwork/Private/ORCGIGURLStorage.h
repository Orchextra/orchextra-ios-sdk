//
//  GIGURLStorage.h
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORCGIGURLDomain;
@class ORCGIGURLFixture;


extern NSString * const ORCGIGURLManagerUseFixtureKey;
extern NSString * const ORCGIGURLManagerFixtureKey;
extern NSString * const ORCGIGURLManagerFixturesKey;

extern NSString * const ORCGIGURLManagerDomainKey;
extern NSString * const ORCGIGURLManagerDomainsKey;


@interface ORCGIGURLStorage : NSObject

- (instancetype)initWithBundle:(NSBundle *)bundle userDefaults:(NSUserDefaults *)userDefaults;

// fixture
- (BOOL)loadUseFixture;
- (void)storeUseFixture:(BOOL)useFixture;

- (ORCGIGURLFixture *)loadFixture;
- (void)storeFixture:(ORCGIGURLFixture *)fixture;

- (NSArray *)loadFixtures;
- (void)storeFixtures:(NSArray *)fixtures;

// domain
- (ORCGIGURLDomain *)loadDomain;
- (void)storeDomain:(ORCGIGURLDomain *)domain;

- (NSArray *)loadDomains;
- (void)storeDomains:(NSArray *)domains;

// files
- (NSArray *)loadDomainsFromFile:(NSString *)domainsFilename;
- (NSArray *)loadFixturesFromFile:(NSString *)fixtureFilename;
- (NSData *)loadMockFromFile:(NSString *)filename;




@end
