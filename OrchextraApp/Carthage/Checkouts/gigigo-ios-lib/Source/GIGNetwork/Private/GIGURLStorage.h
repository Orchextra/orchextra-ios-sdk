//
//  GIGURLStorage.h
//  gignetwork
//
//  Created by Sergio Baró on 06/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GIGURLDomain;
@class GIGURLFixture;


extern NSString * const GIGURLManagerUseFixtureKey;
extern NSString * const GIGURLManagerFixtureKey;
extern NSString * const GIGURLManagerFixturesKey;

extern NSString * const GIGURLManagerDomainKey;
extern NSString * const GIGURLManagerDomainsKey;


@interface GIGURLStorage : NSObject

- (instancetype)initWithBundle:(NSBundle *)bundle userDefaults:(NSUserDefaults *)userDefaults;

// fixture
- (BOOL)loadUseFixture;
- (void)storeUseFixture:(BOOL)useFixture;

- (GIGURLFixture *)loadFixture;
- (void)storeFixture:(GIGURLFixture *)fixture;

// domain
- (GIGURLDomain *)loadDomain;
- (void)storeDomain:(GIGURLDomain *)domain;

- (NSArray *)loadDomains;
- (void)storeDomains:(NSArray *)domains;

// files
- (NSArray *)loadDomainsFromFile:(NSString *)domainsFilename;
- (NSArray *)loadFixturesFromFile:(NSString *)fixtureFilename;
- (NSData *)loadMockFromFile:(NSString *)filename;

@end
