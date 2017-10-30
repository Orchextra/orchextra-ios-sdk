//
//  GIGURLDomainsKeeper.h
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGURLDomain.h"

@class GIGURLStorage;


static NSString * const GIGURLDomainsKeeperDefaultFile = @"domains.json";


@interface GIGURLDomainsKeeper : NSObject

@property (strong, nonatomic) GIGURLDomain *currentDomain;
@property (strong, nonatomic) NSArray *domains;

- (instancetype)initWithStorage:(GIGURLStorage *)storage;

- (void)loadDomainsFromFilename:(NSString *)filename;
- (void)addDomain:(GIGURLDomain *)domain;
- (void)removeDomain:(GIGURLDomain *)domain;
- (void)moveDomain:(GIGURLDomain *)domain toIndex:(NSInteger)destinationIndex;
- (void)replaceDomain:(GIGURLDomain *)oldDomain withDomain:(GIGURLDomain *)newDomain;

@end
