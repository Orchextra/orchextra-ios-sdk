//
//  GIGURLManager.h
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 18/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORCGIGURLDomain.h"
#import "ORCGIGURLFixture.h"

@class ORCGIGURLDomainsKeeper;
@class ORCGIGURLFixturesKeeper;


extern NSString * const ORCGIGURLManagerDidChangeCurrentDomainNotification;
extern NSString * const ORCGIGURLManagerDidChangeDomainsNotification;
extern NSString * const ORCGIGURLManagerDomainUserInfoKey;
extern NSString * const ORCGIGURLManagerDidChangeFixtureNotification;
extern NSString * const ORCGIGURLManagerFixtureUserInfoKey;


@interface ORCGIGURLManager : NSObject

// fixtures
@property (assign, nonatomic) BOOL useFixture;
@property (strong, nonatomic) ORCGIGURLFixture *fixture;
@property (strong, nonatomic) NSArray *fixtures;

// domains
@property (strong, nonatomic) ORCGIGURLDomain *domain;
@property (strong, nonatomic) NSArray *domains;

+ (instancetype)sharedManager;

- (instancetype)initWithDomainsKeeper:(ORCGIGURLDomainsKeeper *)domainsKeeper
                       fixturesKeeper:(ORCGIGURLFixturesKeeper *)fixturesKeeper
                   notificationCenter:(NSNotificationCenter *)notificationCenter;

- (NSData *)fixtureForRequestTag:(NSString *)requestTag;
- (void)showConfig;

- (void)loadFixturesFile:(NSString *)fixturesFilename;

- (void)loadDomainsFile:(NSString *)domainsFilename;
- (void)addDomain:(ORCGIGURLDomain *)domain;
- (void)removeDomain:(ORCGIGURLDomain *)domain;
- (void)moveDomain:(ORCGIGURLDomain *)domain toIndex:(NSInteger)destinationIndex;
- (void)updateDomain:(ORCGIGURLDomain *)domain withDomain:(ORCGIGURLDomain *)newDomain;

@end
