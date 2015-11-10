//
//  GIGURLDomainsKeeper.h
//  giglibrary
//
//  Created by Sergio Baró on 14/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORCGIGURLDomain.h"

@class ORCGIGURLStorage;


static NSString * const GIGURLDomainsKeeperDefaultFile = @"domains.json";


@interface ORCGIGURLDomainsKeeper : NSObject

@property (strong, nonatomic) ORCGIGURLDomain *currentDomain;
@property (strong, nonatomic) NSArray *domains;

- (instancetype)initWithStorage:(ORCGIGURLStorage *)storage;

- (void)loadDomainsFromFilename:(NSString *)filename;
- (void)addDomain:(ORCGIGURLDomain *)domain;
- (void)removeDomain:(ORCGIGURLDomain *)domain;
- (void)moveDomain:(ORCGIGURLDomain *)domain toIndex:(NSInteger)destinationIndex;
- (void)replaceDomain:(ORCGIGURLDomain *)oldDomain withDomain:(ORCGIGURLDomain *)newDomain;

@end
