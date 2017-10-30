//
//  GIGURLDomainsKeeper.m
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLDomainsKeeper.h"

#import "GIGURLStorage.h"


@interface GIGURLDomainsKeeper ()

@property (strong, nonatomic) GIGURLStorage *storage;

@end


@implementation GIGURLDomainsKeeper

- (instancetype)initWithStorage:(GIGURLStorage *)storage
{
    self = [super init];
    if (self)
    {
        _storage = storage;
        
        [self loadDomains];
    }
    return self;
}

#pragma mark - ACCESSORS

- (void)setCurrentDomain:(GIGURLDomain *)currentDomain
{
    _currentDomain = currentDomain;
    
    [self.storage storeDomain:currentDomain];
}

- (void)setDomains:(NSArray *)domains
{
    _domains = domains;
    
    [self.storage storeDomains:domains];
    [self setCurrentDomainIfNeeded];
}

#pragma mark - PUBLIC

- (void)loadDomainsFromFilename:(NSString *)filename
{
    self.domains = [self.storage loadDomainsFromFile:filename];
}

- (void)addDomain:(GIGURLDomain *)domain
{
    NSMutableArray *tempDomains = [self.domains mutableCopy];
    [tempDomains insertObject:domain atIndex:0];
    
    self.domains = [tempDomains copy];
}

- (void)removeDomain:(GIGURLDomain *)domain
{
    NSMutableArray *tempDomains = [self.domains mutableCopy];
    [tempDomains removeObject:domain];
    
    self.domains = [tempDomains copy];
}

- (void)moveDomain:(GIGURLDomain *)domain toIndex:(NSInteger)destinationIndex
{
    NSMutableArray *tempDomains = [self.domains mutableCopy];
    [tempDomains removeObject:domain];
    [tempDomains insertObject:domain atIndex:destinationIndex];
    
    self.domains = [tempDomains copy];
}

- (void)replaceDomain:(GIGURLDomain *)oldDomain withDomain:(GIGURLDomain *)newDomain
{
    NSMutableArray *tempDomains = [self.domains mutableCopy];
    NSInteger index = [tempDomains indexOfObject:oldDomain];
    
    if (index != NSNotFound)
    {
        [tempDomains replaceObjectAtIndex:index withObject:newDomain];
        
        self.domains = [tempDomains copy];
    }
}

#pragma mark - PRIVATE

- (void)loadDomains
{
    _currentDomain = [self.storage loadDomain];
    _domains = [self.storage loadDomains];
    
    if (_domains == nil)
    {
        self.domains = [self.storage loadDomainsFromFile:GIGURLDomainsKeeperDefaultFile];
    }
    
    [self setCurrentDomainIfNeeded];
}

- (void)setCurrentDomainIfNeeded
{
    if (self.currentDomain == nil && self.domains.count > 0)
    {
        self.currentDomain = self.domains[0];
    }
}

@end
